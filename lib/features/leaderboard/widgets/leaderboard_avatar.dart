import 'package:flutter/material.dart';

import '../../../core/service/api_constants.dart';
import '../../../core/widgets/cachanetwork_image.dart';

class LeaderboardAvatar extends StatelessWidget {
  const LeaderboardAvatar({
    super.key,
    required this.avatarUrl,
    required this.size,
    this.borderColor,
    this.borderWidth = 1,
  });

  final String? avatarUrl;
  final double size;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarUrl != null && avatarUrl!.trim().isNotEmpty;
    final border = borderColor != null
        ? Border.all(color: borderColor!, width: borderWidth)
        : null;

    if (!hasAvatar) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[800],
          border: border,
        ),
        child: Icon(
          Icons.person_outline,
          color: Colors.white.withOpacity(0.85),
          size: size * 0.6,
        ),
      );
    }

    final url = _resolveImageUrl(avatarUrl!);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: border,
      ),
      child: ClipOval(
        child: CustomNetworkImage(
          imageUrl: url,
          height: size,
          width: size,
          boxShape: BoxShape.circle,
        ),
      ),
    );
  }

  String _resolveImageUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    final base = ApiConstants.imageBaseUrl;
    if (base.endsWith('/') && trimmed.startsWith('/')) {
      return '$base${trimmed.substring(1)}';
    }
    if (!base.endsWith('/') && !trimmed.startsWith('/')) {
      return '$base/$trimmed';
    }
    return '$base$trimmed';
  }
}

