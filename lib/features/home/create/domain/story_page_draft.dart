import 'package:flutter/widgets.dart';

class StoryPageDraft {
  StoryPageDraft({required this.controller, this.hasImage = false});

  final TextEditingController controller;
  bool hasImage;
}
