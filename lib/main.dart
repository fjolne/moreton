import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tonswap',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: const Color(0xff2196F3),
              primary: const Color(0xff478ee0)),
          fontFamily: 'Inter',
          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyText1: TextStyle(fontSize: 12.0),
            bodyText2: TextStyle(fontSize: 10.0),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Color(0xff478EE0),
          )),
      home: const MyHomePage(title: 'Okay'),
    );
  }
}

enum TrustColors {
  white(value: Color(0xffffffff)),
  darkWhite(value: Color(0xffcccccc)),
  blue(value: Color(0xff478EE0)),
  grey(value: Color(0xff7F8082)),
  black(value: Color(0xff1C1C1C)),
  darkBlack(value: Color(0xff050305));

  final Color value;

  const TrustColors({required this.value});
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined),
          color: Theme.of(context).colorScheme.primary,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              color: TrustColors.blue.value,
              icon: const Icon(Icons.tune))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        color: TrustColors.black.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Balance(),
            SizedBox(height: 24),
            Actions(),
            SizedBox(height: 24),
            TokenList(tokens: tokens),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 8,
        unselectedFontSize: 8,
        iconSize: 16,
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
      ),
    );
  }
}

class ScreenButton extends StatelessWidget {
  final IconData icon;
  final String name;

  const ScreenButton({super.key, required this.icon, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(icon),
        onPressed: () {},
      ),
    );
  }
}

class Balance extends StatelessWidget {
  const Balance({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("1 816,51 \$",
          style: TextStyle(color: TrustColors.white.value, fontSize: 24)),
      const SizedBox(
        height: 4,
      ),
      Text("Main Wallet",
          style: TextStyle(
              color: TrustColors.darkWhite.value,
              fontSize: 10,
              fontWeight: FontWeight.w300)),
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
    return Container(
      child: Column(
        children: [
          CircleAvatar(
              radius: 16,
              backgroundColor: TrustColors.blue.value,
              child: IconButton(
                iconSize: 16,
                icon: icon,
                color: TrustColors.white.value,
                onPressed: onPressed,
              )),
          const SizedBox(
            height: 4,
          ),
          Text(text,
              style: TextStyle(color: TrustColors.white.value, fontSize: 10))
        ],
      ),
    );
  }
}

enum Blockchain {
  ton(imageUrl: "images/ton-logo.png"),
  ethereum(imageUrl: "images/eth-logo.jpg"),
  binance(imageUrl: "images/bnb-logo.png");

  final String imageUrl;

  const Blockchain({required this.imageUrl});
}

class TokenData {
  final String name;
  final double value;
  final Blockchain blockchain;
  double get usdValue => value * 1000;
  double get price => 1329.88;

  const TokenData(
      {required this.name, required this.value, required this.blockchain});

  String get formattedValue => "$value TON";
  String get formattedUsdValue => "$usdValue \$";
  String get formattedPrice => "$price \$";
}

class TokenList extends StatefulWidget {
  final List<TokenData> tokens;
  const TokenList({super.key, required this.tokens});

  @override
  _TokenListState createState() => _TokenListState();
}

class _TokenListState extends State<TokenList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.shadow,
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      // padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: ListTile.divideTiles(context: context, tiles: [
          ...widget.tokens.map((data) => Token(data: data)),
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
    );
  }
}

class Token extends StatelessWidget {
  final TokenData data;
  const Token({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      textColor: TrustColors.white.value,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: Image(
            image: AssetImage(data.blockchain.imageUrl), width: 36, height: 36),
      ),
      title: Text(data.name, style: const TextStyle(fontSize: 12)),
      trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(data.formattedValue, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 2),
            Text(data.formattedUsdValue,
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: TrustColors.darkWhite.value, fontSize: 10)),
          ]),
    );
  }
}

const tokens = [
  TokenData(
    blockchain: Blockchain.ton,
    name: "TON",
    value: 7.456,
  ),
  TokenData(
    blockchain: Blockchain.ethereum,
    name: "Ethereum",
    value: 0.186,
  ),
  TokenData(
    blockchain: Blockchain.binance,
    name: "Binance",
    value: 85.123,
  ),
];
