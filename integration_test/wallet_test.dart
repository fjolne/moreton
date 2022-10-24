import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:integration_test/integration_test.dart';
import 'package:moreton/models/ethereum.dart';
import 'package:test/test.dart';
import 'package:web3dart/web3dart.dart';

const mnemonic =
    "want region shallow update slight arrive notable news alert canyon candy art";
const privateKey =
    '25b6431c25daea0c3daf39794b298cc14785717edc2de398f80ea5188a0eb5aa';
const defaultAddress = "0x1E3F32759670fC150509dbc8956D12e9cA24696b";

void main() {
  late final HDWallet wallet;

  setUpAll(() {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    FlutterTrustWalletCore.init();
    wallet = HDWallet.createWithMnemonic(mnemonic);
  });

  group("wallet", () {
    test("wallet creation", () {
      expect(wallet.mnemonic(), mnemonic);
    });
    test("private key derivation", () {
      expect(getDefaultPrivateKey(wallet), privateKey);
    });

    test("address derivation", () {
      final credentials = EthPrivateKey.fromHex(privateKey);
      expect(credentials.address, EthereumAddress.fromHex(defaultAddress));
    });
  });

  group("client", () {
    final client = makeClient(rpcUrl);
    test("client connection", () async {
      expect(await client.getChainId(), BigInt.from(1337));
    });
    test("address balance", () async {
      final balance = await getEtherBalance(
        client,
        getDefaultPrivateKey(wallet),
      );
      expect(
        balance.getInEther.toInt(),
        inInclusiveRange(95, 100),
      );
    });
  });
}
