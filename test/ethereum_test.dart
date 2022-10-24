import 'package:flutter/widgets.dart';
import 'package:test/test.dart';
import 'package:web3dart/web3dart.dart';
import 'package:tonswap/ethereum.dart';
import 'package:tonswap/ton.dart';

final EthereumAddress contractAddr = EthereumAddress.fromHex(
  '0x5c901b3Bfb52cD94AE2A4d5c111aA48797a1896C',
);
const privateKey =
    '25b6431c25daea0c3daf39794b298cc14785717edc2de398f80ea5188a0eb5aa';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final client = makeClient(rpcUrl);
  test("client connection", () async {
    expect(await client.getChainId(), BigInt.from(1337));
  });

  group("wton", () {
    test("balance", () async {
      expect(
        await getWTonBalance(client, privateKey, contractAddr),
        TonAmount.inTon(123),
      );
    });
  });
}
