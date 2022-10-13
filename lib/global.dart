import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.shield),
          label: "Wallet",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: "Discover",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view),
          label: "Browser",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
    );
  }
}

typedef ActionButtonCallback = void Function();

class ActionButton extends StatelessWidget {
  final Icon icon;
  final String text;
  final ActionButtonCallback onPressed;

  const ActionButton(
      {required this.icon,
      required this.text,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    var cs = Theme.of(context).colorScheme;
    var tt = Theme.of(context).textTheme;
    return Column(
      children: [
        CircleAvatar(
            radius: 24,
            backgroundColor: cs.primary,
            child: IconButton(
              iconSize: 24,
              icon: icon,
              color: cs.onPrimary,
              onPressed: onPressed,
            )),
        const SizedBox(
          height: 4,
        ),
        Text(text, style: tt.bodySmall?.copyWith(color: cs.secondary))
      ],
    );
  }
}

void pushModal(BuildContext context, Widget Function(BuildContext) builder) {
  var cs = Theme.of(context).colorScheme;
  var tt = Theme.of(context).textTheme;
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: cs.surfaceVariant,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
    context: context,
    builder: builder,
  );
}

enum Blockchain {
  ton(
    name: "TON",
    type: "TON",
    imageUrl: "images/ton-logo.png",
  ),
  ethereum(
    name: "Ethereum",
    type: "ERC20",
    imageUrl: "images/eth-logo.jpg",
  ),
  bsc(
    name: "Binance Smart Chain",
    type: "BEP20",
    imageUrl: "images/bnb-logo.png",
  );

  final String name;
  final String type;
  final String imageUrl;

  const Blockchain(
      {required this.name, required this.type, required this.imageUrl});
}

enum Token {
  toncoin(
    name: "Toncoin",
    symbol: "TON",
    blockchain: Blockchain.ton,
  ),
  toncoinERC20(
    name: "Wrapped Toncoin",
    symbol: "WTON",
    blockchain: Blockchain.ethereum,
  ),
  toncoinBEP20(
    name: "Wrapped Toncoin",
    symbol: "WTON",
    blockchain: Blockchain.bsc,
  );

  final String name;
  final String symbol;
  final Blockchain blockchain;

  const Token(
      {required this.name, required this.symbol, required this.blockchain});
}

typedef TokenAmount = double;
typedef FiatAmount = double;

String formatTokenAmount({required TokenAmount amount, required Token token}) =>
    "$amount ${token.symbol}";

String formatFiatAmount({required FiatAmount amount}) => "$amount \$";

TokenAmount getTokenAmount(Token t) {
  switch (t) {
    case Token.toncoin:
      return 7.456;
    case Token.toncoinERC20:
      return 0.186;
    case Token.toncoinBEP20:
      return 58.894;
  }
}

FiatAmount getFiatAmount(TokenAmount tokenAmount) {
  return tokenAmount * 18.78;
}
