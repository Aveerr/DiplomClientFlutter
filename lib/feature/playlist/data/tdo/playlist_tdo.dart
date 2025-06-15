import 'package:hive/hive.dart';
import 'package:music_player/feature/playlist/data/song.dart';

part 'playlist_tdo.g.dart';

@HiveType(typeId: 1)
class PlaylistTdo {
  PlaylistTdo({
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

extension ToModelPlaylistsExtension on List<PlaylistTdo>? {
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

extension ToModelPlaylistExtension on PlaylistTdo? {
  Song toModel() => Song(
        songTitle: this?.songTitle ?? '',
        downloadUrl: this?.downloadUrl ?? '',
        musicLogo: this?.musicLogo ?? '',
      );
}
