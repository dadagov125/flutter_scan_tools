import 'card_number.dart';
import 'scan_result.dart';

class CardScanResul extends ScanResult {
  CardScanResul({
    required this.cardNumber,
    required this.expiry,
    required this.holder,
  });

  final CardNumber cardNumber;
  final String? expiry;
  final String? holder;

  CardScanResul copyWith({
    CardNumber? cardNumber,
    String? expiry,
    String? holder,
  }) {
    return CardScanResul(
      cardNumber: cardNumber ?? this.cardNumber,
      expiry: expiry ?? this.expiry,
      holder: holder ?? this.holder,
    );
  }

  @override
  String toString() {
    return 'CardScanResul(cardNumber:$cardNumber, expiry:$expiry, holder:$holder)';
  }
}
