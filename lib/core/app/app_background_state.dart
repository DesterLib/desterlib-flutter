import 'package:flutter/widgets.dart';

class AppBackgroundState extends ChangeNotifier {
  static const defaultColors = [Color(0xFF123C35), Color(0xFF2A6B5E)];

  List<Color> colors = defaultColors;

  void setColors(List<Color> colors) {
    this.colors = colors;
    notifyListeners();
  }

  void reset() {
    setColors(defaultColors);
  }
}
