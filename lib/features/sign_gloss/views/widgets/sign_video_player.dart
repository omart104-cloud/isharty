import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/theme/app_colors.dart';

/// A production-ready, responsive video player widget tailored for ASL gloss playback.
///
/// Features:
/// - Autoplay enabled on initialization.
/// - Looping enabled by default for continuous sign gesture observation.
/// - Aspect ratio preservation.
/// - Play / Pause toggle overlay and touch gesture.
/// - Speed adjustments (0.5x, 0.75x, 1.0x, 1.25x) essential for sign language learning.
/// - Robust lifecycle management disposing [VideoPlayerController] cleanly.
class SignGlossVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? glossTitle;

  const SignGlossVideoPlayer({
    super.key,
    required this.videoUrl,
    this.glossTitle,
  });

  @override
  State<SignGlossVideoPlayer> createState() => _SignGlossVideoPlayerState();
}

class _SignGlossVideoPlayerState extends State<SignGlossVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isInitializing = true;
  String? _initError;
  bool _showControls = true;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _initializePlayer(widget.videoUrl);
  }

  @override
  void didUpdateWidget(covariant SignGlossVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _initializePlayer(widget.videoUrl);
    }
  }

  /// Resolves the URL to a domain matching the server's TLS certificate.
  ///
  /// The Yale Haskins server serves videos from the same machine as aslsignbank.com,
  /// but its TLS certificate is only valid for:
  ///   CN=aslsignbank.com, subjectAltNames=[aslsignbank.com, ling01.clas.uconn.edu]
  /// Native mobile players (such as Android ExoPlayer) strictly verify hostnames and reject
  /// aslsignbank.haskins.yale.edu with SSLPeerUnverifiedException.
  static String resolvePlayableUrl(String rawUrl) {
    var resolved = rawUrl.trim();
    if (resolved.startsWith('//')) {
      resolved = 'https:$resolved';
    } else if (resolved.startsWith('/')) {
      resolved = 'https://aslsignbank.com$resolved';
    }
    return resolved.replaceAll('aslsignbank.haskins.yale.edu', 'aslsignbank.com');
  }

  Future<void> _initializePlayer(String url) async {
    setState(() {
      _isInitializing = true;
      _initError = null;
    });

    // Safely dispose the previous controller before creating a new one
    final oldController = _controller;
    _controller = null;
    await oldController?.dispose();

    if (!mounted) return;

    try {
      final playableUrl = resolvePlayableUrl(url);
      final uri = Uri.parse(playableUrl);
      final controller = VideoPlayerController.networkUrl(uri);

      _controller = controller;

      await controller.initialize();
      await controller.setLooping(true);
      await controller.setPlaybackSpeed(_playbackSpeed);
      await controller.play();

      controller.addListener(_videoListener);

      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        final errorStr = e.toString();
        final displayError = errorStr.contains('channel-error') ||
                errorStr.contains('Unable to establish connection on channel')
            ? 'Native video plugin not linked in running build. Please stop the app and re-run (flutter run).'
            : 'Could not play sign video ($e)';
        setState(() {
          _isInitializing = false;
          _initError = displayError;
        });
      }
    }
  }

  void _videoListener() {
    if (!mounted) return;
    final controller = _controller;
    if (controller != null && controller.value.hasError) {
      final desc = controller.value.errorDescription ?? 'Playback error';
      if (_initError != desc) {
        setState(() {
          _initError = desc;
        });
      }
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    // Ensure all controller listeners and native video instances are disposed properly
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  void _togglePlayPause() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
    setState(() {});
  }

  void _cyclePlaybackSpeed() {
    final speeds = [0.5, 0.75, 1.0, 1.25];
    final currentIndex = speeds.indexOf(_playbackSpeed);
    final nextSpeed = speeds[(currentIndex + 1) % speeds.length];

    setState(() {
      _playbackSpeed = nextSpeed;
    });
    _controller?.setPlaybackSpeed(nextSpeed);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = _controller;

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Video Canvas with AspectRatio
          Container(
            color: Colors.black,
            child: AspectRatio(
              aspectRatio: (controller != null &&
                      controller.value.isInitialized &&
                      controller.value.aspectRatio > 0)
                  ? controller.value.aspectRatio
                  : (16 / 9),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (controller != null && controller.value.isInitialized)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showControls = !_showControls;
                        });
                      },
                      onDoubleTap: _togglePlayPause,
                      child: VideoPlayer(controller),
                    ),

                  // Loading State Indicator
                  if (_isInitializing)
                    Container(
                      color: Colors.black87,
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Loading ASL video...',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Video Initialization Error
                  if (_initError != null)
                    Container(
                      color: Colors.black87,
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 40),
                            const SizedBox(height: 8),
                            Text(
                              _initError!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            const SizedBox(height: 12),
                            FilledButton.tonalIcon(
                              onPressed: () => _initializePlayer(widget.videoUrl),
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text('Retry Video'),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Center Play/Pause Overlay Button
                  if (controller != null &&
                      controller.value.isInitialized &&
                      (!controller.value.isPlaying || _showControls))
                    GestureDetector(
                      onTap: _togglePlayPause,
                      child: AnimatedOpacity(
                        opacity: (!controller.value.isPlaying || _showControls) ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                          ),
                          child: Icon(
                            controller.value.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 38,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  // Quick Looping Badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24, width: 0.5),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.repeat_rounded, size: 13, color: Colors.white70),
                          SizedBox(width: 4),
                          Text(
                            'Looping',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Video Control Strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
            child: Row(
              children: [
                // Play / Pause Icon
                IconButton(
                  tooltip: controller?.value.isPlaying == true ? 'Pause' : 'Play',
                  icon: Icon(
                    controller?.value.isPlaying == true
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_fill_rounded,
                    color: AppColors.primaryNavy,
                    size: 28,
                  ),
                  onPressed: _togglePlayPause,
                ),

                // Replay button
                IconButton(
                  tooltip: 'Replay from start',
                  icon: const Icon(Icons.replay_rounded, size: 22, color: AppColors.primaryNavy),
                  onPressed: () {
                    controller?.seekTo(Duration.zero);
                    controller?.play();
                  },
                ),

                const Spacer(),

                // Playback speed selector chip
                InkWell(
                  onTap: _cyclePlaybackSpeed,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primaryNavy.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primaryNavy.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.speed_rounded, size: 16, color: AppColors.primaryNavy),
                        const SizedBox(width: 4),
                        Text(
                          '${_playbackSpeed}x',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                // Copy video link
                IconButton(
                  tooltip: 'Copy video URL',
                  icon: const Icon(Icons.copy_rounded, size: 19, color: AppColors.secondaryText),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.videoUrl));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Video URL copied to clipboard'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
