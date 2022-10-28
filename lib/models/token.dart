import 'ethereum.dart' as eth;
import '/state.dart' as state;

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
  // toncoin(
  //   name: "Toncoin",
  //   symbol: "TON",
  //   blockchain: Blockchain.ton,
  // ),
  ether(
    name: "Ether",
    symbol: "ETH",
    decimals: 18,
    blockchain: Blockchain.ethereum,
  ),
  toncoinERC20(
    name: "Wrapped Toncoin",
    symbol: "WTON",
    decimals: 9,
    blockchain: Blockchain.ethereum,
  ),
  // toncoinBEP20(
  //   name: "Wrapped Toncoin",
  //   symbol: "WTON",
  //   blockchain: Blockchain.bsc,
  // ),
  ;

  final String name;
  final String symbol;
  final int decimals;
  final Blockchain blockchain;

  const Token({
    required this.name,
    required this.symbol,
    required this.decimals,
    required this.blockchain,
  });
}

typedef TokenAmount = String;
typedef FiatAmount = String;

String formatTokenAmount({required TokenAmount amount, required Token token}) =>
    "$amount ${token.symbol}";

String formatFiatAmount({required FiatAmount amount}) => "$amount \$";

Future<TokenAmount> getTokenAmount(Token t) async {
  switch (t) {
    case Token.ether:
      var ether = await eth.getEtherBalance(
        eth.getCachedClient(),
        eth.getDefaultPrivateKey(state.wallet),
      );
      return ether.getInEther.toString();

    case Token.toncoinERC20:
      var wton = await eth.getWTonBalance(
        eth.getCachedClient(),
        eth.getDefaultAddress(state.wallet),
        eth.contractAddr,
      );
      return wton.getInTon.toString();
  }
}

FiatAmount getFiatAmount(Object tokenAmount) {
  return "0";
}
