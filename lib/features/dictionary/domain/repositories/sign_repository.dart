import '../../data/sign_model.dart';

/// Contract defining data operations for the sign dictionary.
abstract class SignRepository {
  /// Fetches all signs in the local or cached dictionary corpus.
  Future<List<SignModel>> getAllSigns();

  /// Fetches a single sign by its unique identifier.
  Future<SignModel?> getSignById(String id);

  /// Returns the distinct list of category names.
  Future<List<String>> getCategories();

  /// Retrieves the set of sign IDs bookmarked as favorites.
  Future<Set<String>> getFavoriteSignIds();

  /// Toggles the favorite status of a sign.
  Future<Set<String>> toggleFavoriteSign(String id);

  /// Retrieves the set of sign IDs marked as mastered/completed.
  Future<Set<String>> getCompletedSignIds();

  /// Toggles the completion status of a sign.
  Future<Set<String>> toggleCompletedSign(String id);
}
