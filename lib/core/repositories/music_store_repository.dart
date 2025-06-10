import 'package:hive/hive.dart';
import 'package:music_player/core/utils/hive_box.dart';
import 'package:music_player/feature/playlist/data/song.dart';

// Box get favoritesBox => Hive.box(HiveBox.favoritesBox);
// Box get playlistBox => Hive.box(HiveBox.playlistBox);

class MusicStoreRepository {
  // Future<Song?> get(dynamic title, {String? defaultValue, required Box box}) async {
  //   if (box.keys.contains(title)) return null;
  //
  //   return this.favoritesBox.get(title, defaultValue: defaultValue);
  // }

  Future<void> put(String title, dynamic object, Box box) async {
    await box.put(title, object);
  }
}
