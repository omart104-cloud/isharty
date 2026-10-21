import 'dart:async';
import 'dart:ui';

enum ReservedRegionKind {
  occlusion,
  division,
  hinge,
}

enum SizeClass {
  compact,
  regular,
}

class ReservedRegion {
  const ReservedRegion({
    this.bounds = Rect.zero,
    this.kind = ReservedRegionKind.occlusion,
    this.isActive = true,
  });

  final Rect bounds;
  final ReservedRegionKind kind;
  final bool isActive;
}

class FoldableData {
  const FoldableData({
    this.regions = const <ReservedRegion>[],
    this.capabilities = 0,
    this.status = 0,
    this.angleDegrees = 0.0,
    this.displayFeatures = const [],
    this.horizontalSizeClass = SizeClass.compact,
    this.verticalSizeClass = SizeClass.regular,
  });

  final List<ReservedRegion> regions;
  final dynamic capabilities;
  final dynamic status;
  final double angleDegrees;
  final dynamic displayFeatures;
  final SizeClass horizontalSizeClass;
  final SizeClass verticalSizeClass;

  static const FoldableData unsupported = FoldableData();
}

class Foldable {
  static Future<FoldableData> get snapshot =>
      Future.value(FoldableData.unsupported);
  static Stream<FoldableData> get changes => const Stream.empty();
}
