import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/platform_icons.dart';

class DCard extends StatefulWidget {
  final String title;
  final String year;
  final String? imageUrl;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool isCompact;
  final bool isInGrid;

  const DCard({
    super.key,
    required this.title,
    required this.year,
    this.imageUrl,
    this.onTap,
    this.width,
    this.height,
    this.isCompact = false,
    this.isInGrid = false,
  });

  @override
  State<DCard> createState() => _DCardState();
}

class _DCardState extends State<DCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 768;
    final titleSize = widget.isCompact || isSmallScreen ? 14.0 : 16.0;
    final yearSize = widget.isCompact || isSmallScreen ? 12.0 : 14.0;
    final spacing = widget.isCompact || isSmallScreen ? 6.0 : 8.0;

    Widget buildImage() {
      if (widget.width != null && widget.height != null) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: _buildCardContent(),
        );
      }
      return AspectRatio(aspectRatio: 16 / 10, child: _buildCardContent());
    }

    Widget buildText({bool flexible = false}) {
      final textContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.5,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            widget.year,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: yearSize,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
      return flexible ? Flexible(child: textContent) : textContent;
    }

    final content = widget.isInGrid
        ? LayoutBuilder(
            builder: (context, constraints) => SizedBox(
              height: constraints.maxHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildImage(),
                  SizedBox(height: spacing),
                  buildText(flexible: true),
                ],
              ),
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildImage(),
              SizedBox(height: spacing + 4),
              if (widget.width != null)
                SizedBox(width: widget.width, child: buildText())
              else
                buildText(),
            ],
          );

    return IntrinsicHeight(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: (_) {
            HapticFeedback.lightImpact();
            setState(() => _isPressed = true);
          },
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onTap?.call();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedScale(
            scale: _isPressed
                ? 0.98
                : _isHovered
                ? 1.02
                : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: content,
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    final hasImage = widget.imageUrl != null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image or color
          if (hasImage)
            Image.network(
              widget.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: const Color(0xFF1a1a1a)),
            )
          else
            Container(color: const Color(0xFF1a1a1a)),

          // Glassmorphism overlay
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: _isHovered ? 5 : 10,
              sigmaY: _isHovered ? 5 : 10,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: ShapeDecoration(
                color: _isHovered
                    ? Colors.white.withValues(alpha: 0.25)
                    : Colors.white.withValues(alpha: 0.15),
                shape: RoundedSuperellipseBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: _isHovered
                        ? Colors.white.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.2),
                    width: _isHovered ? 2 : 1,
                  ),
                ),
              ),
            ),
          ),

          // Icon (after blur, so it's not blurred)
          if (!hasImage)
            Center(
              child: Icon(
                PlatformIcons.movie,
                color: const Color(0xFF666666),
                size: 48,
              ),
            ),
        ],
      ),
    );
  }
}

class DCardData {
  final String title;
  final String year;
  final String? imageUrl;
  final VoidCallback? onTap;

  const DCardData({
    required this.title,
    required this.year,
    this.imageUrl,
    this.onTap,
  });
}
