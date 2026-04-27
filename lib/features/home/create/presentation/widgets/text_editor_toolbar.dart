import 'package:flutter/material.dart';

class TextEditorToolbar extends StatelessWidget {
  final VoidCallback onBold;
  final VoidCallback onAlignLeft;
  final VoidCallback onAlignCenter;
  final VoidCallback onAlignRight;
  final VoidCallback onColor;

  const TextEditorToolbar({
    super.key,
    required this.onBold,
    required this.onAlignLeft,
    required this.onAlignCenter,
    required this.onAlignRight,
    required this.onColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.format_bold),
            onPressed: onBold,
          ),
          IconButton(
            icon: const Icon(Icons.format_align_left),
            onPressed: onAlignLeft,
          ),
          IconButton(
            icon: const Icon(Icons.format_align_center),
            onPressed: onAlignCenter,
          ),
          IconButton(
            icon: const Icon(Icons.format_align_right),
            onPressed: onAlignRight,
          ),
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: onColor,
          ),
        ],
      ),
    );
  }
}