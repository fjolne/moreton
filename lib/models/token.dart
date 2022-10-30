import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:intl/intl.dart';
import 'package:web3dart/web3dart.dart';

import '/state.dart' as state;
import 'ethereum.dart' as eth;

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
    getAddress: eth.getDefaultAddress,
  ),
  toncoinERC20(
    name: "Wrapped Toncoin",
    symbol: "WTON",
    decimals: 9,
    blockchain: Blockchain.ethereum,
    getAddress: eth.getDefaultAddress,
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
  final EthereumAddress Function(HDWallet wallet) getAddress;

  const Token({
    required this.name,
    required this.symbol,
    required this.decimals,
    required this.blockchain,
    required this.getAddress,
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

String compressAddress(String hex) =>
    "${hex.substring(0, 7)}...${hex.substring(hex.length - 7, hex.length)}";

final txDayFormatter = DateFormat("MMM dd yyyy");
