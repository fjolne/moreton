import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';

import '/state.dart' as state;
import 'home.dart';
import 'import_wallet.dart';

class CreateWallet extends StatefulWidget {
  const CreateWallet({super.key});

  @override
  State<CreateWallet> createState() => _CreateWalletState();
}

class _CreateWalletState extends State<CreateWallet> {
  @override
  Widget build(BuildContext context) {
    var cs = Theme.of(context).colorScheme;
    var tt = Theme.of(context).textTheme;
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: <Widget>[
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text("GM", style: tt.headlineLarge),
                    Text("I see you are new here", style: tt.headlineSmall)
                  ])),
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    TextButton(
                        onPressed: importWallet,
                        child: Text(
                          "Import existing wallet",
                          style: tt.titleMedium?.copyWith(color: cs.onSurface),
                        )),
                    ElevatedButton(
                        onPressed: createWallet,
                        child: Text(
                          "Create Wallet",
                          style: tt.titleMedium,
                        )),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void createWallet() {
    state.wallet = HDWallet();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            MnemonicScreen(mnemonic: state.wallet.mnemonic())));
  }

  void importWallet() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ImportWalletScreen()));
  }
}

class MnemonicScreen extends StatelessWidget {
  final String mnemonic;

  const MnemonicScreen({super.key, required this.mnemonic});

  @override
  Widget build(BuildContext context) {
    var cs = Theme.of(context).colorScheme;
    var tt = Theme.of(context).textTheme;
    var words = mnemonic.split(" ");
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      // ),
      body: Column(children: [
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: words
                  .asMap()
                  .entries
                  .map((e) => Row(children: [
                        Text("${e.key + 1}. ",
                            style: tt.bodyLarge?.copyWith(color: cs.onSurface)),
                        Text(e.value, style: tt.bodyLarge),
                      ]))
                  .toList(),
            )
          ],
        )),
        Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                TextButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: mnemonic));
                  },
                  child: Text("Copy to clipboard", style: tt.titleMedium),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomeScreen())),
                  child: Text("Continue", style: tt.titleMedium),
                ),
              ],
            ))
      ]),
    );
  }
}
// small sugar magic joke apart off question grit abuse vapor teach erode
