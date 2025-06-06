import 'package:freezed_annotation/freezed_annotation.dart';

part 'song.freezed.dart';
part 'song.g.dart';

@freezed
class Song with _$Song {
  factory Song({
    @Default('') @JsonKey(name: 'songTitle') String songTitle,
    @Default('') @JsonKey(name: 'downloadUrl') String downloadUrl,
  }) = _Song;

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);
}
