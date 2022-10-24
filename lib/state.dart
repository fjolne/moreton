import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences store;
late HDWallet wallet;

String? getStoredMnemonic() {
  return store.getString("mnemonic") ??
      "want region shallow update slight arrive notable news alert canyon candy art";
}

// returns true if new user
Future<bool> init() async {
  FlutterTrustWalletCore.init();
  store = await SharedPreferences.getInstance();
  var storedMnemonic = getStoredMnemonic();
  if (storedMnemonic != null) {
    wallet = HDWallet.createWithMnemonic(storedMnemonic);
    return false;
  }
  return true;
}
