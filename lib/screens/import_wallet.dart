import 'package:flutter/material.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';

import '/state.dart' as state;
import 'home.dart';

class ImportWalletScreen extends StatefulWidget {
  const ImportWalletScreen({super.key});

  @override
  _ImportWalletScreenState createState() => _ImportWalletScreenState();
}

class _ImportWalletScreenState extends State<ImportWalletScreen> {
  String mnemonic = "";

  @override
  Widget build(BuildContext context) {
    var cs = Theme.of(context).colorScheme;
    var tt = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 256,
                child: TextField(
                  onChanged: (text) {
                    mnemonic = text;
                  },
                  decoration: const InputDecoration(
                      hintText: "net sphere bone ...",
                      border: OutlineInputBorder()),
                  style: tt.bodyLarge,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: importWallet,
                child: Text("Import"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void importWallet() {
    state.wallet = HDWallet.createWithMnemonic(mnemonic);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
  }
}
