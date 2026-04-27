import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';

class AvatarBadge extends StatelessWidget {
  const AvatarBadge({
    super.key,
    required this.emoji,
    this.photoUrl,
    this.size = 80,
  });

  final String emoji;
  final String? photoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final dimension = size.r;
    final hasPhoto = (photoUrl != null && photoUrl!.isNotEmpty);

    return Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        image: hasPhoto
            ? DecorationImage(
                image: NetworkImage(photoUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      alignment: Alignment.center,
      child: hasPhoto ? null : Text(emoji, style: TextStyle(fontSize: 36.sp)),
    );
  }
}
