import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/services/music_service.dart';
import 'package:music_player/feature/playlist/data/song.dart';

class SearchState {
  final List<Song> songs;
  final String? errorMessage;

  const SearchState({
    this.songs = const [],
    this.errorMessage,
  });

  SearchState copyWith({List<Song>? songs, String? errorMessage}) {
    return SearchState(
      songs: songs ?? this.songs,
      errorMessage: errorMessage,
    );
  }
}

abstract class SearchEvent {
  const SearchEvent();
}

class InitializeSearchEvent extends SearchEvent {
  const InitializeSearchEvent();
}

class SearchPlaylistEvent extends SearchEvent {
  final String name;

  const SearchPlaylistEvent(this.name);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MusicService _musicService;

  SearchBloc(this._musicService) : super(const SearchState()) {
    on<InitializeSearchEvent>(_handleInitiailizeFavoritesEvent);
    on<SearchPlaylistEvent>(_handleSearchEvent);

    add(const InitializeSearchEvent());
  }

  Future<void> _handleInitiailizeFavoritesEvent(
      InitializeSearchEvent event, Emitter<SearchState> emit) async {
    await _musicService.getPlaylists(
      name: 'metalica',
      onSuccess: (response) => emit(state.copyWith(songs: response.results)),
      onError: (error) => emit(state.copyWith(errorMessage: error)),
    );
  }

  Future<void> _handleSearchEvent(SearchPlaylistEvent event, Emitter<SearchState> emit) async {
    await _musicService.getPlaylists(
      name: event.name,
      onSuccess: (response) => emit(state.copyWith(songs: response.results)),
      onError: (error) => emit(state.copyWith(errorMessage: error)),
    );
  }
}
