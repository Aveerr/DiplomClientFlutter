import 'package:hive/hive.dart';
import 'package:music_player/core/utils/hive_box.dart';
import 'package:music_player/feature/playlist/data/song.dart';
import 'package:music_player/feature/playlist/data/tdo/song_tdo.dart';

Box get favoritesBox => Hive.box(HiveBox.favoritesBox);
Box get playlistBox => Hive.box(HiveBox.playlistBox);

// abstract class StoreRepository<T> {
//   Future<T?> get(dynamic id);
//   List<T> getAll();
//   Future<void> put(String id, T object);
// }

class HiveStoreRepository {
  HiveStoreRepository({required this.box});

  final Box box;

  Future<String?> get(String id, {String? defaultValue}) async => box.get(id) ?? defaultValue;

  // @override
  // Future<void> put(String id, String object) async {
  //   await box.put(id, object);
  // }

  List<Song> getAll() {
    try {
      if (box.values.isEmpty) return [];

      print('======= a = ${box.values.last}');
      return box.values.map((v) {
        print('========== b = ${(v as SongTdo).songTitle}');
        return (v as SongTdo).toModel();
      }).toList();
    } catch (e) {
      print('========== e = $e');
      return [];
    }
  }

  Future<void> put(String id, Song song) async {
    if (box.keys.contains(id)) return;

    await box.put(id, song.toTdoModel());
  }
}
