import 'package:http/http.dart';
import 'package:convert/convert.dart' show hex;
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/src/crypto/formatting.dart' as formatting;
import '/util.dart' as util;
import 'ton.dart';

const rpcUrl = "http://192.168.1.70:7545";
final EthereumAddress contractAddr = EthereumAddress.fromHex(
  '0x5c901b3Bfb52cD94AE2A4d5c111aA48797a1896C',
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

Future<TonAmount> getWTonBalance(
    Web3Client client, String privateKey, EthereumAddress contractAddr) async {
  final creds = EthPrivateKey.fromHex(privateKey);
  final contract =
      await getContract("assets/eth_wton_abi.json", "Bridge", contractAddr);
  final balanceFunction = contract.function('balanceOf');
  final balanceResp = await client.call(
      contract: contract, function: balanceFunction, params: [creds.address]);
  final amount = balanceResp.first as BigInt;
  return TonAmount.inNano(amount);
}

class WTonTransferEvent {
  final EthereumAddress from;
  final EthereumAddress to;
  final TonAmount value;
  final BlockInformation blockInfo;

  WTonTransferEvent(this.from, this.to, this.value, this.blockInfo);
}

Future<List<WTonTransferEvent>> getWTonTransferEvents(
    Web3Client client, String privateKey, EthereumAddress contractAddr) async {
  final creds = EthPrivateKey.fromHex(privateKey);
  final contract =
      await getContract("assets/eth_wton_abi.json", "Bridge", contractAddr);
  final transferEvent = contract.event('Transfer');
  final filter = FilterOptions(
    address: contractAddr,
    topics: contractTopics(transferEvent, creds),
  );
  final logs = await client.getLogs(filter);
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
  return events;
}

String paddedAddress(String hex) => formatting.bytesToHex(
      formatting.hexToBytes(hex),
      include0x: true,
      forcePadLength: 64,
    );

List<List<String>> contractTopics(ContractEvent event, EthPrivateKey creds) => [
      [
        formatting.bytesToHex(event.signature,
            include0x: true, forcePadLength: 64)
      ],
      [],
      [paddedAddress(creds.address.hex)],
    ];
