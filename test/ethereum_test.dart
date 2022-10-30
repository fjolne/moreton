import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:moreton/models/ethereum.dart';
import 'package:moreton/models/ton.dart';
import 'package:test/test.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/src/crypto/formatting.dart' as formatting;

final EthereumAddress addrZero =
    EthereumAddress.fromHex("0x0000000000000000000000000000000000000000");
final EthereumAddress addr =
    EthereumAddress.fromHex("0x1E3F32759670fC150509dbc8956D12e9cA24696b");
final EthereumAddress receiver =
    EthereumAddress.fromHex("0xC6c237319F79194DCC0E2aeBd6206d83d4C7BA0B");
final Credentials creds = EthPrivateKey.fromHex(
    "0x25b6431c25daea0c3daf39794b298cc14785717edc2de398f80ea5188a0eb5aa");

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final client = makeClient(rpcUrl);
  test("client connection", () async {
    expect(await client.getChainId(), BigInt.from(1337));
  });

  group("wton", () {
    test("balance", () async {
      var amount = await getWTonBalance(client, addr, contractAddr);
      expect(amount.getInTon.toInt(), inInclusiveRange(90, 123));
    });

    test("tx history", () async {
      final events = await getWTonTransferEvents(client, addr, contractAddr);
      expect(events.length, greaterThan(1));
    });

    test("transfer", () async {
      final balanceBefore = await getWTonBalance(client, addr, contractAddr);
      final balanceReceiverBefore =
          await getWTonBalance(client, receiver, contractAddr);
      final BigInt value = BigInt.from(5);
      await transferWTon(
          client: client,
          credentials: creds,
          contractAddr: contractAddr,
          receiver: receiver,
          value: TonAmount.inTon(value));
      final balanceAfter = await getWTonBalance(client, addr, contractAddr);
      final balanceReceiverAfter =
          await getWTonBalance(client, receiver, contractAddr);
      expect(balanceAfter.getInTon, balanceBefore.getInTon - value);
      expect(balanceReceiverAfter.getInTon,
          balanceReceiverBefore.getInTon + value);
    });
  });
}
