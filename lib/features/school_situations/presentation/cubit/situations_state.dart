import 'package:flutter/foundation.dart';
import '../../domain/entities/situation_entity.dart';

enum SituationsStatus { initial, loading, loaded, error }

@immutable
class SituationsState {
  final SituationsStatus status;
  final List<SchoolSituationEntity> situations;
  final String? errorMessage;

  const SituationsState({
    this.status = SituationsStatus.initial,
    this.situations = const [],
    this.errorMessage,
  });

  SituationsState copyWith({
    SituationsStatus? status,
    List<SchoolSituationEntity>? situations,
    String? errorMessage,
  }) {
    return SituationsState(
      status: status ?? this.status,
      situations: situations ?? this.situations,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SituationsState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          listEquals(situations, other.situations);

  @override
  int get hashCode => status.hashCode ^ Object.hashAll(situations);
}
