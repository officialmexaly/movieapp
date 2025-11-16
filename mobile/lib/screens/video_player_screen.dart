import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/movie.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Movie movie;
  final String? videoUrl;
  
  const VideoPlayerScreen({
    super.key,
    required this.movie,
    this.videoUrl,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  String _selectedQuality = '720p';
  bool _autoQuality = true;
  String _selectedSubtitle = 'Off';
  String _selectedAudio = 'English';
  bool _showCastButton = false;
  ConnectivityResult _connectionType = ConnectivityResult.none;
  
  // Cast-related variables
  bool _isCasting = false;
  
  final Map<String, String> _qualityOptions = {
    'Auto': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    '1080p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    '720p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    '480p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    '360p': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
  };

  final List<String> _subtitleOptions = [
    'Off',
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Chinese',
    'Japanese',
    'Korean',
    'Arabic',
    'Russian'
  ];

  final List<String> _audioOptions = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Chinese',
    'Japanese',
    'Korean',
    'Arabic',
    'Russian'
  ];

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _monitorConnection();
  }

  void _monitorConnection() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectionType = result;
        // Show cast button when on wifi
        _showCastButton = result == ConnectivityResult.wifi;
      });
      
      if (_autoQuality) {
        _adjustQualityBasedOnConnection(result);
      }
    });
    
    // Initial connection check
    _checkInitialConnection();
  }

  void _checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      _connectionType = result;
      _showCastButton = result == ConnectivityResult.wifi;
    });
  }


  void _adjustQualityBasedOnConnection(ConnectivityResult result) {
    String newQuality;
    switch (result) {
      case ConnectivityResult.wifi:
        newQuality = '1080p';
        break;
      case ConnectivityResult.mobile:
        newQuality = '720p';
        break;
      case ConnectivityResult.ethernet:
        newQuality = '1080p';
        break;
      default:
        newQuality = '480p';
    }
    
    if (newQuality != _selectedQuality) {
      _changeQuality(newQuality);
    }
  }

  String _getQualityUrlBasedOnConnection() {
    switch (_connectionType) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
        return _qualityOptions['1080p']!;
      case ConnectivityResult.mobile:
        return _qualityOptions['720p']!;
      default:
        return _qualityOptions['480p']!;
    }
  }

  Future<void> _initializePlayer() async {
    try {
      // Use provided URL or default demo URL
      String videoUrl;
      if (_autoQuality) {
        videoUrl = widget.videoUrl ?? _getQualityUrlBasedOnConnection();
      } else {
        videoUrl = widget.videoUrl ?? _qualityOptions[_selectedQuality]!;
      }
      
      _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      
      await _videoController!.initialize();
      
      if (mounted) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
          autoPlay: true,
          looping: false,
          showControls: true,
          allowFullScreen: true,
          allowMuting: true,
          showControlsOnInitialize: false,
          materialProgressColors: ChewieProgressColors(
            playedColor: const Color(0xFF6C5CE7),
            handleColor: const Color(0xFF74B9FF),
            bufferedColor: Colors.white.withOpacity(0.3),
            backgroundColor: Colors.white.withOpacity(0.1),
          ),
          placeholder: Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6C5CE7),
              ),
            ),
          ),
          errorBuilder: (context, errorMessage) {
            return Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error playing video',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        );
        
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _changeQuality(String quality) async {
    if (_selectedQuality == quality) return;
    
    final currentPosition = _videoController?.value.position ?? Duration.zero;
    final wasPlaying = _videoController?.value.isPlaying ?? false;
    
    setState(() {
      _isLoading = true;
      _selectedQuality = quality;
    });
    
    await _disposeControllers();
    await _initializePlayer();
    
    // Restore position and play state
    if (_videoController != null) {
      await _videoController!.seekTo(currentPosition);
      if (wasPlaying) {
        await _videoController!.play();
      }
    }
  }

  Future<void> _disposeControllers() async {
    _chewieController?.dispose();
    await _videoController?.dispose();
    _chewieController = null;
    _videoController = null;
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.movie.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Now Playing',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Cast Button
                  if (_showCastButton)
                    IconButton(
                      icon: Icon(
                        _isCasting ? Icons.cast_connected : Icons.cast,
                        color: _isCasting 
                            ? const Color(0xFF6C5CE7)
                            : Colors.white.withOpacity(0.9),
                        size: 24,
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        if (_isCasting) {
                          _disconnectFromCastDevice();
                        } else {
                          _showCastDialog(context);
                        }
                      },
                    ),
                  
                  // Subtitles Button
                  IconButton(
                    icon: Icon(
                      Icons.closed_caption,
                      color: _selectedSubtitle != 'Off' 
                          ? const Color(0xFF6C5CE7) 
                          : Colors.white.withOpacity(0.9),
                      size: 24,
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _showSubtitlesSheet(context);
                    },
                  ),
                  
                  // Audio Button
                  IconButton(
                    icon: Icon(
                      Icons.audiotrack,
                      color: Colors.white.withOpacity(0.9),
                      size: 24,
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _showAudioSheet(context);
                    },
                  ),
                  
                  // Quality Selection Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _showQualitySheet(context);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _autoQuality ? Icons.auto_awesome : Icons.hd,
                              color: Colors.white.withOpacity(0.9),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _autoQuality ? 'Auto' : _selectedQuality,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Video Player
            Expanded(
              child: Container(
                color: Colors.black,
                child: _buildVideoPlayer(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF6C5CE7),
            ),
            SizedBox(height: 16),
            Text(
              'Loading video...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load video',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
                _initializePlayer();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    if (_chewieController != null) {
      return Chewie(controller: _chewieController!);
    }

    return const SizedBox.shrink();
  }

  void _showQualitySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            const Text(
              'Select Quality',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            
            // Auto Quality Toggle
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _autoQuality = !_autoQuality;
                  });
                  if (_autoQuality) {
                    _adjustQualityBasedOnConnection(_connectionType);
                  }
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: _autoQuality 
                        ? const Color(0xFF6C5CE7).withOpacity(0.2)
                        : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _autoQuality 
                          ? const Color(0xFF6C5CE7)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: _autoQuality 
                            ? const Color(0xFF6C5CE7)
                            : Colors.white.withOpacity(0.8),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Auto Quality',
                              style: TextStyle(
                                color: _autoQuality 
                                    ? const Color(0xFF6C5CE7)
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: _autoQuality ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Adjusts based on connection',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_autoQuality)
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF6C5CE7),
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            
            if (!_autoQuality) ...[
              const SizedBox(height: 8),
              const Text(
                'Manual Quality',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            // Quality options
            if (!_autoQuality)
            Column(
              children: _qualityOptions.keys.where((key) => key != 'Auto').map((quality) {
                final isSelected = _selectedQuality == quality;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                      _changeQuality(quality);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? const Color(0xFF6C5CE7).withOpacity(0.2)
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected 
                              ? const Color(0xFF6C5CE7)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.hd,
                            color: isSelected 
                                ? const Color(0xFF6C5CE7)
                                : Colors.white.withOpacity(0.8),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  quality,
                                  style: TextStyle(
                                    color: isSelected 
                                        ? const Color(0xFF6C5CE7)
                                        : Colors.white,
                                    fontSize: 16,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  _getQualityDescription(quality),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF6C5CE7),
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  String _getQualityDescription(String quality) {
    switch (quality) {
      case '1080p':
        return 'Full HD • Best quality';
      case '720p':
        return 'HD • Good quality';
      case '480p':
        return 'SD • Data saver';
      case '360p':
        return 'Low • Minimal data';
      default:
        return '';
    }
  }

  void _showSubtitlesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            const Text(
              'Subtitles',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            
            // Subtitle options
            Column(
              children: _subtitleOptions.map((subtitle) {
                final isSelected = _selectedSubtitle == subtitle;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _selectedSubtitle = subtitle;
                      });
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? const Color(0xFF6C5CE7).withOpacity(0.2)
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected 
                              ? const Color(0xFF6C5CE7)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            subtitle == 'Off' ? Icons.closed_caption_disabled : Icons.closed_caption,
                            color: isSelected 
                                ? const Color(0xFF6C5CE7)
                                : Colors.white.withOpacity(0.8),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              subtitle,
                              style: TextStyle(
                                color: isSelected 
                                    ? const Color(0xFF6C5CE7)
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF6C5CE7),
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showAudioSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            const Text(
              'Audio Track',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            
            // Audio options
            Column(
              children: _audioOptions.map((audio) {
                final isSelected = _selectedAudio == audio;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _selectedAudio = audio;
                      });
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? const Color(0xFF6C5CE7).withOpacity(0.2)
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected 
                              ? const Color(0xFF6C5CE7)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.audiotrack,
                            color: isSelected 
                                ? const Color(0xFF6C5CE7)
                                : Colors.white.withOpacity(0.8),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              audio,
                              style: TextStyle(
                                color: isSelected 
                                    ? const Color(0xFF6C5CE7)
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF6C5CE7),
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showCastDialog(BuildContext context) {
    final videoUrl = widget.videoUrl ?? _qualityOptions[_selectedQuality]!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Cast to TV',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cast_connected,
                    color: const Color(0xFF6C5CE7),
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose how to cast this video to your TV',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Direct cast button
            _buildCastOption(
              'Cast with System',
              'Use your device\'s built-in casting',
              Icons.cast,
              () => _castWithSystem(videoUrl),
            ),
            
            // Share button
            _buildCastOption(
              'Share Video',
              'Share to casting apps like YouTube, VLC, etc.',
              Icons.share,
              () => _shareVideo(videoUrl),
            ),
            
            // Open in browser
            _buildCastOption(
              'Open in Browser',
              'Open video in browser for easy casting',
              Icons.web,
              () => _openInBrowser(videoUrl),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCastDevice(String name, String description, IconData icon) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
          _castToDevice(name, description);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF6C5CE7),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCastOption(String title, String description, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF6C5CE7),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.4),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _castWithSystem(String videoUrl) async {
    try {
      // Use system share sheet which includes casting options
      await Share.shareUri(
        Uri.parse(videoUrl),
        sharePositionOrigin: const Rect.fromLTWH(0, 0, 100, 100),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Choose a casting app from the share menu',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF6C5CE7),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to open share menu',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _shareVideo(String videoUrl) async {
    try {
      await Share.share(
        '🎬 Watch "${widget.movie.title}"\n\n$videoUrl',
        subject: 'Watch ${widget.movie.title}',
      );
    } catch (e) {
      print('Failed to share video: $e');
    }
  }

  void _openInBrowser(String videoUrl) async {
    try {
      final uri = Uri.parse(videoUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Video opened in browser. Use browser\'s cast button to cast to TV.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xFF6C5CE7),
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to open video in browser',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _disconnectFromCastDevice() async {
    setState(() {
      _isCasting = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Casting stopped',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _castToDevice(String deviceName, String deviceType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Casting to $deviceName via $deviceType',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF6C5CE7),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}