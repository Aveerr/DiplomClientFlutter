import 'package:music_player/core/repositories/music_repository.dart';
import 'package:music_player/feature/playlist/data/songs_response.dart';

const _generalErrorMessage = 'Failed to fetch music. Try again later.';

class MusicService {
  final MusicRepository _musicRepository;

  MusicService(this._musicRepository);

  Future<void> getPlaylists({
    required String name,
    required void Function(SongsResponse) onSuccess,
    required void Function(String) onError,
  }) async {
    final response = await _musicRepository.searchSongs(name: name, parserName: "mp3beast");

    response.fold(
      (l) => onError(_generalErrorMessage),
      (r) {
        if (r == null) {
          onError(_generalErrorMessage);
          return;
        }

        onSuccess(r);
      },
    );
  }
}
