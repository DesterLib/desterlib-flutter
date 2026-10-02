import 'dart:ui';

import 'package:desterlib_client/core/app/app.dart';
import 'package:desterlib_client/core/icons/filter_icon.dart';
import 'package:desterlib_client/core/widgets/action_button.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_window_utils/widgets/macos_toolbar_passthrough.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchBar>
    implements TextSelectionGestureDetectorBuilderDelegate {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;
  late final _SearchSelectionGestureDetectorBuilder
  _selectionGestureDetectorBuilder;

  @override
  final GlobalKey<EditableTextState> editableTextKey =
      GlobalKey<EditableTextState>();

  @override
  bool get forcePressEnabled => false;

  @override
  bool get selectionEnabled => true;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode()
      ..addListener(() {
        setState(() {});
      });

    _controller = TextEditingController();

    _selectionGestureDetectorBuilder = _SearchSelectionGestureDetectorBuilder(
      delegate: this,
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeScope.of(context);

    final isFocused = _focusNode.hasFocus;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        MacosToolbarPassthrough(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 280,
                height: 32,
                decoration: BoxDecoration(
                  color: theme.surfaceLight,
                  border: isFocused
                      ? Border.all(color: theme.surfaceMedium, width: 2)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  child: Center(
                    child: _selectionGestureDetectorBuilder
                        .buildGestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: EditableText(
                            key: editableTextKey,
                            controller: _controller,
                            focusNode: _focusNode,
                            rendererIgnoresPointer: true,

                            style: const TextStyle(
                              color: Color(0xE6FFFFFF),
                              fontSize: 14,
                              height: 1.0,
                            ),

                            cursorColor: const Color(0xFFFFFFFF),
                            backgroundCursorColor: const Color(0xFFFFFFFF),
                            selectionColor: const Color(0x33FFFFFF),

                            maxLines: 1,
                            cursorWidth: 1,
                            cursorHeight: 15,

                            textAlign: TextAlign.left,

                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.search,

                            strutStyle: const StrutStyle(
                              fontSize: 14,
                              height: 1.0,
                              forceStrutHeight: true,
                            ),

                            onChanged: (_) {
                              setState(() {});
                            },
                          ),
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),

        ActionButton(
          onPressed: () {
            print('Refresh pressed');
          },
          icon: (context, color, size, iconKey) {
            return FilterIcon(color: color, size: size, key: iconKey);
          },
        ),
      ],
    );
  }
}

/// Subclass of [TextSelectionGestureDetectorBuilder] that simply forwards
/// everything to the superclass. The base class already wires up all the
/// native selection gestures (tap-to-caret, drag-to-select, double-tap-word,
/// triple-tap-line, etc.) using the [TextSelectionGestureDetectorBuilderDelegate].
class _SearchSelectionGestureDetectorBuilder
    extends TextSelectionGestureDetectorBuilder {
  _SearchSelectionGestureDetectorBuilder({required super.delegate});
}
