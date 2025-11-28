// External packages
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';

/// Custom FormBuilderField wrapper for scan settings page
/// Allows customization of FormBuilderField UI specifically for scan settings
class ScanSettingsFormField<T> extends StatelessWidget {
  final String name;
  final T? initialValue;
  final String? Function(T?)? validator;
  final FormFieldBuilder<T> builder;

  // Custom styling options
  final EdgeInsets? padding;
  final BoxDecoration? decoration;
  final Color? backgroundColor;
  final double? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const ScanSettingsFormField({
    super.key,
    required this.name,
    this.initialValue,
    this.validator,
    required this.builder,
    this.padding,
    this.decoration,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration:
          decoration ??
          BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius != null
                ? BorderRadius.circular(borderRadius!)
                : null,
            border: border,
            boxShadow: boxShadow,
          ),
      child: FormBuilderField<T>(
        name: name,
        initialValue: initialValue,
        validator: validator,
        builder: builder,
      ),
    );
  }
}

/// Custom form field for scan settings with customizable label, helper text, and styling
class ScanSettingsTextField extends StatefulWidget {
  final FormFieldState<String> field;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final TextInputType? keyboardType;
  final bool enabled;
  final bool isFirst;
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final Widget? suffixIcon;
  final int? maxLines;

  // Customizable styling for scan settings
  final EdgeInsets? containerPadding;
  final Color? containerBackgroundColor;
  final Border? containerBorder;
  final double? containerBorderRadius;
  final TextStyle? labelStyle;
  final TextStyle? helperTextStyle;
  final TextStyle? inputTextStyle;
  final TextStyle? hintTextStyle;
  final Color? labelColor;
  final Color? helperTextColor;
  final double? labelFontSize;
  final double? helperTextFontSize;
  final FontWeight? labelFontWeight;
  final FontWeight? helperTextFontWeight;
  final double? spacingBetweenLabelAndInput;
  final double? spacingBetweenInputAndHelper;

  const ScanSettingsTextField({
    super.key,
    required this.field,
    this.labelText,
    this.hintText,
    this.helperText,
    this.keyboardType,
    this.enabled = true,
    this.isFirst = false,
    this.leadingIcon,
    this.leadingIconColor,
    this.suffixIcon,
    this.maxLines,
    this.containerPadding,
    this.containerBackgroundColor,
    this.containerBorder,
    this.containerBorderRadius,
    this.labelStyle,
    this.helperTextStyle,
    this.inputTextStyle,
    this.hintTextStyle,
    this.labelColor,
    this.helperTextColor,
    this.labelFontSize,
    this.helperTextFontSize,
    this.labelFontWeight,
    this.helperTextFontWeight,
    this.spacingBetweenLabelAndInput,
    this.spacingBetweenInputAndHelper,
  });

  @override
  State<ScanSettingsTextField> createState() => _ScanSettingsTextFieldState();
}

class _ScanSettingsTextFieldState extends State<ScanSettingsTextField> {
  late TextEditingController _controller;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.field.value);
  }

  @override
  void didUpdateWidget(ScanSettingsTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller.text != widget.field.value) {
      _controller.text = widget.field.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build label style
    final labelStyle =
        widget.labelStyle ??
        AppTypography.titleSmall().copyWith(
          color: widget.labelColor,
          fontSize: widget.labelFontSize,
          fontWeight: widget.labelFontWeight,
        );

    // Build helper text style
    final helperTextStyle =
        widget.helperTextStyle ??
        AppTypography.bodySmall().copyWith(
          color:
              widget.helperTextColor ??
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          fontSize: widget.helperTextFontSize,
          fontWeight: widget.helperTextFontWeight,
        );

    // Build input text style
    final inputTextStyle = widget.inputTextStyle ?? AppTypography.bodyMedium();

    // Build hint text style
    final hintTextStyle =
        widget.hintTextStyle ??
        AppTypography.bodyMedium().copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        );

    return Container(
      padding:
          widget.containerPadding ??
          AppConstants.paddingX(AppConstants.spacing16),
      decoration: BoxDecoration(
        color: widget.containerBackgroundColor,
        borderRadius: widget.containerBorderRadius != null
            ? BorderRadius.circular(widget.containerBorderRadius!)
            : null,
        border: widget.isFirst
            ? widget.containerBorder
            : (widget.containerBorder ??
                  Border(
                    top: BorderSide(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  )),
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
                    children: [
                      if (widget.labelText != null) ...[
                        Expanded(
                          child: Text(widget.labelText!, style: labelStyle),
                        ),
                      ],
                      Expanded(
                        flex: widget.labelText != null ? 2 : 1,
                        child: TextFormField(
                          controller: _controller,
                          enabled: widget.enabled,
                          obscureText: false,
                          maxLines: widget.maxLines ?? 1,
                          keyboardType: widget.keyboardType,
                          textAlign: widget.labelText != null
                              ? TextAlign.end
                              : TextAlign.start,
                          style: inputTextStyle,
                          decoration: InputDecoration(
                            hintText: widget.hintText,
                            hintStyle: hintTextStyle,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            suffixIcon: widget.suffixIcon,
                            errorText:
                                widget.field.errorText ?? _validationError,
                            errorStyle: AppTypography.bodySmall().copyWith(
                              color: AppConstants.dangerColor,
                            ),
                            errorMaxLines: 2,
                          ),
                          validator: (value) {
                            final error = widget.field.errorText;
                            setState(() {
                              _validationError = error;
                            });
                            return error;
                          },
                          onChanged: (value) {
                            if (_validationError != null) {
                              setState(() {
                                _validationError = null;
                              });
                            }
                            widget.field.didChange(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.helperText != null &&
                    (widget.field.errorText ?? _validationError) == null) ...[
                  Padding(
                    padding: EdgeInsets.only(
                      left: widget.leadingIcon != null
                          ? AppConstants.spacing32
                          : 0,
                    ),
                    child: Text(widget.helperText!, style: helperTextStyle),
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
