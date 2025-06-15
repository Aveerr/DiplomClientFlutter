import 'package:hive/hive.dart';
import 'package:music_player/feature/playlist/data/song.dart';

part 'favorite_tdo.g.dart';

@HiveType(typeId: 2)
class FavoriteTdo {
  FavoriteTdo({
    required this.songTitle,
    required this.downloadUrl,
    required this.musicLogo,
  });

  @HiveField(0)
  String songTitle;

  @HiveField(1)
  String downloadUrl;

  @HiveField(2)
  String musicLogo;
}

extension ToModelFavoritesExtension on List<FavoriteTdo>? {
  List<Song> toModel() =>
      this
          ?.map((song) => Song(
                songTitle: song.songTitle,
                downloadUrl: song.downloadUrl,
                musicLogo: song.musicLogo,
              ))
          .toList() ??
      [];
}

extension ToModelFavoriteExtension on FavoriteTdo? {
  Song toModel() => Song(
        songTitle: this?.songTitle ?? '',
        downloadUrl: this?.downloadUrl ?? '',
        musicLogo: this?.musicLogo ?? '',
      );
}
