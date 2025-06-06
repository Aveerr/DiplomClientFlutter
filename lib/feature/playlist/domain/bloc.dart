import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/services/music_service.dart';
import 'package:music_player/feature/playlist/data/song.dart';

class PlaylistState {
  final List<Song> songs;
  final String? errorMessage;

  const PlaylistState({
    this.songs = const [],
    this.errorMessage,
  });

  PlaylistState copyWith({List<Song>? songs, String? errorMessage}) {
    return PlaylistState(
      songs: songs ?? this.songs,
      errorMessage: errorMessage,
    );
  }
}

abstract class PlaylistEvent {
  const PlaylistEvent();
}

class InitializePlaylistEvent extends PlaylistEvent {
  const InitializePlaylistEvent();
}

class SearchEvent extends PlaylistEvent {
  final String name;

  const SearchEvent(this.name);
}

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final MusicService _musicService;

  PlaylistBloc(this._musicService) : super(const PlaylistState()) {
    on<InitializePlaylistEvent>(_handleInitiailizeFavoritesEvent);
    on<SearchEvent>(_handleSearchEvent);

    add(const InitializePlaylistEvent());
  }

  Future<void> _handleInitiailizeFavoritesEvent(
      InitializePlaylistEvent event, Emitter<PlaylistState> emit) async {
    await _musicService.getPlaylists(
      name: 'metalica',
      onSuccess: (response) => emit(state.copyWith(songs: response.results)),
      onError: (error) => emit(state.copyWith(errorMessage: error)),
    );
  }

  Future<void> _handleSearchEvent(SearchEvent event, Emitter<PlaylistState> emit) async {
    await _musicService.getPlaylists(
      name: event.name,
      onSuccess: (response) => emit(state.copyWith(songs: response.results)),
      onError: (error) => emit(state.copyWith(errorMessage: error)),
    );
  }
}
