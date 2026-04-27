import 'package:flutter/material.dart';

class StoryCategory {
  const StoryCategory({
    required this.id,
    required this.labelKey,
    required this.icon,
    required this.color,
  });

  final String id;
  final String labelKey;
  final IconData icon;
  final Color color;
}
