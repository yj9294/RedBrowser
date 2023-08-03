import 'dart:ui';

class ColorUtil extends Color {
  static int _getColorFromHex(String hex, {double? alpha}) {
    hex = hex.toUpperCase().replaceAll('#', '');
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return int.parse(hex, radix: 16);
  }
  ColorUtil(final String hex, {double? alpha}): super(_getColorFromHex(hex,
      alpha: alpha));
}