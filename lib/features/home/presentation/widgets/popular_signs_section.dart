import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../dictionary/data/sign_model.dart';
import '../../../dictionary/presentation/widgets/sign_card.dart';

class PopularSignsSection extends StatelessWidget {
  final List<SignModel> signs;

  const PopularSignsSection({
    super.key,
    required this.signs,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 182,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.standard),
        itemCount: signs.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.small),
        itemBuilder: (context, index) {
          final sign = signs[index];
          return SignCard(
            sign: sign,
            isHorizontalCompact: true,
          );
        },
      ),
    );
  }
}
