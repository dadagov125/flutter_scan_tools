class CardNumber {
  CardNumber({
    required this.type,
    required this.number,
  });

  CardNumber.unknow() : this(type: CardType.Unknown, number: '');

  final CardType type;
  final String number;

  @override
  String toString() {
    return 'CardNumber(type: ${type.name}, number:$number)';
  }
}

enum CardType {
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
