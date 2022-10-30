import 'package:collection/collection.dart';
import 'package:convert/convert.dart' show hex;
import 'package:flutter/cupertino.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:flutter_trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:http/http.dart';
// ignore: implementation_imports
import 'package:web3dart/src/crypto/formatting.dart' as formatting;
import 'package:web3dart/web3dart.dart';

import '/util.dart' as util;
import 'ton.dart';

const rpcUrl = "http://192.168.1.70:8545";
final EthereumAddress contractAddr = EthereumAddress.fromHex(
  '0x8fCF1054672573B6Fa5c380Da331c6524222414d',
);

Web3Client? _cachedClient;

Web3Client makeClient(String rpcUrl) {
  return Web3Client(rpcUrl, Client());
}

Web3Client getCachedClient() {
  return _cachedClient ??= makeClient(rpcUrl);
}

String getDefaultPrivateKey(HDWallet wallet) {
  return hex.encode(wallet.getKeyForCoin(60).data());
}

EthereumAddress getDefaultAddress(HDWallet wallet) {
  return EthereumAddress.fromHex(
      wallet.getAddressForCoin(TWCoinType.TWCoinTypeEthereum));
}

Future<EtherAmount> getEtherBalance(
    Web3Client client, String privateKey) async {
  final creds = EthPrivateKey.fromHex(privateKey);
  return client.getBalance(creds.address);
}

Future<DeployedContract> getContract(
    String abiPath, String contractName, EthereumAddress contractAddr) async {
  final abiCode = await util.loadAsset(abiPath);
  final contract = DeployedContract(
      ContractAbi.fromJson(abiCode, contractName), contractAddr);
  return contract;
}

Future<TonAmount> getWTonBalance(Web3Client client, EthereumAddress addr,
    EthereumAddress contractAddr) async {
  final contract =
      await getContract("assets/eth_wton_abi.json", "Bridge", contractAddr);
  final balanceFunction = contract.function('balanceOf');
  final balanceResp = await client
      .call(contract: contract, function: balanceFunction, params: [addr]);
  final amount = balanceResp.first as BigInt;
  return TonAmount.inNano(amount);
}

Future<List<WTonTransferEvent>> getWTonTransferEvents(Web3Client client,
    EthereumAddress addr, EthereumAddress contractAddr) async {
  final contract =
      await getContract("assets/eth_wton_abi.json", "Bridge", contractAddr);
  final transferEvent = contract.event('Transfer');
  FilterOptions makeFilter(List<List<String>> topics) => FilterOptions(
        fromBlock: const BlockNum.genesis(),
        toBlock: const BlockNum.current(),
        address: contractAddr,
        topics: topics,
      );
  final logs = [
    ...await client.getLogs(makeFilter(
      [
        ...contractTopics(transferEvent),
        [],
        [paddedAddress(addr.hex)],
      ],
    )),
    ...await client.getLogs(makeFilter(
      [
        ...contractTopics(transferEvent),
        [paddedAddress(addr.hex)],
        [],
      ],
    ))
  ];
  final events = <WTonTransferEvent>[];
  for (var event in logs) {
    final decoded =
        transferEvent.decodeResults(event.topics ?? [], event.data ?? "");

    final from = decoded[0] as EthereumAddress;
    final to = decoded[1] as EthereumAddress;
    final value = decoded[2] as BigInt;
    final blockNumber = "0x${event.blockNum?.toRadixString(16)}";
    final blockInfo =
        await client.getBlockInformation(blockNumber: blockNumber);

    events.add(WTonTransferEvent(from, to, TonAmount.inNano(value), blockInfo));
  }

  var orderedEvents =
      events.sortedBy((e) => e.blockInfo.timestamp).reversed.toList();
  return orderedEvents;
}

Future transferWTon({
  required Web3Client client,
  required Credentials credentials,
  required EthereumAddress contractAddr,
  required EthereumAddress receiver,
  required TonAmount value,
}) async {
  final contract =
      await getContract("assets/eth_wton_abi.json", "Bridge", contractAddr);
  final sendFunction = contract.function('transfer');
  await client.sendTransaction(
    credentials,
    Transaction.callContract(
      contract: contract,
      function: sendFunction,
      parameters: [receiver, value.getInNano],
    ),
  );
}

String paddedAddress(String hex) => formatting.bytesToHex(
      formatting.hexToBytes(hex),
      include0x: true,
      forcePadLength: 64,
    );

List<List<String>> contractTopics(ContractEvent event) => [
      [
        formatting.bytesToHex(event.signature,
            include0x: true, forcePadLength: 64)
      ],
    ];

class WTonTransferEvent {
  final EthereumAddress from;
  final EthereumAddress to;
  final TonAmount value;
  final BlockInformation blockInfo;

  WTonTransferEvent(this.from, this.to, this.value, this.blockInfo);

  @override
  toString() => "from=$from to=$to value=$value";
}

class WTonTransactionList extends ChangeNotifier {
  final List<WTonTransferEvent> txes = [];
  final EthereumAddress addr;

  WTonTransactionList(this.addr);

  int get length => txes.length;

  Future fetch() async {
    txes.clear();
    txes.addAll(await getWTonTransferEvents(
      getCachedClient(),
      addr,
      contractAddr,
    ));
    notifyListeners();
  }
}
