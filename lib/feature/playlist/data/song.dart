import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:music_player/feature/playlist/data/tdo/song_tdo.dart';

part 'song.freezed.dart';
part 'song.g.dart';

@freezed
class Song with _$Song {
  factory Song({
    @Default('') @JsonKey(name: 'songTitle') String songTitle,
    @Default('') @JsonKey(name: 'downloadUrl') String downloadUrl,
    @Default(0) @JsonKey(name: 'musicLength') int musicLength,
    @Default('') @JsonKey(name: 'musicLogo') String musicLogo,
  }) = _Song;

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);

  Map<String, dynamic> toJson() => {
        'songTitle': songTitle,
        'downloadUrl': downloadUrl,
        'musicLength': musicLength,
        'musicLogo': musicLogo,
      };
}

extension ToTdoModelPlaylistExtension on Song? {
  SongTdo toModel() => SongTdo(
        songTitle: this?.songTitle ?? '',
        downloadUrl: this?.downloadUrl ?? '',
        musicLogo: this?.musicLogo ?? '',
        musicLength: this?.musicLength ?? 0,
      );
}
