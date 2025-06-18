import 'package:freezed_annotation/freezed_annotation.dart';

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
      };
}
