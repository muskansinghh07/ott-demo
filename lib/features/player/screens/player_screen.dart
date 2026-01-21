import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import '../../../blocs/player/player_bloc.dart';
import '../../../core/constants/video_constants.dart';

class PlayerScreen extends StatefulWidget {
  final String contentId;
  final String title;

  const PlayerScreen({
    super.key,
    required this.contentId,
    required this.title,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late html.VideoElement _videoElement;
  final String _viewId = 'video-player-${DateTime.now().millisecondsSinceEpoch}';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    context.read<PlayerBloc>().add(
          InitializePlayerEvent(widget.contentId, widget.title),
        );
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    // Create video element
    _videoElement = html.VideoElement()
      ..src = VideoConstants.sampleHlsUrl // Using HLS sample URL for web
      ..controls = true
      ..autoplay = true
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'contain'
      ..style.backgroundColor = 'black';

    // Register view factory
    ui_web.platformViewRegistry.registerViewFactory(
      _viewId,
      (int viewId) => _videoElement,
    );

    setState(() {
      _isInitialized = true;
    });

    // Listen to video events
    _videoElement.onPlay.listen((_) {
      print('Video playing');
    });

    _videoElement.onTimeUpdate.listen((_) {
      if (_videoElement.currentTime != null && 
          _videoElement.currentTime! > 0 && 
          _videoElement.currentTime!.toInt() % 5 == 0) {
        context.read<PlayerBloc>().add(
              UpdatePlaybackPositionEvent(
                widget.contentId,
                Duration(seconds: _videoElement.currentTime!.toInt()),
              ),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: () {
              _videoElement.requestFullscreen();
            },
          ),
        ],
      ),
      body: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          if (state is PlayerReady) {
            return Column(
              children: [
                // Video Player
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: _isInitialized
                        ? HtmlElementView(viewType: _viewId)
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ),
                // Video Info
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.black87,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.hd, size: 16, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            'Streaming: ${VideoConstants.hlsProtocol}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          if (state.resumePosition != null) ...[
                            const Icon(Icons.history, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              'Resumed from ${_formatDuration(state.resumePosition!)}',
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tip: Click fullscreen icon for better experience',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    final currentTime = _videoElement.currentTime ?? 0;
    final duration = _videoElement.duration ?? 0;
    
    context.read<PlayerBloc>().add(
          DisposePlayerEvent(
            widget.contentId,
            Duration(seconds: currentTime.toInt()),
            Duration(seconds: duration.toInt()),
          ),
        );
    
    _videoElement.pause();
    _videoElement.remove();
    
    super.dispose();
  }
}