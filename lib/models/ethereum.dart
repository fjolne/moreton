import 'package:http/http.dart';
import 'package:convert/convert.dart' show hex;
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:web3dart/web3dart.dart';
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
