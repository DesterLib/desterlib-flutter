// External packages
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Core
import 'package:dester/core/widgets/d_cached_image.dart';
import 'package:dester/core/constants/app_typography.dart';

/// Cast or Crew member data model
class CastCrewMember {
  final String id;
  final String name;
  final String? profileImageUrl;
  final String? role; // e.g., "Director", "Actor", "Writer"
  final String? character; // Character name for actors

  const CastCrewMember({
    required this.id,
    required this.name,
    this.profileImageUrl,
    this.role,
    this.character,
  });
}

/// Card widget for displaying a cast or crew member with circular image
class CastCrewCard extends StatelessWidget {
  final CastCrewMember member;
  final VoidCallback? onTap;

  const CastCrewCard({super.key, required this.member, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular profile image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: member.profileImageUrl != null
                    ? DCachedImage.backdrop(
                        imageUrl: member.profileImageUrl!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey[900],
                        child: const Center(
                          child: Icon(
                            LucideIcons.user,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            // Name
            Text(
              member.name,
              style: AppTypography.inter(
                fontSize: AppTypography.fontSizeSm,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Role or Character
            if (member.character != null)
              Text(
                member.character!,
                style: AppTypography.bodySmall(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            else if (member.role != null)
              Text(
                member.role!,
                style: AppTypography.bodySmall(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
