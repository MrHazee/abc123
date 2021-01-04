import 'dart:async';

import 'package:video_player/video_player.dart';

class VideoEvent {
  final Event event;
  const VideoEvent(this.event);
}

enum Event {
  Play,
  Pause,
}

class CustomVideoPlayer {
  get controller => _controller;

  bool _isPlaying;

  Stream<VideoEvent> get eventStream => _callback.stream;
  final _callback = StreamController<VideoEvent>.broadcast();

  CustomVideoPlayer(String name) {
    _controller = VideoPlayerController.asset('assets/video/sv/$name.mov');
    _controller.addListener(() {
      final bool isPlaying = _controller.value.isPlaying;
      if (isPlaying != _isPlaying) {
        //s setState(() {
        _isPlaying = isPlaying;
        //});
      }
      print(
          "Video pos: ${_controller.value.position} / ${_controller.value.duration}");
      if (_controller.value.position >= _controller.value.duration) {
        //_controller.pause();
        _callback.add(VideoEvent(Event.Pause));
      }
    });
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  //int _playBackTime;

  //The values that are passed when changing quality
  Duration newCurrentPosition;

  /*VideoPlayer() {
    _controller = VideoPlayerController.network(defaultStream);
    _controller.addListener(() {});
    _initializeVideoPlayerFuture = _controller.initialize();
  }*/

  void dispose() {
    _initializeVideoPlayerFuture = null;
    _controller?.pause()?.then((_) {
      _controller.dispose();
    });
  }

  Future<bool> _clearPrevious() async {
    await _controller?.pause();
    await _controller.dispose();
    return true;
  }

  Future<void> _initializePlay(String name) async {
    _controller = VideoPlayerController.asset('assets/video/sv/$name.mov');
    _controller.addListener(() {
      final bool isPlaying = _controller.value.isPlaying;
      if (isPlaying != _isPlaying) {
        //s setState(() {
        _isPlaying = isPlaying;
        //});
      }
      print(
          "Video pos: ${_controller.value.position} / ${_controller.value.duration}");
      if (_controller.value.position >= _controller.value.duration) {
        //_controller.pause();
        _callback.add(VideoEvent(Event.Pause));
      }
    });
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // _controller.seekTo(Duration.zero);
      //_controller.play();
    });
  }

  void getValuesAndPlay(String name) {
    //newCurrentPosition = _controller.value.position;
    _startPlay(name);
    print(newCurrentPosition.toString());
  }

  Future<void> _startPlay(String name) async {
    _initializeVideoPlayerFuture = null;

    // Future.delayed(const Duration(milliseconds: 0), () {
    _clearPrevious().then((_) {
      _initializePlay(name);
    });
    //});
  }
}
