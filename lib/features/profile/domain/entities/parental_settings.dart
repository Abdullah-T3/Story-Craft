class ParentalSettings {
  const ParentalSettings({
    required this.ageRangeFrom,
    required this.ageRangeTo,
    required this.contentFilterEnabled,
    required this.dailyQuotaMinutes,
    required this.usedTodayMinutes,
    required this.weeklyScheduleSubtitle,
  });

  final int ageRangeFrom;
  final int ageRangeTo;
  final bool contentFilterEnabled;
  final int dailyQuotaMinutes;
  final int usedTodayMinutes;
  final String weeklyScheduleSubtitle;

  int get remainingMinutes =>
      (dailyQuotaMinutes - usedTodayMinutes).clamp(0, dailyQuotaMinutes);

  double get usageProgress => dailyQuotaMinutes == 0
      ? 0
      : (usedTodayMinutes / dailyQuotaMinutes).clamp(0.0, 1.0);

  ParentalSettings copyWith({
    int? ageRangeFrom,
    int? ageRangeTo,
    bool? contentFilterEnabled,
    int? dailyQuotaMinutes,
    int? usedTodayMinutes,
    String? weeklyScheduleSubtitle,
  }) {
    return ParentalSettings(
      ageRangeFrom: ageRangeFrom ?? this.ageRangeFrom,
      ageRangeTo: ageRangeTo ?? this.ageRangeTo,
      contentFilterEnabled: contentFilterEnabled ?? this.contentFilterEnabled,
      dailyQuotaMinutes: dailyQuotaMinutes ?? this.dailyQuotaMinutes,
      usedTodayMinutes: usedTodayMinutes ?? this.usedTodayMinutes,
      weeklyScheduleSubtitle:
          weeklyScheduleSubtitle ?? this.weeklyScheduleSubtitle,
    );
  }
}
