import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

hiveProviderInit(String path) async => FutureProvider.autoDispose(
      (ref) => Hive.initFlutter().then(
        (value) => Hive.openBox(path),
      ),
    );

final hiveProvider = hiveProviderInit('dlxstudios.app');

final miniPlayerControllerProvider =
    StateProvider.autoDispose<MiniplayerController>(
  (ref) => MiniplayerController(),
);

final hiveFutureProvider = FutureProvider<Box>((ref) {
  return Hive.initFlutter().then(
    (value) => Hive.openBox('dlxstudios.app'),
  );
});
