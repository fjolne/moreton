import 'package:flutter/widgets.dart';
import 'package:moreton/models/ethereum.dart';
import 'package:moreton/models/ton.dart';
import 'package:test/test.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/src/crypto/formatting.dart' as formatting;

final EthereumAddress addr =
    EthereumAddress.fromHex("0x1E3F32759670fC150509dbc8956D12e9cA24696b");

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final client = makeClient(rpcUrl);
  test("client connection", () async {
    expect(await client.getChainId(), BigInt.from(1337));
  });

  group("wton", () {
    test("balance", () async {
      expect(
        await getWTonBalance(client, addr, contractAddr),
        TonAmount.inTon(123),
      );
    });

    test("tx history", () async {
      final events = await getWTonTransferEvents(client, addr, contractAddr);
      expect(events.length, 1);
      expect(
          events[0].from,
          EthereumAddress.fromHex(
              "0x0000000000000000000000000000000000000000"));
      expect(events[0].to, addr);
      expect(events[0].value, TonAmount.inTon(123));
    });
  });
}
