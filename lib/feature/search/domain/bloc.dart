import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/middlewares/favourites_middleware.dart';
import 'package:music_player/core/services/music_service.dart';
import 'package:music_player/feature/playlist/data/song.dart';

class SearchState {
  final List<Song> songs;
  final String? errorMessage;
  final bool isLoading;
  // final List<Song> favourites;

  const SearchState({
    this.songs = const [],
    // this.favourites = const [],
    this.errorMessage,
    this.isLoading = false,
  });

  SearchState copyWith({
    List<Song>? songs,
    // List<Song>? favourites,
    String? errorMessage,
    bool? isLoading,
  }) {
    return SearchState(
      songs: songs ?? this.songs,
      // favourites: favourites ?? this.favourites,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
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
  final String song;

  const SearchPlaylistEvent(this.song);
}

// class SwitchFavouriteEvent extends SearchEvent {
//   final Song song;
//
//   const SwitchFavouriteEvent(this.song);
// }
//
// class UpdateFavouritesEvent extends SearchEvent {
//   final List<Song> songs;
//
//   const UpdateFavouritesEvent(this.songs);
// }

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MusicService _musicService;
  final FavouritesMiddleware _favouritesMiddleware;

  SearchBloc(this._musicService, this._favouritesMiddleware) : super(const SearchState()) {
    on<InitializeSearchEvent>(_handleInitiailizeFavoritesEvent);
    on<SearchPlaylistEvent>(_handleSearchEvent);
    // on<SwitchFavouriteEvent>(_handleSwitchFavouriteEvent);
    // on<UpdateFavouritesEvent>(_handleUpdateFavouritesEvent);

    add(const InitializeSearchEvent());

    // _favouriteSubs = _favouritesMiddleware.favouritesStream.listen((favourites) {
    //   add(UpdateFavouritesEvent(favourites));
    // });
  }

  // late final StreamSubscription _favouriteSubs;

  Future<void> _handleInitiailizeFavoritesEvent(
      InitializeSearchEvent event, Emitter<SearchState> emit) async {
    // await _musicService.getPlaylists(
    //   name: 'metalica',
    //   onSuccess: (response) => emit(state.copyWith(songs: response.results)),
    //   onError: (error) => emit(state.copyWith(errorMessage: error)),
    // );
  }

  Future<void> _handleSearchEvent(SearchPlaylistEvent event, Emitter<SearchState> emit) async {
    print('======== event.song = ${event.song}');
    emit(state.copyWith(isLoading: true));
    await _musicService.getPlaylists(
      name: event.song,
      onSuccess: (response) => emit(state.copyWith(songs: response.results)),
      onError: (error) => emit(state.copyWith(errorMessage: error)),
    );
    emit(state.copyWith(isLoading: false));
  }

  // Future<void> _handleSwitchFavouriteEvent(SwitchFavouriteEvent event, Emitter<SearchState> emit) async {
  //   final isFavourite = _favouritesMiddleware.favourites.where((f) => f.songTitle == event.song.songTitle).isNotEmpty;
  //   isFavourite ?
  //     _favouritesMiddleware.removeFavourite(event.song)
  //     : _favouritesMiddleware.addFavourite(event.song);
  // }
  //
  // Future<void> _handleUpdateFavouritesEvent(UpdateFavouritesEvent event, Emitter<SearchState> emit) async {
  //   print('======== state = ${state.favourites.length}');
  //   emit(state.copyWith(favourites: event.songs));
  // }

  // @override
  // Future<void> close() {
  //   _favouriteSubs.cancel();
  //   return super.close();
  // }
}
