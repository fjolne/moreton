import 'package:flutter/material.dart';
import 'package:moreton/models/ethereum.dart';
import 'package:web3dart/web3dart.dart';

import '/state.dart' as state;
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
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Balance(token: token),
            const SizedBox(height: 24),
            Actions(token: token),
            const SizedBox(height: 24),
            Expanded(
                child:
                    TransactionList(address: token.getAddress(state.wallet))),
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
    fiatAmount = getFiatAmount(tokenAmount);
    getAmounts();
  }

  void getAmounts() async {
    var tokenAmount = await getTokenAmount(widget.token);
    setState(() {
      this.tokenAmount = tokenAmount;
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
      const SizedBox(height: 8),
      Text(
        formatTokenAmount(amount: tokenAmount, token: widget.token),
        style: tt.headlineMedium,
      ),
      const SizedBox(height: 4),
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

class TransactionList extends StatefulWidget {
  final EthereumAddress address;

  const TransactionList({super.key, required this.address});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  late WTonTransactionList transactionList;

  @override
  void initState() {
    super.initState();
    transactionList = WTonTransactionList(widget.address);
    initStateAsync();
  }

  Future initStateAsync() async {
    await transactionList.fetch();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var cs = Theme.of(context).colorScheme;
    var tt = Theme.of(context).textTheme;
    return ListView.builder(
      itemCount: transactionList.length,
      itemBuilder: (context, index) {
        var tx = transactionList.txes[index];
        var srcDest = widget.address == tx.from
            ? ['To', tx.to.hexEip55]
            : ['From', tx.from.hexEip55];
        return ListTile(
          leading: const Icon(Icons.arrow_downward),
          title: const Text("Transfer"),
          subtitle: Text("${srcDest[0]}: ${srcDest[1]}",
              style: tt.bodySmall?.copyWith(color: cs.onSurface)),
          trailing: Text(tx.value.toString(), style: tt.titleMedium),
        );
      },
    );
  }
}
