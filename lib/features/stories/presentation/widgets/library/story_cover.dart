import 'package:flutter/material.dart';
import 'package:story_craft/core/theme/app_colors.dart';

/// Reusable cover area: shows the network image when [imageUrl] is set,
/// otherwise falls back to a solid color block with a centred emoji.
class StoryCover extends StatelessWidget {
  const StoryCover({
    super.key,
    required this.imageUrl,
    required this.fallbackColor,
    required this.emoji,
    this.emojiSize = 56,
    this.fit = BoxFit.cover,
  });

  final String? imageUrl;
  final Color fallbackColor;
  final String emoji;
  final double emojiSize;
  final BoxFit fit;

  bool get _hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (!_hasImage) {
      return Container(
        color: fallbackColor,
        alignment: Alignment.center,
        child: Text(emoji, style: TextStyle(fontSize: emojiSize)),
      );
    }
    return Container(
      color: fallbackColor,
      child: Image.network(
        imageUrl!,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primaryDark,
                value: progress.expectedTotalBytes == null
                    ? null
                    : progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stack) => Center(
          child: Text(emoji, style: TextStyle(fontSize: emojiSize)),
        ),
      ),
    );
  }
}
