part of 'card_scanner_strategy.dart';

final _holderRegex = RegExp(r'^(?:[A-Z]+ ?){2,3}$');
final _expiryRegex = RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$');
final _cardDigitsRegExp = RegExp('^\\d{$minLength,$maxLength}\$');
final _nonDigitsRegExp = RegExp(r'\D');

//https://en.wikipedia.org/wiki/Payment_card_number
const List<CardTemplate> _cardTemplates = const [
  CardTemplate(
    type: CardType.Humo,
    code: OneValue(9860),
    length: OneValue(16),
  ),
  CardTemplate(
    type: CardType.UzCard,
    code: OneValue(8600),
    length: OneValue(16),
  ),
  CardTemplate(
    type: CardType.Visa,
    code: OneValue(4),
    length: OneValue(16),
  ),
  CardTemplate(
    type: CardType.MasterCard,
    code: RangedValue(51, 55),
    length: OneValue(16),
  ),
  CardTemplate(
      type: CardType.MasterCard,
      code: RangedValue(2221, 2720),
      length: OneValue(16)),
  CardTemplate(
    type: CardType.AmericanExpress,
    code: FewValue([34, 37]),
    length: OneValue(15),
  ),
  CardTemplate(
    type: CardType.Maestro,
    code: FewValue([5018, 5020, 5038, 5893, 6304, 6759, 6761, 6762, 6763]),
    length: RangedValue(12, 19),
  ),
  CardTemplate(
    type: CardType.Mir,
    code: RangedValue(2200, 2204),
    length: OneValue(16),
  ),
  CardTemplate(
    type: CardType.UnionPay,
    code: OneValue(62),
    length: RangedValue(16, 19),
  ),
  CardTemplate(
    type: CardType.DinersClub,
    code: RangedValue(300, 305),
    length: OneValue(14),
  ),
  CardTemplate(
    type: CardType.DinersClub,
    code: FewValue([36, 38]),
    length: OneValue(14),
  ),
  CardTemplate(
      type: CardType.Jcb,
      code: RangedValue(3528, 3589),
      length: RangedValue(16, 19)),
  CardTemplate(
    type: CardType.Discover,
    code: FewValue([65, 6011]),
    length: OneValue(16),
  ),
];
final minLength = _cardTemplates.map((e) => e.length.minNum).reduce(min);
final maxLength = _cardTemplates.map((e) => e.length.maxNum).reduce(max);
