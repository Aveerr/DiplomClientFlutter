import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/middlewares/playlist_middleware.dart';
import 'package:music_player/core/repositories/hive_repository.dart';
import 'package:music_player/core/services/music_service.dart';
import 'package:music_player/feature/playlist/data/song.dart';

class PlaylistState {
  final List<Song> songs;

  const PlaylistState({
    this.songs = const [],
  });

  PlaylistState copyWith({List<Song>? songs, String? errorMessage}) {
    return PlaylistState(
      songs: songs ?? this.songs,
    );
  }
}

abstract class PlaylistEvent {
  const PlaylistEvent();
}

class InitializePlaylistEvent extends PlaylistEvent {
  const InitializePlaylistEvent();
}

class UpdatePlaylistEvent extends PlaylistEvent {
  final List<Song> songs;

  const UpdatePlaylistEvent(this.songs);
}

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final MusicService _musicService;
  final PlaylistMiddleware _playlistMiddleware;
  final HiveStoreRepository _store;

  PlaylistBloc(this._musicService, this._playlistMiddleware, this._store)
      : super(const PlaylistState()) {
    on<InitializePlaylistEvent>(_handleInitiailizeFavoritesEvent);
    on<UpdatePlaylistEvent>(_handleUpdatePlaylistEvent);
    // on<SearchEvent>(_handleSearchEvent);

    add(const InitializePlaylistEvent());

    _subs = _playlistMiddleware.playlistStream.listen((playlists) {
      add(UpdatePlaylistEvent(playlists));
    });
  }

  late StreamSubscription _subs;

  Future<void> _handleInitiailizeFavoritesEvent(
      InitializePlaylistEvent event, Emitter<PlaylistState> emit) async {
    final savedSongs = await _store.getAll();
    print('========= savedSongs = ${savedSongs.length} ${savedSongs.first}');
    final songs = savedSongs.where((s) => s.songTitle.isNotEmpty).toList();
    for (var s in songs) {
      _playlistMiddleware.addPlaylist(s);
    }

    emit(state.copyWith(songs: songs));

    // await _musicService.getPlaylists(
    //   name: 'metalica',
    //   onSuccess: (response) => emit(state.copyWith(songs: response.results)),
    //   onError: (error) => emit(state.copyWith(errorMessage: error)),
    // );
  }

  Future<void> _handleUpdatePlaylistEvent(
      UpdatePlaylistEvent event, Emitter<PlaylistState> emit) async {
    emit(state.copyWith(songs: event.songs));
  }

  // Future<void> _handleSearchEvent(SearchEvent event, Emitter<PlaylistState> emit) async {
  //   await _musicService.getPlaylists(
  //     name: event.name,
  //     onSuccess: (response) => emit(state.copyWith(songs: response.results)),
  //     onError: (error) => emit(state.copyWith(errorMessage: error)),
  //   );
  // }
}
