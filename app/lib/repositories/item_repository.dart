import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dlxstudios_app/providers/providers.dart';
import 'package:dlxstudios_app/repositories/custom_exception.dart';
import 'package:flavor_auth/flavor_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dlxstudios_app/extensions/firebase_firestore_extension.dart';

abstract class BaseItemRepository {
  Future<List> retrieveItems({required String userId});
  Future<String> createItem({required String userId, required FlavorUser item});
  Future<void> updateItem({required String userId, required FlavorUser item});
  Future<void> deleteItem({required String userId, required String itemId});
}

final itemRepositoryProvider =
    Provider<ItemRepository>((ref) => ItemRepository(ref.read));

class ItemRepository implements BaseItemRepository {
  final Reader _read;

  const ItemRepository(this._read);

  @override
  Future<List> retrieveItems({required String userId}) async {
    try {
      final snap =
          await _read(firebaseFirestoreProvider).usersListRef(userId).get();
      return snap.docs.map((doc) => doc).toList();
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<String> createItem({
    required String userId,
    required FlavorUser item,
  }) async {
    try {
      final docRef = await _read(firebaseFirestoreProvider)
          .usersListRef(userId)
          .add(item.toJson());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> updateItem(
      {required String userId, required FlavorUser item}) async {
    try {
      await _read(firebaseFirestoreProvider)
          .usersListRef(userId)
          .doc(item.localId)
          .update(item.toMap());
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> deleteItem({
    required String userId,
    required String itemId,
  }) async {
    try {
      await _read(firebaseFirestoreProvider)
          .usersListRef(userId)
          .doc(itemId)
          .delete();
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}
