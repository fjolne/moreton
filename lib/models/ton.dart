// see web3dart-2.4.1/lib/src/core/amount.dart

enum TonUnit {
  // 1e-9, the smallest unit
  nano,

  // 1e-6 = 1e3 nanos
  micro,

  // 1e-3 = 1e6 nanos
  milli,

  // 1 = 1e9 nanos
  ton,
}

class TonAmount {
  const TonAmount.inNano(this._value);

  TonAmount.zero() : this.inNano(BigInt.zero);
  TonAmount.inTon(dynamic amount)
      : _value = TonAmount.fromUnitAndValue(TonUnit.ton, amount)._value;

  /// Constructs an amount of Ether by a unit and its amount. [amount] can
  /// either be a base10 string, an int, or a BigInt.
  factory TonAmount.fromUnitAndValue(TonUnit unit, dynamic amount) {
    BigInt parsedAmount;

    if (amount is BigInt) {
      parsedAmount = amount;
    } else if (amount is int) {
      parsedAmount = BigInt.from(amount);
    } else if (amount is String) {
      parsedAmount = BigInt.parse(amount);
    } else {
      throw ArgumentError('Invalid type, must be BigInt, string or int');
    }

    return TonAmount.inNano(parsedAmount * _factors[unit]!);
  }

  /// Gets the value of this amount in the specified unit as a whole number.
  /// **WARNING**: For all units except for [TonUnit.wei], this method will
  /// discard the remainder occurring in the division, making it unsuitable for
  /// calculations or storage. You should store and process amounts of ether by
  /// using a BigInt storing the amount in wei.
  BigInt getValueInUnitBI(TonUnit unit) => _value ~/ _factors[unit]!;

  static final Map<TonUnit, BigInt> _factors = {
    TonUnit.nano: BigInt.one,
    TonUnit.micro: BigInt.from(10).pow(3),
    TonUnit.milli: BigInt.from(10).pow(6),
    TonUnit.ton: BigInt.from(10).pow(9),
  };

  final BigInt _value;

  BigInt get getInNano => _value;
  BigInt get getInTon => getValueInUnitBI(TonUnit.ton);

  /// Gets the value of this amount in the specified unit. **WARNING**: Due to
  /// rounding errors, the return value of this function is not reliable,
  /// especially for larger amounts or smaller units. While it can be used to
  /// display the amount of ether in a human-readable format, it should not be
  /// used for anything else.
  double getValueInUnit(TonUnit unit) {
    final factor = _factors[unit]!;
    final value = _value ~/ factor;
    final remainder = _value.remainder(factor);

    return value.toInt() + (remainder.toInt() / factor.toInt());
  }

  @override
  String toString() {
    return 'TonAmount: $getInNano nanos';
  }

  @override
  int get hashCode => getInNano.hashCode;

  @override
  bool operator ==(dynamic other) =>
      other is TonAmount && other.getInNano == getInNano;
}
