import 'package:flutter_test/flutter_test.dart';
import 'package:isharty/features/sign_gloss/cubit/sign_gloss_cubit.dart';
import 'package:isharty/features/sign_gloss/cubit/sign_gloss_state.dart';
import 'package:isharty/features/sign_gloss/models/sign_gloss_model.dart';
import 'package:isharty/features/sign_gloss/repository/signbank_repository.dart';

class FakeSignbankRepository extends SignbankRepository {
  final SignGlossModel? modelToReturn;
  final Exception? exceptionToThrow;

  FakeSignbankRepository({
    this.modelToReturn,
    this.exceptionToThrow,
  });

  @override
  Future<SignGlossModel> fetchGlossById(int id) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return modelToReturn ??
        SignGlossModel(
          id: id,
          glossName: 'FAKE_SIGN_$id',
          videoUrl: 'https://example.com/video_$id.mp4',
          keywords: const ['test'],
        );
  }
}

void main() {
  group('SignGlossCubit', () {
    test('initial state is SignGlossInitial', () {
      final cubit = SignGlossCubit(repository: FakeSignbankRepository());
      expect(cubit.state, const SignGlossInitial());
      expect(cubit.lastRequestedId, isNull);
    });

    test('loadGloss emits [SignGlossLoading, SignGlossLoaded] on success', () async {
      const expectedModel = SignGlossModel(
        id: 1,
        glossName: 'SUMMARIZE',
        videoUrl: 'https://aslsignbank.haskins.yale.edu/video.mp4',
        keywords: ['summary'],
      );

      final cubit = SignGlossCubit(
        repository: FakeSignbankRepository(modelToReturn: expectedModel),
      );

      final states = <SignGlossState>[];
      cubit.stream.listen(states.add);

      await cubit.loadGloss(1);
      await Future<void>.delayed(Duration.zero);

      expect(states, [
        const SignGlossLoading(1),
        const SignGlossLoaded(expectedModel),
      ]);
      expect(cubit.state, const SignGlossLoaded(expectedModel));
      expect(cubit.lastRequestedId, 1);
    });

    test('loadGloss emits [SignGlossLoading, SignGlossError] on repository failure', () async {
      final cubit = SignGlossCubit(
        repository: FakeSignbankRepository(
          exceptionToThrow: const SignbankNotFoundException('Gloss #999 not found'),
        ),
      );

      final states = <SignGlossState>[];
      cubit.stream.listen(states.add);

      await cubit.loadGloss(999);
      await Future<void>.delayed(Duration.zero);

      expect(states, [
        const SignGlossLoading(999),
        const SignGlossError('Gloss #999 not found', glossId: 999),
      ]);
      expect(cubit.state, const SignGlossError('Gloss #999 not found', glossId: 999));
    });

    test('loadGloss emits SignGlossError immediately if id <= 0', () async {
      final cubit = SignGlossCubit(repository: FakeSignbankRepository());

      final states = <SignGlossState>[];
      cubit.stream.listen(states.add);

      await cubit.loadGloss(0);
      await Future<void>.delayed(Duration.zero);

      expect(states.length, 1);
      expect(states.first, isA<SignGlossError>());
    });

    test('retry calls loadGloss with last requested ID', () async {
      final cubit = SignGlossCubit(
        repository: FakeSignbankRepository(),
      );

      await cubit.loadGloss(42);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state, isA<SignGlossLoaded>());
      expect((cubit.state as SignGlossLoaded).gloss.id, 42);

      await cubit.retry();
      await Future<void>.delayed(Duration.zero);
      expect(cubit.lastRequestedId, 42);
    });
  });
}
