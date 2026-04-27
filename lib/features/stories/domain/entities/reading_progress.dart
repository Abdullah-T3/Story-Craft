class ReadingProgress {
  const ReadingProgress({
    required this.storyId,
    required this.lastPageIndex,
    required this.progress,
    required this.lastOpenedAt,
    required this.completed,
  });

  final String storyId;
  final int lastPageIndex;
  final double progress;
  final DateTime lastOpenedAt;
  final bool completed;
}
