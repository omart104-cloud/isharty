import 'package:flutter/foundation.dart';

@immutable
class AppPreferencesEntity {
  final int currentTabIndex;
  final double fontSizeScale;
  final bool highContrast;
  final bool reduceMotion;
  final String studentName;
  final int streakDays;

  const AppPreferencesEntity({
    this.currentTabIndex = 0,
    this.fontSizeScale = 1.0,
    this.highContrast = false,
    this.reduceMotion = false,
    this.studentName = 'أحمد مصطفى',
    this.streakDays = 7,
  });

  AppPreferencesEntity copyWith({
    int? currentTabIndex,
    double? fontSizeScale,
    bool? highContrast,
    bool? reduceMotion,
    String? studentName,
    int? streakDays,
  }) {
    return AppPreferencesEntity(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      fontSizeScale: fontSizeScale ?? this.fontSizeScale,
      highContrast: highContrast ?? this.highContrast,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      studentName: studentName ?? this.studentName,
      streakDays: streakDays ?? this.streakDays,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppPreferencesEntity &&
          runtimeType == other.runtimeType &&
          currentTabIndex == other.currentTabIndex &&
          fontSizeScale == other.fontSizeScale &&
          highContrast == other.highContrast &&
          reduceMotion == other.reduceMotion &&
          studentName == other.studentName &&
          streakDays == other.streakDays;

  @override
  int get hashCode =>
      currentTabIndex.hashCode ^
      fontSizeScale.hashCode ^
      highContrast.hashCode ^
      reduceMotion.hashCode ^
      studentName.hashCode ^
      streakDays.hashCode;
}
