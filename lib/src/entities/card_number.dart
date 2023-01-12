class CardNumber {
  CardNumber({
    required this.type,
    required this.number,
  });

  @Deprecated('Will be removed in version 1.0.0')
  CardNumber.unknow() : this(type: CardType.Unknown, number: '');

  final CardType type;
  final String number;

  @override
  String toString() {
    return 'CardNumber(type: ${type.name}, number:$number)';
  }
}

enum CardType {
  @Deprecated('Will be removed in version 1.0.0')
  Unknown,
  Humo,
  UzCard,
  Visa,
  MasterCard,
  AmericanExpress,
  Maestro,
  Mir,
  UnionPay,
  DinersClub,
  Jcb,
  Discover
}
