import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_adaptive_app_bar.dart';
import '../cubit/sign_gloss_cubit.dart';
import '../cubit/sign_gloss_state.dart';
import '../repository/signbank_repository.dart';
import 'widgets/sign_metadata_card.dart';
import 'widgets/sign_video_player.dart';

/// Screen displaying ASL Signbank dictionary gloss video and metadata.
class SignGlossScreen extends StatelessWidget {
  final int initialGlossId;
  final SignbankRepository? repository;

  const SignGlossScreen({
    super.key,
    this.initialGlossId = 1,
    this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignGlossCubit>(
      create: (context) =>
          SignGlossCubit(repository: repository)..loadGloss(initialGlossId),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SignGlossView(initialId: initialGlossId),
      ),
    );
  }
}

/// Internal view widget containing the state management listeners and UI layout.
class SignGlossView extends StatefulWidget {
  final int initialId;

  const SignGlossView({
    super.key,
    required this.initialId,
  });

  @override
  State<SignGlossView> createState() => _SignGlossViewState();
}

class _SignGlossViewState extends State<SignGlossView> {
  late final TextEditingController _idController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Quick preset gloss IDs for convenient demonstration and testing
  final List<({int id, String label})> _sampleGlosses = const [
    (id: 1, label: 'SUMMARIZE'),
    (id: 2, label: 'DANCE'),
    (id: 3, label: 'GIVE'),
    (id: 10, label: 'ALL-DAY'),
    (id: 24, label: 'BASEBALL'),
  ];

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.initialId.toString());
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  void _submitSearch() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      final id = int.tryParse(_idController.text.trim());
      if (id != null && id > 0) {
        context.read<SignGlossCubit>().loadGloss(id);
      }
    }
  }

  void _navigateToId(int id) {
    if (id <= 0) return;
    _idController.text = id.toString();
    _submitSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppAdaptiveAppBar(
        titleText: 'ASL Signbank Gloss',
        subtitleText: 'Haskins Laboratories • Yale University',
        actions: [
          AppAdaptiveAppBarAction(
            materialIcon: Icons.info_outline_rounded,
            cupertinoIcon: CupertinoIcons.info_circle,
            tooltip: 'About ASL Signbank',
            color: AppColors.primaryNavy,
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search / ID input bar
              _buildSearchCard(context),
              const SizedBox(height: 14),

              // Quick preset gloss chips
              _buildSampleGlossesBar(),
              const SizedBox(height: 20),

              // Dynamic Cubit State Content
              BlocConsumer<SignGlossCubit, SignGlossState>(
                listener: (context, state) {
                  if (state is SignGlossLoaded) {
                    // Sync controller if requested from another trigger
                    if (_idController.text != state.gloss.id.toString()) {
                      _idController.text = state.gloss.id.toString();
                    }
                  }
                },
                builder: (context, state) {
                  if (state is SignGlossLoading) {
                    return _buildLoadingState(state.glossId);
                  } else if (state is SignGlossLoaded) {
                    return _buildLoadedState(context, state);
                  } else if (state is SignGlossError) {
                    return _buildErrorState(context, state);
                  } else {
                    return _buildInitialState(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Search & ID Input Bar (Material 3 styling with numeric validation)
  Widget _buildSearchCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Input field for numeric Gloss ID
              Expanded(
                child: TextFormField(
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (_) => _submitSearch(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter a gloss ID';
                    }
                    final id = int.tryParse(value.trim());
                    if (id == null || id <= 0) {
                      return 'Must be > 0';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.primaryNavy,
                    ),
                    suffixIcon: _idController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _idController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    labelText: 'Signbank Gloss ID',
                    hintText: 'e.g. 1',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.cardBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // "Fetch Sign" Button
              FilledButton.icon(
                onPressed: _submitSearch,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryNavy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text(
                  'Fetch Sign',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Preset sample gloss chips for quick testing
  Widget _buildSampleGlossesBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const Text(
            'Quick examples: ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryText,
            ),
          ),
          ..._sampleGlosses.map((sample) {
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ActionChip(
                label: Text('#${sample.id} ${sample.label}'),
                labelStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryNavy,
                ),
                backgroundColor: Colors.white,
                side: const BorderSide(color: AppColors.cardBorder),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                onPressed: () => _navigateToId(sample.id),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Loading State View
  Widget _buildLoadingState(int id) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3.5,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryNavy),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Fetching Sign Gloss #$id...',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Querying Yale ASL Signbank & parsing media sources',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  /// Loaded State View: Gloss Title, Video Player, Navigation & Metadata
  Widget _buildLoadedState(BuildContext context, SignGlossLoaded state) {
    final gloss = state.gloss;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Gloss Header Card
        Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: AppColors.cardBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon Avatar
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryNavy.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.sign_language_rounded,
                    color: AppColors.primaryNavy,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),

                // Title and ID
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gloss.glossName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryText,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ASL Sign Gloss • ID #${gloss.id}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Next / Previous Navigation Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                      tooltip: 'Previous Sign (#${gloss.id - 1})',
                      onPressed: gloss.id > 1 ? () => _navigateToId(gloss.id - 1) : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      tooltip: 'Next Sign (#${gloss.id + 1})',
                      onPressed: () => _navigateToId(gloss.id + 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Video Player Section
        if (gloss.videoUrl != null && gloss.videoUrl!.isNotEmpty) ...[
          SignGlossVideoPlayer(
            videoUrl: gloss.videoUrl!,
            glossTitle: gloss.glossName,
          ),
          const SizedBox(height: 16),
        ] else ...[
          // Fallback notice if gloss has no video recorded
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Column(
              children: [
                Icon(Icons.videocam_off_outlined, size: 48, color: AppColors.mutedText),
                SizedBox(height: 10),
                Text(
                  'No video recorded for this gloss',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'This entry exists in the Signbank dataset without an attached MP4 video.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Metadata Card (ID, extracted video link, and status)
        SignMetadataCard(gloss: gloss),
      ],
    );
  }

  /// Clean Error State View with Retry Button
  Widget _buildErrorState(BuildContext context, SignGlossError state) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.red.shade100, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 36,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to Load Gloss',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.secondaryText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                final targetId = state.glossId ?? int.tryParse(_idController.text.trim()) ?? 1;
                context.read<SignGlossCubit>().loadGloss(targetId);
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryNavy,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(
                'Retry',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Initial Placeholder State View
  Widget _buildInitialState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_rounded,
            size: 44,
            color: AppColors.mutedText,
          ),
          const SizedBox(height: 12),
          const Text(
            'Explore ASL Signbank',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Enter a numeric gloss ID above to load ASL sign videos and annotations.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: () => _navigateToId(1),
            child: const Text('Load Sign #1 (SUMMARIZE)'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.school_rounded, color: AppColors.primaryNavy),
            SizedBox(width: 8),
            Text('About ASL Signbank'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The ASL Signbank is hosted by Haskins Laboratories at Yale University. '
              'It provides an open lexical database and reference video corpus for American Sign Language.\n',
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
            Text(
              'Endpoint structure:\nhttps://aslsignbank.haskins.yale.edu/dictionary/gloss/{id}/',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: AppColors.primaryNavy,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
