import 'package:flutter/material.dart';

import '/models/token.dart';
import 'token.dart';
import 'ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var cs = Theme.of(context).colorScheme;
    var tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined),
          color: cs.primary,
        ),
        actions: [
          IconButton(
              onPressed: () {}, color: cs.primary, icon: const Icon(Icons.tune))
        ],
      ),
      body: Container(
        color: cs.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Balance(),
            SizedBox(height: 24),
            Actions(),
            SizedBox(height: 24),
            TokenList(),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}

class Balance extends StatelessWidget {
  const Balance({super.key});

  @override
  Widget build(BuildContext context) {
    var cs = Theme.of(context).colorScheme;
    var tt = Theme.of(context).textTheme;
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("0 \$", style: tt.headlineMedium),
      const SizedBox(
        height: 4,
      ),
      Text("Main Wallet", style: tt.bodyMedium?.copyWith(color: cs.secondary)),
    ]));
  }
}

class Actions extends StatelessWidget {
  const Actions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          ActionButton(
            icon: const Icon(Icons.arrow_upward),
            text: "Send",
            onPressed: () {},
          ),
          ActionButton(
            icon: const Icon(Icons.arrow_downward),
            text: "Receive",
            onPressed: () {},
          ),
          ActionButton(
            icon: const Icon(Icons.sell),
            text: "Buy",
            onPressed: () {},
          ),
          ActionButton(
            icon: const Icon(Icons.swap_horiz),
            text: "Swap",
            onPressed: () {},
          ),
        ]));
  }
}

class TokenList extends StatefulWidget {
  const TokenList({super.key});

  @override
  _TokenListState createState() => _TokenListState();
}

class _TokenListState extends State<TokenList> {
  List<Token> tokens = Token.values;

  @override
  Widget build(BuildContext context) {
    var cs = Theme.of(context).colorScheme;
    var tt = Theme.of(context).textTheme;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: cs.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Column(
          children: ListTile.divideTiles(context: context, tiles: [
            ...tokens.map((token) => TokenTile(token: token)),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    IconButton(
                      icon: const Icon(Icons.tune),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {},
                    ),
                    Text("Add Tokens",
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Theme.of(context).colorScheme.primary))
                  ]),
                ],
              ),
            ),
          ]).toList(),
        ),
      ),
    );
  }
}

class TokenTile extends StatefulWidget {
  final Token token;
  const TokenTile({super.key, required this.token});

  @override
  State<TokenTile> createState() => _TokenTileState();
}

class _TokenTileState extends State<TokenTile> {
  TokenAmount tokenAmount = "0";
  FiatAmount fiatAmount = "0";

  @override
  void initState() {
    super.initState();
    getAmounts();
  }

  void getAmounts() async {
    var _tokenAmount = await getTokenAmount(widget.token);
    setState(() {
      tokenAmount = _tokenAmount;
      fiatAmount = getFiatAmount(tokenAmount);
    });
  }

  @override
  Widget build(BuildContext context) {
    var cs = Theme.of(context).colorScheme;
    var tt = Theme.of(context).textTheme;
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TokenScreen(token: widget.token)));
      },
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: Image(
            image: AssetImage(widget.token.blockchain.imageUrl),
            width: 48,
            height: 48),
      ),
      title: Text(widget.token.name, style: tt.titleMedium),
      subtitle: Text(widget.token.blockchain.name,
          style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
      trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(formatTokenAmount(amount: tokenAmount, token: widget.token),
                style: tt.titleMedium),
            const SizedBox(height: 2),
            Text(formatFiatAmount(amount: fiatAmount),
                textAlign: TextAlign.end,
                style: tt.bodyMedium?.copyWith(color: cs.secondary)),
          ]),
    );
  }
}
