///
///A class handle convert number to words
///
class NumberToWordsEnglish {
  NumberToWordsEnglish._();

  static const String _unionSeparator = '-';
  static const String _zero = 'zero'; //0
  static const String _hundred = 'hundred'; //100
  static const String _thousand = 'thousand'; //1000

  static const String _million = 'lac'; //1,00,000
  static const String _billion = 'crore'; //1,00,00,000

  ///numNames
  static const List<String> _numNames = [
    '',
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine',
    'ten',
    'eleven',
    'twelve',
    'thirteen',
    'fourteen',
    'fifteen',
    'sixteen',
    'seventeen',
    'eighteen',
    'nineteen'
  ];

  ///tensNames
  static const List<String> _tensNames = [
    '',
    'ten',
    'twenty',
    'thirty',
    'forty',
    'fifty',
    'sixty',
    'seventy',
    'eighty',
    'ninety'
  ];

  /// convertLessThanOneThousand
  static String _convertLessThanOneThousand(int number,
      [bool isLastThreeDigits = false]) {
    String soFar = '';

    if (number % 100 < 20) {
      soFar = _numNames[number % 100];
      number = (number ~/ 100).toInt();
    } else {
      final int numFirst = number;
      soFar = _numNames[number % 10];
      number = (number ~/ 10).toInt();
      final String unionSeparator =
          ((number ~/ 10).toInt() != 0 && numFirst % 10 != 0) ||
                  (numFirst % 10 != 0 && numFirst < 100)
              ? _unionSeparator
              : '';
      soFar = _tensNames[number % 10] + unionSeparator + soFar;
      number = (number ~/ 10).toInt();
    }
    if (number == 0) {
      return soFar;
    }
    return '${_numNames[number]} $_hundred $soFar';
  }

  ///handle converter
  static String convert(int number) {
    // 0 to 999 999 999 999
    if (number == 0) {
      return _zero;
    }
    final String strNumber = number.toString().padLeft(11, '0');
    // XXXnnnnnnnnn
    final int billions = int.parse(strNumber.substring(0, 4));
    // nnnXXXnnnnnn
    final int millions = int.parse(strNumber.substring(4, 6));
    // nnnnnnXXXnnn
    final int hundredThousands = int.parse(strNumber.substring(6, 8));
    // 20,98,76,54,321
    final int thousands = int.parse(strNumber.substring(8, 11));

    final String tradBillions = _getBillions(billions);
    String result = tradBillions;

    final String tradMillions = _getMillions(millions);
    result = result + tradMillions;

    final String tradHundredThousands = _getThousands(hundredThousands);
    result = result + tradHundredThousands;

    String tradThousand;
    tradThousand = _convertLessThanOneThousand(thousands, true);
    result = result + tradThousand;

    // remove extra spaces!
    result =
        result.replaceAll(RegExp('\\s+'), ' ').replaceAll('\\b\\s{2,}\\b', ' ');
    return result.trim();
  }

  ///get Billions
  static String _getBillions(int billions) {
    String tradBillions;
    switch (billions) {
      case 0:
        tradBillions = '';
        break;
      case 1:
        tradBillions = '${_convertLessThanOneThousand(billions)} $_billion ';
        break;
      default:
        tradBillions = '${_convertLessThanOneThousand(billions)} $_billion ';
    }
    return tradBillions;
  }

  ///get Millions
  static String _getMillions(int millions) {
    String tradMillions;
    switch (millions) {
      case 0:
        tradMillions = '';
        break;
      case 1:
        tradMillions = '${_convertLessThanOneThousand(millions)} $_million ';
        break;
      default:
        tradMillions = '${_convertLessThanOneThousand(millions)} $_million ';
    }
    return tradMillions;
  }

  ///get Thousands
  static String _getThousands(int hundredThousands) {
    String tradHundredThousands;
    switch (hundredThousands) {
      case 0:
        tradHundredThousands = '';
        break;
      case 1:
        tradHundredThousands =
            '${_convertLessThanOneThousand(hundredThousands)} $_thousand ';
        break;
      default:
        tradHundredThousands =
            '${_convertLessThanOneThousand(hundredThousands)} $_thousand ';
    }

    return tradHundredThousands;
  }
}
