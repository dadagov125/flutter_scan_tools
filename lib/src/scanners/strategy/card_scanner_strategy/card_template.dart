part of 'card_scanner_strategy.dart';

class CardTemplate {
  const CardTemplate(
      {required this.type, required this.code, required this.length});

  final CardType type;
  final Value code;
  final Value length;
}

abstract class Value {
  bool isThereValue(num value);

  num get maxNum;

  num get minNum;
}

class OneValue implements Value {
  const OneValue(this.value);

  final num value;

  @override
  bool isThereValue(num value) {
    return this.value == value;
  }

  @override
  num get maxNum => value;

  @override
  num get minNum => value;
}

class RangedValue implements Value {
  const RangedValue(this.from, this.to);

  final num from;
  final num to;

  bool isThereValue(num value) {
    return value >= from && value <= to;
  }

  @override
  num get maxNum => max(from, to);

  @override
  num get minNum => min(from, to);
}

class FewValue implements Value {
  const FewValue(this.values);

  final List<num> values;

  @override
  bool isThereValue(num value) {
    return values.contains(value);
  }

  @override
  num get maxNum => values.reduce(max);

  @override
  num get minNum => values.reduce(min);
}
