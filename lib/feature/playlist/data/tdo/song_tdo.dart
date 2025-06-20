import 'package:hive/hive.dart';
import 'package:music_player/feature/playlist/data/song.dart';

part 'song_tdo.g.dart';

@HiveType(typeId: 0)
class SongTdo {
  SongTdo({
    required this.songTitle,
    required this.downloadUrl,
    required this.musicLogo,
    required this.musicLength,
  });

  @HiveField(0)
  String songTitle;

  @HiveField(1)
  String downloadUrl;

  @HiveField(2)
  String musicLogo;

  @HiveField(3)
  int musicLength;
}

extension ToModelSongsExtension on List<SongTdo>? {
  List<Song> toModel() =>
      this
          ?.map((song) => Song(
                songTitle: song.songTitle,
                downloadUrl: song.downloadUrl,
                musicLogo: song.musicLogo,
                musicLength: song.musicLength,
              ))
          .toList() ??
      [];
}

extension ToModelSongExtension on SongTdo? {
  Song toModel() => Song(
        songTitle: this?.songTitle ?? '',
        downloadUrl: this?.downloadUrl ?? '',
        musicLogo: this?.musicLogo ?? '',
        musicLength: this?.musicLength ?? 0,
      );
}

extension ToTdoModelSongExtension on Song? {
  SongTdo toTdoModel() => SongTdo(
        songTitle: this?.songTitle ?? '',
        downloadUrl: this?.downloadUrl ?? '',
        musicLogo: this?.musicLogo ?? '',
        musicLength: this?.musicLength ?? 0,
      );
}
