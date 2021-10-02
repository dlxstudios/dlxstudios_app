import 'dart:async';

import 'package:dlxstudios_app/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

final PlayerControllerProvider = StateNotifierProvider<PlayerController, User?>(
  (ref) => PlayerController(ref.read),
);

class PlayerController extends StateNotifier<User?> {
  final Reader _read;

  StreamSubscription<VideoPlayerController?>? _stateChangesSubscription;

  late VideoPlayerController vc;

  PlayerController(this._read) : super(null) {
    _stateChangesSubscription?.cancel();
  }

  @override
  void dispose() {
    _stateChangesSubscription?.cancel();
    super.dispose();
  }

  void newVideo(String network) async {
    vc = VideoPlayerController.network(network);
  }

  void signOut() async {
    await _read(authRepositoryProvider).signOut();
  }
}
