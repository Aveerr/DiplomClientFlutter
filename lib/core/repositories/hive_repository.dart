import 'package:hive/hive.dart';
import 'package:music_player/core/utils/hive_box.dart';
import 'package:music_player/feature/playlist/data/song.dart';

Box get favoritesBox => Hive.box(HiveBox.favoritesBox);
Box get playlistBox => Hive.box(HiveBox.playlistBox);

abstract class StoreRepository<T> {
  Future<T?> get(dynamic id);
  Future<List<T>> getAll();
  Future<void> put(String id, T object);
}

class HiveStoreRepository<String> extends StoreRepository<String> {
  HiveStoreRepository({required this.box});

  final Box box;

  @override
  Future<String?> get(dynamic id, {Song? defaultValue}) async {}

  // @override
  // Future<void> put(String id, String object) async {
  //   await box.put(id, object);
  // }

  @override
  Future<List<String>> getAll() async {
    return Future.value(box.values.map((v) => v.toString()).toList());
  }

  @override
  Future<void> put(String id, String object) async {
    if (box.keys.contains(id)) return null;

    return this.box.get(id, defaultValue: defaultValue);
  }
}
