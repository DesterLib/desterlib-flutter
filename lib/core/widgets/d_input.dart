// External packages
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

// Core
import 'package:dester/core/constants/app_constants.dart';
import 'package:dester/core/constants/app_typography.dart';
import 'package:dester/core/widgets/d_icon.dart';

class DInput extends StatelessWidget {
  final String name;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? initialValue;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String?>? onSubmitted;
  final DIconName? leadingIcon;
  final Widget? suffix;
  final bool enabled;
  final int? maxLines;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final bool readOnly;

  const DInput({
    super.key,
    required this.name,
    this.label,
    this.hintText,
    this.helperText,
    this.initialValue,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.leadingIcon,
    this.suffix,
    this.enabled = true,
    this.maxLines = 1,
    this.focusNode,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.labelLarge(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          AppConstants.spacingY(AppConstants.spacingXs),
        ],
        FormBuilderTextField(
          name: name,
          initialValue: initialValue,
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          enabled: enabled,
          maxLines: maxLines,
          focusNode: focusNode,
          onTap: onTap,
          readOnly: readOnly,
          style: AppTypography.bodyMedium(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: hintText,
            helperText: helperText,
            helperStyle: AppTypography.bodySmall(
              color: Colors.white.withValues(alpha: 0.5),
            ),
            hintStyle: AppTypography.bodyMedium(
              color: Colors.white.withValues(alpha: 0.3),
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppConstants.spacing16,
              vertical: maxLines != null && maxLines! > 1
                  ? AppConstants.spacing16
                  : AppConstants.spacing12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              borderSide: const BorderSide(color: Colors.white, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              borderSide: const BorderSide(
                color: AppConstants.dangerColor,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              borderSide: const BorderSide(
                color: AppConstants.dangerColor,
                width: 1,
              ),
            ),
            prefixIcon: leadingIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: AppConstants.spacing16,
                      right: AppConstants.spacing8,
                    ),
                    child: DIcon(
                      icon: leadingIcon!,
                      size: AppConstants.iconSizeMd,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            suffixIcon: suffix != null
                ? Padding(
                    padding: const EdgeInsets.only(
                      right: AppConstants.spacing16,
                      left: AppConstants.spacing8,
                    ),
                    child: suffix,
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
          ),
        ),
      ],
    );
  }
}
