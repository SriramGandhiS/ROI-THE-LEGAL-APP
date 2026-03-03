import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

const String youtubeVideoId = '1b-b3P0E5C4';

class VideoPlayerScreen2hindi extends StatefulWidget {
  const VideoPlayerScreen2hindi({super.key});

  @override
  _VideoPlayerScreen2State createState() => _VideoPlayerScreen2State();
}

class _VideoPlayerScreen2State extends State<VideoPlayerScreen2hindi> {
  late YoutubePlayerController _controller;
  bool _isVideoLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  void _loadVideo() {
    _controller = YoutubePlayerController.fromVideoId(
      videoId: youtubeVideoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
    setState(() {
      _isVideoLoaded = true;
    });
  }

  void _showDescriptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Video Description'),
          content: const Text(
            'No description available.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    if (_isVideoLoaded) {
      _controller.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('क्विज़ समय!'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: _showDescriptionDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg4.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Center(
                  child: !_isVideoLoaded
                      ? ElevatedButton(
                          onPressed: _loadVideo,
                          child: const Text('Play Video'),
                        )
                      : YoutubePlayer(
                          controller: _controller,
                          aspectRatio: 16 / 9,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: null,
    );
  }
}
