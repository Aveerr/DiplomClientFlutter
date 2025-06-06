import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:music_player/feature/playlist/data/song.dart';

part 'songs_response.freezed.dart';
part 'songs_response.g.dart';

@freezed
class SongsResponse with _$SongsResponse {
  factory SongsResponse({
    @Default('') @JsonKey(name: 'message') String message,
    @Default([]) @JsonKey(name: 'results') List<Song> results,
  }) = _SongsResponse;

  factory SongsResponse.fromJson(Map<String, dynamic> json) => _$SongsResponseFromJson(json);
}
