import 'dart:async';

import 'package:music_player/core/repositories/hive_repository.dart';
import 'package:music_player/feature/playlist/data/song.dart';

class PlaylistMiddleware {
  // final StoreRepository _storeRepository;

  // PlaylistMiddleware(this._storeRepository);

  final _playlistController = StreamController<List<Song>>();
  List<Song> _playlist = const [];

  List<Song> get playlist => _playlist;
  Stream<List<Song>> get playlistStream => _playlistController.stream;

  // void initPlaylists() {
  //   _storeRepository.
  // }

  void addPlaylist(Song song) {
    if (_playlist.contains(song)) _playlist.remove(song);
    final updatedList = [song, ..._playlist];
    _playlistController.add(_playlist = updatedList);
  }
}
