import 'package:desterlib_client/core/app/app.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_window_utils/macos_window_utils.dart';
import 'package:nativeapi/nativeapi.dart' as native;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WindowManipulator.initialize();

  await WindowManipulator.makeTitlebarTransparent();
  await WindowManipulator.enableFullSizeContentView();
  await WindowManipulator.hideTitle();

  final window = native.WindowManager.instance.getCurrent();

  window?.minimumSize = const native.Size(width: 900, height: 600);

  runApp(const DesterApp());
}
