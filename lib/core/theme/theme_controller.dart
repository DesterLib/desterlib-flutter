import 'package:desterlib_client/core/theme/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/scheduler.dart';

class AppThemeController extends ChangeNotifier implements TickerProvider {
  AppTheme _theme = AppTheme.light();
  AppTheme _from = AppTheme.light();
  AppTheme _to = AppTheme.light();

  final Duration duration;
  late final Ticker _ticker;

  AppThemeController({this.duration = const Duration(milliseconds: 300)}) {
    _ticker = createTicker(_tick);
  }

  AppTheme get theme => _theme;
  bool get isDark => _theme.isDark;

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);

  void _tick(Duration elapsed) {
    final t = (elapsed.inMicroseconds / duration.inMicroseconds).clamp(
      0.0,
      1.0,
    );
    final curved = Curves.easeInOut.transform(t);

    if (t >= 1.0) {
      _ticker.stop();
      _theme = _to;
    } else {
      _theme = _from.lerp(_to, curved);
    }
    notifyListeners();
  }

  void _animateTo(AppTheme target) {
    _ticker.stop();
    _from = _theme;
    _to = target;
    _ticker.start();
  }

  void setLight() {
    if (!isDark) return;
    _animateTo(AppTheme.light());
  }

  void setDark() {
    if (isDark) return;
    _animateTo(AppTheme.dark());
  }

  void toggle() {
    debugPrint('toggle called, isDark=$isDark');
    isDark ? setLight() : setDark();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
