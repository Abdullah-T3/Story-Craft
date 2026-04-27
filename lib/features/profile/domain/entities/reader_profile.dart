class ReaderProfile {
  const ReaderProfile({
    required this.uid,
    required this.displayName,
    required this.avatarEmoji,
    required this.photoUrl,
    required this.levelKey,
    required this.joinedAt,
    required this.badgesCount,
    required this.storiesWritten,
    required this.storiesPrinted,
  });

  final String uid;
  final String displayName;
  final String avatarEmoji;
  final String photoUrl;
  final String levelKey;
  final DateTime joinedAt;
  final int badgesCount;
  final int storiesWritten;
  final int storiesPrinted;

  int monthsSinceJoined(DateTime now) {
    return (now.year - joinedAt.year) * 12 + (now.month - joinedAt.month);
  }
}
