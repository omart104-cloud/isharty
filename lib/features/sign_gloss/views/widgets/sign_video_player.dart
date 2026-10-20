import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/theme/app_colors.dart';

/// A production-ready, responsive video player widget tailored for ASL gloss playback.
///
/// Features:
/// - Robust local cache downloading avoiding iOS AVPlayer CoreMedia byte-range mismatch (error -12939).
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
  static final Dio _cacheDio = _createCacheDio();

  static Dio _createCacheDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        followRedirects: true,
        maxRedirects: 5,
        headers: {
          'User-Agent':
              'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148',
        },
      ),
    );

    if (!kIsWeb) {
      final adapter = dio.httpClientAdapter;
      if (adapter is IOHttpClientAdapter) {
        adapter.createHttpClient = () {
          final client = HttpClient();
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };
      }
    }

    return dio;
  }

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
      VideoPlayerController controller;

      if (!kIsWeb) {
        // iOS AVPlayer fails with CoreMedia error -12939 on servers that do not
        // support HTTP 206 Partial Content byte-ranges (returning full 200 OK for byte 0-1).
        // Pre-downloading and playing from local cache completely avoids byte-range requests.
        File? localFile;
        try {
          final tempDir = await getTemporaryDirectory();
          final cacheDir = Directory('${tempDir.path}/sign_videos');
          if (!await cacheDir.exists()) {
            await cacheDir.create(recursive: true);
          }

          final hash = md5.convert(utf8.encode(playableUrl)).toString();
          final targetFile = File('${cacheDir.path}/$hash.mp4');

          if (await targetFile.exists() && await targetFile.length() > 0) {
            localFile = targetFile;
          } else {
            final tmpFile = File('${cacheDir.path}/$hash.tmp');
            await _cacheDio.download(playableUrl, tmpFile.path, deleteOnError: true);
            if (await tmpFile.exists() && await tmpFile.length() > 0) {
              await tmpFile.rename(targetFile.path);
              localFile = targetFile;
            }
          }
        } catch (downloadErr) {
          debugPrint('SignGlossVideoPlayer: cache download fallback due to: $downloadErr');
        }

        if (localFile != null && await localFile.exists()) {
          controller = VideoPlayerController.file(localFile);
        } else {
          controller = VideoPlayerController.networkUrl(Uri.parse(playableUrl));
        }
      } else {
        controller = VideoPlayerController.networkUrl(Uri.parse(playableUrl));
      }

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

                  // Video Controls Overlay
                  if (!_isInitializing && _initError == null && _showControls && controller != null)
                    AnimatedOpacity(
                      opacity: _showControls ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.4),
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Top Bar (Gloss Title + Speed indicator)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (widget.glossTitle != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black45,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        widget.glossTitle!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  else
                                    const SizedBox.shrink(),

                                  // Playback Speed Button
                                  InkWell(
                                    onTap: _cyclePlaybackSpeed,
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryBlue.withOpacity(0.85),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.speed_rounded, size: 14, color: Colors.white),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${_playbackSpeed}x',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Center Play / Pause Indicator Button
                            IconButton(
                              iconSize: 52,
                              icon: Icon(
                                controller.value.isPlaying
                                    ? Icons.pause_circle_filled_rounded
                                    : Icons.play_circle_filled_rounded,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              onPressed: _togglePlayPause,
                            ),

                            // Bottom Progress Bar
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: VideoProgressIndicator(
                                controller,
                                allowScrubbing: true,
                                colors: const VideoProgressColors(
                                  playedColor: AppColors.primaryBlue,
                                  bufferedColor: Colors.white30,
                                  backgroundColor: Colors.white12,
                                ),
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

          // Bottom Control Footer Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: AppColors.surfaceLight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        (controller != null && controller.value.isPlaying)
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: AppColors.primaryNavy,
                        size: 22,
                      ),
                      onPressed: _togglePlayPause,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      (controller != null && controller.value.isPlaying) ? 'جارٍ التشغيل...' : 'متوقف',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: _cyclePlaybackSpeed,
                  icon: const Icon(Icons.speed_rounded, size: 16),
                  label: Text(
                    'السرعة: ${_playbackSpeed}x',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
