import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flavor_client/models/media.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';

final playerStateProvider = ChangeNotifierProvider((_) => PlayerState());

class PlayerState extends ChangeNotifier {
  bool isPlaying = false;
  double currentDuration = 0.0;

  PlaybackMode _playbackMode = PlaybackMode.none;

  bool _busy = false;

  bool isLoading = false;
  PlaybackMode get playbackMode {
    return _playbackMode;
  }

  set playbackMode(PlaybackMode value) {
    _playbackMode = value;
    notifyListeners();
  }

  togglePlaybackMode() {
    switch (_playbackMode) {
      case PlaybackMode.none:
        playbackMode = PlaybackMode.repeatAll;
        break;
      case PlaybackMode.repeatAll:
        playbackMode = PlaybackMode.repeateOne;
        break;
      case PlaybackMode.repeateOne:
        playbackMode = PlaybackMode.none;
        break;
    }
    notifyListeners();
  }

  Track? _currentTrack;
  // Track get currentTrack {
  //   // if (_currentTrack == null) {
  //   //   return null;
  //   // }
  //   return _currentTrack;
  // }

  Track? get currentTrack => _currentTrack;

  set currentTrack(Track? value) {
    if (_busy || value == null) {
      return;
    }
    _busy = true;
    isLoading = true;
    notifyListeners();

    if (value.videoUrl != null) {
      Future.delayed(Duration(milliseconds: 0))
          .then((_) {
            if (videoPlayerController != null) {
              // return videoPlayerController.dispose();
              return videoPlayerController!.pause();
            }
          })
          .then((_) {
            videoPlayerController =
                VideoPlayerController.network(value.videoUrl!);
            return videoPlayerController;
          })
          .then((vc) => vc!.initialize())
          .then((_) {
            isLoading = false;
            _busy = false;
            notifyListeners();
          });
    }

    if (value.audioUrl != null) {
      Future.delayed(Duration(milliseconds: 0))
          .then((_) => _player2.setUrl(value.audioUrl!))
          .then((_) => _player2.play())
          .then((_) {
        isLoading = false;
        _busy = false;
        _currentTrack = value;
        notifyListeners();
      });
    }
    // videoPlayerController = VideoPlayerController.network(
    //     'https://static.videezy.com/system/resources/previews/000/022/130/original/4k-forbidden-sign-with-glitch-effect.mp4');
    // videoPlayerController =
    //     VideoPlayerController.asset('assets/media/smooth.mp3');
  }

  addToNext(Track value) {}
  saveToplaylist(Track value) {}

// Videoplayer V2
  AudioPlayer _player2 = AudioPlayer();
  // AudioPlayer get videoplayer => _player2;
  // set videoplayer(AudioPlayer value) {
  //   // // _videoPlayerController.dispose();
  //   // _player2 = value;
  //   // // _videoPlayerController.addListener(notifyListeners);
  //   // _player2.addListener(playerListener);
  // }
  //
  // StreamSubscription<Duration>? playerListener2(Duration event) {
  //   // var cur = event;
  //   // var tot = _player2.duration;
  //   // var _value = event.inMilliseconds / tot.inMilliseconds;
  //   // currentDuration = _value;
  //   // //
  //   // isPlaying = _player2.playing;
  //   //
  //   currentDuration = event.inMilliseconds.toDouble();
  //   notifyListeners();
  //   return _player2.durationStream;
  // }

  StreamSubscription<Duration>? status;

  playnow(Track track) async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
    // var _track = HlsAudioSource(Uri.parse(track.audioUrl));
    // print('playnow::track.audioUrl - ${track.audioUrl}');
    try {
      // currentTrack = track;

      await _player2.setUrl(
        track.audioUrl!,
        preload: true,
      );
      if (status != null) {
        status!.cancel();
      }
      notifyListeners();

      // status = _player2.createPositionStream().listen(playerListener2);
      //
      // StreamSubscription lis = _player2.createPositionStream().listen((event) {
      //   // print('Event :: inSeconds - ${event.inSeconds}');
      //   // print('Event :: - ${event.toString()}');
      //   // print(
      //   //     'Event :: Percentage Left  - ${event.inSeconds / _player2.duration.inSeconds}');

      // });

      StreamSubscription lis = _player2.createPositionStream().listen((event) {
        // print('Event :: inSeconds - ${event.inSeconds}');
        // print('Event :: - ${event.toString()}');
        // print(
        //     'Event :: Percentage Left  - ${event.inSeconds / _player2.duration.inSeconds}');
      });

      Future.delayed(Duration(seconds: 2)).then((value) => lis.cancel());

      _currentTrack = track;
      notifyListeners();
      //
      // await _player2.setAudioSource(_track);
      _player2.play();
    } catch (e) {
      // catch load errors: 404, invalid url ...
      print("An error occured $e");
    }

    // try {
    //   if (_busy) {
    //     return;
    //   }

    //   // if (_currentTrack?.id == value.id) {
    //   //   Future.delayed(Duration(milliseconds: 6)).then((value) {
    //   //     // if (videoPlayerController?.hashCode != null) {
    //   //     //   // return videoPlayerController.dispose();
    //   //     //   return videoPlayerController.seekTo(Duration(seconds: 0));
    //   //     // }
    //   //   }).then((value) {
    //   //     if (!videoPlayerController.value.isPlaying) {}
    //   //     isLoading = false;
    //   //     _busy = false;
    //   //     notifyListeners();
    //   //     videoPlayerController.play();
    //   //   });
    //   // }
    //   _busy = true;
    //   isLoading = true;
    //   notifyListeners();

    //   Future.delayed(Duration(milliseconds: 6))
    //       .then((_) {
    //         videoPlayerController =
    //             VideoPlayerController.network(value.videoUrl);
    //         return videoPlayerController;
    //       })
    //       .then((vc) => vc.initialize())
    //       .then((value) => Future.delayed(Duration(milliseconds: 6)))
    //       .then((_) {
    //         isLoading = false;
    //         _busy = false;
    //         _currentTrack = value;
    //         notifyListeners();
    //         videoPlayerController.play();
    //       });
    // } on Exception catch (e) {
    //   print("ERROR - ");
    //   print("${e.toString()}");
    // }
  }

  List<Track>? _currentPlaylist;
  List<Track>? get currentPlaylist {
    // if (_currentPlaylist == null) {
    //   return null;
    // }
    return _currentPlaylist;
  }

  set currentPlaylist(List<Track>? value) {
    _currentPlaylist = value;
    notifyListeners();
  }

  VideoPlayerController? _videoPlayerController;
  VideoPlayerController? get videoPlayerController => _videoPlayerController;
  set videoPlayerController(VideoPlayerController? value) {
    if (value == null) return;
    // _videoPlayerController.dispose();
    _videoPlayerController = value;
    // _videoPlayerController.addListener(notifyListeners);
    _videoPlayerController!.addListener(playerListener);
  }

  void playerListener() {
    // print('_videoPlayerController');
    // print(_videoPlayerController.videoPlayerOptions);
    var cur = videoPlayerController!.value.position;
    var tot = videoPlayerController!.value.duration;
    var _value = cur.inMilliseconds / tot.inMilliseconds;
    // print(cur.inMilliseconds / tot.inMilliseconds);
    currentDuration = _value;
    //
    isPlaying = videoPlayerController!.value.isPlaying;
    notifyListeners();
  }

  playPause() {
    // _videoPlayerController.value.isPlaying
    //     ? _videoPlayerController.pause().then((_) {
    //         // notifyListeners();
    //       })
    //     : _videoPlayerController.play();
    //
    //
    _player2.playing
        ? _player2.pause().then((value) => notifyListeners())
        : _player2.play().then((value) => notifyListeners());
  }
}

enum PlaybackMode { none, repeatAll, repeateOne }
