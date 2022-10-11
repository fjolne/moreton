import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            seedColor: const Color(0xff478ee0),
            primary: const Color(0xff478ee0),
            onPrimary: const Color(0xffeeeeee),
            surface: const Color(0xff1c1c1c),
            background: const Color(0xff050505),
          ),
          fontFamily: 'Inter',
          textTheme: Typography.englishLike2021,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Color(0xff1c1c1c),
              systemNavigationBarColor: Color(0xff1c1c1c),
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Color(0xff478EE0),
          )),
      home: const MyHomePage(title: 'Wallet'),
    );
  }
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
        color: cs.background,
        child: Container(
          color: cs.surface,
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
      ),
      bottomNavigationBar: BottomNavigationBar(
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
    var cs = Theme.of(context).colorScheme;
    var tt = Theme.of(context).textTheme;
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("1 816,51 \$", style: tt.headlineMedium),
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
    return Container(
      child: Column(
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
          Text(text, style: tt.bodySmall)
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
    var cs = Theme.of(context).colorScheme;
    var tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
          color: cs.background,
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
        ]),
      ),
    );
  }
}

class Token extends StatelessWidget {
  final TokenData data;
  const Token({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var cs = Theme.of(context).colorScheme;
    var tt = Theme.of(context).textTheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: Image(
            image: AssetImage(data.blockchain.imageUrl), width: 48, height: 48),
      ),
      title: Text(data.name, style: tt.titleMedium),
      trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(data.formattedValue, style: tt.titleMedium),
            const SizedBox(height: 2),
            Text(data.formattedUsdValue,
                textAlign: TextAlign.end,
                style: tt.bodyMedium?.copyWith(color: cs.secondary)),
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
