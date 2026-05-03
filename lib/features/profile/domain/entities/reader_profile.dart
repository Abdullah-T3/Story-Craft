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

  ReaderProfile copyWith({
    String? uid,
    String? displayName,
    String? avatarEmoji,
    String? photoUrl,
    String? levelKey,
    DateTime? joinedAt,
    int? badgesCount,
    int? storiesWritten,
    int? storiesPrinted,
  }) {
    return ReaderProfile(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      photoUrl: photoUrl ?? this.photoUrl,
      levelKey: levelKey ?? this.levelKey,
      joinedAt: joinedAt ?? this.joinedAt,
      badgesCount: badgesCount ?? this.badgesCount,
      storiesWritten: storiesWritten ?? this.storiesWritten,
      storiesPrinted: storiesPrinted ?? this.storiesPrinted,
    );
  }
}
