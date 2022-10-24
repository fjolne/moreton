import 'package:flutter/material.dart';

import '/models/token.dart';
import 'ui.dart';
import 'swap.dart';

class TokenScreen extends StatelessWidget {
  final Token token;

  const TokenScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    var cs = Theme.of(context).colorScheme;
    var tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title:
            Center(child: Text(token.blockchain.name, style: tt.titleMedium)),
        actions: const [
          SizedBox(width: 56),
        ],
      ),
      body: Container(
        color: cs.background,
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Balance(token: token),
            SizedBox(height: 24),
            Actions(token: token),
            SizedBox(height: 24),
            TransactionList(),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}

class Balance extends StatefulWidget {
  final Token token;

  const Balance({super.key, required this.token});

  @override
  State<Balance> createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
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
    return Column(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: Image(
            image: AssetImage(widget.token.blockchain.imageUrl),
            width: 64,
            height: 64),
      ),
      SizedBox(height: 8),
      Text(
        formatTokenAmount(amount: tokenAmount, token: widget.token),
        style: tt.headlineMedium,
      ),
      SizedBox(height: 4),
      Text("≈ $fiatAmount", style: tt.bodyLarge?.copyWith(color: cs.secondary)),
    ]);
  }
}

class Actions extends StatelessWidget {
  final Token token;
  const Actions({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    var cs = Theme.of(context).colorScheme;
    var tt = Theme.of(context).textTheme;
    return Wrap(
      spacing: 48,
      children: [
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
          icon: const Icon(Icons.swap_horiz),
          text: "Swap",
          onPressed: () =>
              pushModal(context, (context) => SwapScreen(sourceToken: token)),
        ),
      ],
    );
  }
}

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}