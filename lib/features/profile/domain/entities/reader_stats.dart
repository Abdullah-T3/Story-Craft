class ReaderStats {
  const ReaderStats({
    required this.streakDays,
    required this.lastReadDate,
    required this.storiesRead,
    required this.storiesWritten,
    required this.storiesPrinted,
    required this.streakWeek,
  });

  final int streakDays;
  final DateTime? lastReadDate;
  final int storiesRead;
  final int storiesWritten;
  final int storiesPrinted;
  final List<bool> streakWeek;

  ReaderStats copyWith({
    int? streakDays,
    DateTime? lastReadDate,
    int? storiesRead,
    int? storiesWritten,
    int? storiesPrinted,
    List<bool>? streakWeek,
  }) {
    return ReaderStats(
      streakDays: streakDays ?? this.streakDays,
      lastReadDate: lastReadDate ?? this.lastReadDate,
      storiesRead: storiesRead ?? this.storiesRead,
      storiesWritten: storiesWritten ?? this.storiesWritten,
      storiesPrinted: storiesPrinted ?? this.storiesPrinted,
      streakWeek: streakWeek ?? this.streakWeek,
    );
  }
}
