import 'package:flutter/widgets.dart';
import 'package:moreton/models/ethereum.dart';
import 'package:moreton/models/ton.dart';
import 'package:test/test.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/src/crypto/formatting.dart' as formatting;

final EthereumAddress contractAddr = EthereumAddress.fromHex(
  '0x8fCF1054672573B6Fa5c380Da331c6524222414d',
);
const privateKey =
    '25b6431c25daea0c3daf39794b298cc14785717edc2de398f80ea5188a0eb5aa';
// const address0 =
//     '0x0000000000000000000000001e3f32759670fc150509dbc8956d12e9ca24696b';

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

    test("tx history", () async {
      final events =
          await getWTonTransferEvents(client, privateKey, contractAddr);
      expect(events.length, 1);
      expect(
          events[0].from,
          EthereumAddress.fromHex(
              "0x0000000000000000000000000000000000000000"));
      expect(events[0].to, EthPrivateKey.fromHex(privateKey).address);
      expect(events[0].value, TonAmount.inTon(123));
    });
  });
}
