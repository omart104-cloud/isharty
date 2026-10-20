import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../models/sign_gloss_model.dart';

/// Card widget presenting structured metadata for an ASL Signbank gloss.
class SignMetadataCard extends StatelessWidget {
  final SignGlossModel gloss;

  const SignMetadataCard({
    super.key,
    required this.gloss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppColors.primaryNavy.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: AppColors.primaryNavy,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Gloss Metadata',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const Spacer(),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (gloss.videoUrl != null)
                        ? AppColors.emeraldGreen.withOpacity(0.12)
                        : Colors.orange.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: (gloss.videoUrl != null)
                          ? AppColors.emeraldGreen.withOpacity(0.3)
                          : Colors.orange.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        (gloss.videoUrl != null)
                            ? Icons.check_circle_rounded
                            : Icons.warning_amber_rounded,
                        size: 14,
                        color: (gloss.videoUrl != null)
                            ? AppColors.emeraldGreen
                            : Colors.orange.shade800,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        gloss.videoUrl != null ? 'Video Available' : 'No Video',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: (gloss.videoUrl != null)
                              ? AppColors.emeraldGreen
                              : Colors.orange.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Metadata Grid: ID, Name, Source
            _buildMetaRow(
              context,
              icon: Icons.tag_rounded,
              label: 'Gloss ID',
              value: '#${gloss.id}',
            ),
            const Divider(height: 18, color: AppColors.cardBorder),

            _buildMetaRow(
              context,
              icon: Icons.label_important_outline_rounded,
              label: 'Annotation Label',
              value: gloss.glossName,
            ),
            const Divider(height: 18, color: AppColors.cardBorder),

            _buildMetaRow(
              context,
              icon: Icons.school_outlined,
              label: 'Source',
              value: 'Haskins Global Signbank (Yale University)',
            ),

            if (gloss.videoUrl != null) ...[
              const Divider(height: 18, color: AppColors.cardBorder),
              _buildVideoUrlSection(context, gloss.videoUrl!),
            ],

            // Keywords / Translation Equivalents
            if (gloss.keywords.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Translation Equivalents & Keywords',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: gloss.keywords.map((k) {
                  return Chip(
                    label: Text(
                      k,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryNavy,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor: AppColors.mainBackground,
                    side: const BorderSide(color: AppColors.cardBorder, width: 0.8),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetaRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.mutedText),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoUrlSection(BuildContext context, String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.link_rounded, size: 16, color: AppColors.mutedText),
            SizedBox(width: 8),
            Text(
              'Extracted Video Link',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.mainBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              Expanded(
                child: SelectableText(
                  url,
                  maxLines: 1,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 16, color: AppColors.primaryNavy),
                tooltip: 'Copy video URL',
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: url));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Video URL copied to clipboard'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
