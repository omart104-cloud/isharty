import 'package:flutter/foundation.dart';
import '../models/sign_gloss_model.dart';

/// Base state for ASL Signbank gloss operations.
@immutable
abstract class SignGlossState {
  const SignGlossState();
}

/// Initial state before any gloss has been requested.
class SignGlossInitial extends SignGlossState {
  const SignGlossInitial();

  @override
  bool operator ==(Object other) => identical(this, other) || other is SignGlossInitial;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'SignGlossInitial()';
}

/// State indicating that a gloss is currently being loaded from ASL Signbank.
class SignGlossLoading extends SignGlossState {
  /// The ID of the gloss being loaded.
  final int glossId;

  const SignGlossLoading(this.glossId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SignGlossLoading && other.glossId == glossId;

  @override
  int get hashCode => glossId.hashCode;

  @override
  String toString() => 'SignGlossLoading(id: $glossId)';
}

/// State indicating that gloss data was successfully fetched and parsed.
class SignGlossLoaded extends SignGlossState {
  /// The loaded ASL Signbank gloss model.
  final SignGlossModel gloss;

  const SignGlossLoaded(this.gloss);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SignGlossLoaded && other.gloss == gloss;

  @override
  int get hashCode => gloss.hashCode;

  @override
  String toString() => 'SignGlossLoaded(gloss: ${gloss.glossName}, id: ${gloss.id})';
}

/// State indicating an error occurred while fetching or parsing the gloss.
class SignGlossError extends SignGlossState {
  /// User-friendly error message.
  final String message;

  /// Optional ID that failed to load, for convenient retrying.
  final int? glossId;

  const SignGlossError(this.message, {this.glossId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignGlossError &&
          other.message == message &&
          other.glossId == glossId;

  @override
  int get hashCode => message.hashCode ^ (glossId?.hashCode ?? 0);

  @override
  String toString() => 'SignGlossError(message: "$message", glossId: $glossId)';
}
