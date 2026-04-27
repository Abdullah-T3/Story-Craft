class StoryPage {
  const StoryPage({
    required this.index,
    required this.text,
    this.imageUrl,
    this.emoji,
  });

  final int index;
  final String text;
  final String? imageUrl;
  final String? emoji;
}
