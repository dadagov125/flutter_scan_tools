import 'package:flutter_scan_tools/src/entities/card_number.dart';
import 'package:flutter_scan_tools/src/entities/card_scan_result.dart';
import 'package:flutter_scan_tools/src/scanners/strategy/card_scanner_strategy/card_scanner_strategy.dart';
import 'package:flutter_scan_tools/src/scanners/strategy/scanner_strategy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:mockito/mockito.dart';

import '../mocks/text_recognizer.mocks.dart';
import '../utils/random_utils.dart';
import '../utils/recognizer_utils.dart';

void main() {
  late MockTextRecognizer recognizer;
  late ScannerStrategy<CardScanResul> strategy;
  group('scan card number', () {
    setUpAll(() {
      recognizer = MockTextRecognizer();
      strategy = CardScannerStrategy(recognizer: recognizer);
    });
    tearDownAll(() {});

    test('should return ${CardType.Humo.name}', () async {
      final cardNumber = '9860 1234 5678 9123';

      final block = createBlock(['some text ${cardNumber} some text']);

      final text = RecognizedText(blocks: [block], text: '');
      when(recognizer.processImage(any)).thenAnswer((_) => Future.value(text));
      final resul = await strategy.scan(InputImage.fromFilePath(''));
      expect(resul.cardNumber.type, CardType.Humo);
      expect(resul.cardNumber.number, cardNumber.replaceAll(' ', ''));
    });

    test('should return ${CardType.UzCard.name}', () async {
      final cardNumber = '8600 1234 5678 9123';

      final block = createBlock(['some text ${cardNumber} some text']);

      final text = RecognizedText(blocks: [block], text: '');
      when(recognizer.processImage(any)).thenAnswer((_) => Future.value(text));
      final resul = await strategy.scan(InputImage.fromFilePath(''));
      expect(resul.cardNumber.type, CardType.UzCard);
      expect(resul.cardNumber.number, cardNumber.replaceAll(' ', ''));
    });

    test('should return ${CardType.Visa.name}', () async {
      final cardNumber = '4001 9192 5753 7193';

      final block = createBlock(['some text ${cardNumber} some text']);

      final text = RecognizedText(blocks: [block], text: '');
      when(recognizer.processImage(any)).thenAnswer((_) => Future.value(text));
      final resul = await strategy.scan(InputImage.fromFilePath(''));
      expect(resul.cardNumber.type, CardType.Visa);
      expect(resul.cardNumber.number, cardNumber.replaceAll(' ', ''));
    });

    test('should return ${CardType.MasterCard.name} 51-55', () async {
      final cardNumber = '${randomRange(51, 55)}25 2334 3010 9903';

      final block = createBlock(['some text ${cardNumber} some text']);

      final text = RecognizedText(blocks: [block], text: '');
      when(recognizer.processImage(any)).thenAnswer((_) => Future.value(text));
      final resul = await strategy.scan(InputImage.fromFilePath(''));
      expect(resul.cardNumber.type, CardType.MasterCard);
      expect(resul.cardNumber.number, cardNumber.replaceAll(' ', ''));
    });

    test('should return ${CardType.MasterCard.name} 2221-2720', () async {
      final cardNumber = '${randomRange(2221, 2720)} 4200 0000 1113';

      final block = createBlock(['some text ${cardNumber} some text']);

      final text = RecognizedText(blocks: [block], text: '');
      when(recognizer.processImage(any)).thenAnswer((_) => Future.value(text));
      final resul = await strategy.scan(InputImage.fromFilePath(''));
      expect(resul.cardNumber.type, CardType.MasterCard);
      expect(resul.cardNumber.number, cardNumber.replaceAll(' ', ''));
    });

    test('should return ${CardType.AmericanExpress.name} 34, 37', () async {
      await Future.forEach([34, 37], (value) async {
        final cardNumber = '${value}42 4545 5400 126';

        final block = createBlock(['some  text ${cardNumber} some text']);

        final text = RecognizedText(blocks: [block], text: '');
        when(recognizer.processImage(any))
            .thenAnswer((_) => Future.value(text));
        final resul = await strategy.scan(InputImage.fromFilePath(''));
        expect(resul.cardNumber.type, CardType.AmericanExpress);
        expect(resul.cardNumber.number, cardNumber.replaceAll(' ', ''));
      });
    });

    test(
        'should return ${CardType.Maestro.name} 5018, 5020, 5038, 5893, 6304, 6759, 6761, 6762, 6763',
        () async {
      await Future.forEach(
          [5018, 5020, 5038, 5893, 6304, 6759, 6761, 6762, 6763],
          (value) async {
        final cardNumber = '${value}42 4545 5400 126';

        final block = createBlock(['some  text ${cardNumber} some text']);

        final text = RecognizedText(blocks: [block], text: '');
        when(recognizer.processImage(any))
            .thenAnswer((_) => Future.value(text));
        final resul = await strategy.scan(InputImage.fromFilePath(''));
        expect(resul.cardNumber.type, CardType.Maestro);
        expect(resul.cardNumber.number, cardNumber.replaceAll(' ', ''));
      });
    });

    test('should return ${CardType.Mir.name} 2200-2204', () async {
      final cardNumber = '${randomRange(2200, 2204)} 4200 0000 1113';

      final block = createBlock(['some text ${cardNumber} some text']);

      final text = RecognizedText(blocks: [block], text: '');
      when(recognizer.processImage(any)).thenAnswer((_) => Future.value(text));
      final resul = await strategy.scan(InputImage.fromFilePath(''));
      expect(resul.cardNumber.type, CardType.Mir);
      expect(resul.cardNumber.number, cardNumber.replaceAll(' ', ''));
    });

    test('should return ${CardType.UnionPay.name}', () async {
      final cardNumber = '6201 9192 5753 7193';

      final block = createBlock(['some text ${cardNumber} some text']);

      final text = RecognizedText(blocks: [block], text: '');
      when(recognizer.processImage(any)).thenAnswer((_) => Future.value(text));
      final resul = await strategy.scan(InputImage.fromFilePath(''));
      expect(resul.cardNumber.type, CardType.UnionPay);
      expect(resul.cardNumber.number, cardNumber.replaceAll(' ', ''));
    });

    test('should return ${CardType.DinersClub.name} 300-305', () async {
      final cardNumber = '${randomRange(300, 305)}0 4200 0000 11';

      final block = createBlock(['some text ${cardNumber} some text']);

      final text = RecognizedText(blocks: [block], text: '');
      when(recognizer.processImage(any)).thenAnswer((_) => Future.value(text));
      final resul = await strategy.scan(InputImage.fromFilePath(''));
      expect(resul.cardNumber.type, CardType.DinersClub);
      expect(resul.cardNumber.number, cardNumber.replaceAll(' ', ''));
    });

    test('should return ${CardType.DinersClub.name} 36, 38', () async {
      await Future.forEach([36, 38], (value) async {
        final cardNumber = '${value}42 4545 5400 11';

        final block = createBlock(['some  text ${cardNumber} some text']);

        final text = RecognizedText(blocks: [block], text: '');
        when(recognizer.processImage(any))
            .thenAnswer((_) => Future.value(text));
        final resul = await strategy.scan(InputImage.fromFilePath(''));
        expect(resul.cardNumber.type, CardType.DinersClub);
        expect(resul.cardNumber.number, cardNumber.replaceAll(' ', ''));
      });
    });

    test('should return ${CardType.Jcb.name} 3528-3589', () async {
      final cardNumber = '${randomRange(3528, 3589)}0 4200 0000 1100';

      final block = createBlock(['some text ${cardNumber} some text']);

      final text = RecognizedText(blocks: [block], text: '');
      when(recognizer.processImage(any)).thenAnswer((_) => Future.value(text));
      final resul = await strategy.scan(InputImage.fromFilePath(''));
      expect(resul.cardNumber.type, CardType.Jcb);
      expect(resul.cardNumber.number, cardNumber.replaceAll(' ', ''));
    });

    test('should return ${CardType.Discover.name} 65, 6011', () async {
      await Future.forEach([65, 6011], (value) async {
        final s = '$value'.length == 2 ? '${value}00' : '${value}';
        final cardNumber = '${s} 4545 5400 1111';

        final block = createBlock(['some  text ${cardNumber} some text']);

        final text = RecognizedText(blocks: [block], text: '');
        when(recognizer.processImage(any))
            .thenAnswer((_) => Future.value(text));
        final resul = await strategy.scan(InputImage.fromFilePath(''));
        expect(resul.cardNumber.type, CardType.Discover);
        expect(resul.cardNumber.number, cardNumber.replaceAll(' ', ''));
      });
    });
  });
}
