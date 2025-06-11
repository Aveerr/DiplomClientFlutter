import 'package:hive/hive.dart';
import 'package:music_player/feature/playlist/data/tdo/favorite_tdo.dart';
import 'package:music_player/feature/playlist/data/tdo/playlist_tdo.dart';
import 'package:music_player/feature/playlist/data/tdo/song_tdo.dart';

abstract class HiveBox {
  static const favoritesBox = 'favorites_box';
  static const playlistBox = 'playlist_box';

  static List<String> get boxes => [
        favoritesBox,
        playlistBox,
      ];

  static Future<void> openAll() async => [for (final box in boxes) await Hive.openBox(box)];

  static Future<void> registerAdapters() async {
    Hive.registerAdapter(SongTdoAdapter(), override: true);
    Hive.registerAdapter(PlaylistTdoAdapter(), override: true);
    Hive.registerAdapter(FavoriteTdoAdapter(), override: true);
  }
}
