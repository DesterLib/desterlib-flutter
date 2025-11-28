// External packages
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';

/// Form field styled to match SettingsItem appearance
class SettingsFormField extends StatefulWidget {
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final Widget? suffixIcon;
  final bool isFirst;
  final String? errorText;
  final bool hidePenIcon;

  const SettingsFormField({
    super.key,
    this.leadingIcon,
    this.leadingIconColor,
    this.labelText,
    this.hintText,
    this.helperText,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.isFirst = false,
    this.errorText,
    this.hidePenIcon = false,
  });

  @override
  State<SettingsFormField> createState() => _SettingsFormFieldState();
}

class _SettingsFormFieldState extends State<SettingsFormField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isControllerOwned = false;
  bool _isFocusNodeOwned = false;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _isControllerOwned = widget.controller == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _isFocusNodeOwned = widget.focusNode == null;
  }

  @override
  void dispose() {
    if (_isControllerOwned) {
      _controller.dispose();
    }
    if (_isFocusNodeOwned) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppConstants.paddingX(AppConstants.spacing16),
      decoration: BoxDecoration(
        border: widget.isFirst
            ? null
            : Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
      ),
      child: Row(
        children: [
          if (widget.leadingIcon != null) ...[
            Icon(
              widget.leadingIcon,
              size: 24,
              color:
                  widget.leadingIconColor ??
                  Theme.of(context).iconTheme.color?.withValues(alpha: 0.6),
            ),
            SizedBox(width: AppConstants.spacing8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 48,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.labelText != null) ...[
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.labelText!,
                              style: AppTypography.titleSmall(),
                            ),
                          ),
                        ),
                      ],
                      Expanded(
                        flex: widget.labelText != null ? 2 : 1,
                        child: SizedBox(
                          height: 48,
                          child: TextFormField(
                            controller: _controller,
                            focusNode: _focusNode,
                            enabled: widget.enabled,
                            obscureText: widget.obscureText,
                            maxLines: widget.maxLines ?? 1,
                            keyboardType: widget.keyboardType,
                            textInputAction: widget.textInputAction,
                            textAlign: widget.labelText != null
                                ? TextAlign.end
                                : TextAlign.start,
                            style: AppTypography.bodyMedium(),
                            decoration: InputDecoration(
                              hintText: widget.hintText,
                              hintStyle: AppTypography.bodyMedium().copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              isDense: false,
                              suffixIcon:
                                  widget.suffixIcon ??
                                  (widget.hidePenIcon
                                      ? null
                                      : Icon(
                                          LucideIcons.pencil300,
                                          size: 20,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color
                                              ?.withValues(alpha: 0.6),
                                        )),
                              errorText: widget.errorText ?? _validationError,
                              errorStyle: AppTypography.bodySmall().copyWith(
                                color: AppConstants.dangerColor,
                              ),
                              errorMaxLines: 2,
                            ),
                            validator: (value) {
                              final error = widget.validator?.call(value);
                              setState(() {
                                _validationError = error;
                              });
                              return error;
                            },
                            onChanged: (value) {
                              // Clear validation error when user types
                              if (_validationError != null) {
                                setState(() {
                                  _validationError = null;
                                });
                              }
                              widget.onChanged?.call(value);
                            },
                            onFieldSubmitted: widget.onFieldSubmitted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.helperText != null &&
                    (widget.errorText ?? _validationError) == null) ...[
                  Padding(
                    padding: EdgeInsets.only(
                      left: widget.leadingIcon != null
                          ? AppConstants.spacing32
                          : 0,
                    ),
                    child: Text(
                      widget.helperText!,
                      style: AppTypography.bodySmall().copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
