import 'package:hive/hive.dart';
import 'package:music_player/feature/playlist/data/song.dart';

part 'song_tdo.g.dart';

@HiveType(typeId: 0)
class SongTdo {
  SongTdo({
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

extension ToModelSongsExtension on List<SongTdo>? {
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

extension ToModelSongExtension on SongTdo? {
  Song toModel() => Song(
        songTitle: this?.songTitle ?? '',
        downloadUrl: this?.downloadUrl ?? '',
        musicLogo: this?.musicLogo ?? '',
      );
}
