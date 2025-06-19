import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/middlewares/favourites_middleware.dart';
import 'package:music_player/core/repositories/hive_repository.dart';
import 'package:music_player/feature/playlist/data/song.dart';

class FavoritesState {
  final List<Song> favourites;

  const FavoritesState({
    this.favourites = const [],
  });

  FavoritesState copyWith({List<Song>? favourites}) {
    return FavoritesState(
      favourites: favourites ?? this.favourites,
    );
  }
}

abstract class FavoritesEvent {
  const FavoritesEvent();
}

class InitializeFavoritesEvent extends FavoritesEvent {
  const InitializeFavoritesEvent();
}

class SwitchFavouriteEvent extends FavoritesEvent {
  final Song song;

  const SwitchFavouriteEvent(this.song);
}

class UpdateFavouritesEvent extends FavoritesEvent {
  final List<Song> songs;

  const UpdateFavouritesEvent(this.songs);
}

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavouritesMiddleware _favouritesMiddleware;
  final HiveStoreRepository _storeRepository;

  FavoritesBloc(this._favouritesMiddleware, this._storeRepository) : super(const FavoritesState()) {
    on<InitializeFavoritesEvent>(_handleInitiailizeFavoritesEvent);
    on<SwitchFavouriteEvent>(_handleSwitchFavouriteEvent);
    on<UpdateFavouritesEvent>(_handleUpdateFavouritesEvent);

    add(const InitializeFavoritesEvent());

    _favouritesSubs = _favouritesMiddleware.favouritesStream.listen((favourites) {
      add(UpdateFavouritesEvent(favourites));
    });
  }

  late final StreamSubscription _favouritesSubs;

  Future<void> _handleInitiailizeFavoritesEvent(
      InitializeFavoritesEvent event, Emitter<FavoritesState> emit) async {
    final favourites = _favouritesMiddleware.favourites;
    emit(state.copyWith(favourites: favourites));
  }

  Future<void> _handleSwitchFavouriteEvent(
      SwitchFavouriteEvent event, Emitter<FavoritesState> emit) async {
    final isFavourite = _favouritesMiddleware.favourites
        .where((f) => f.songTitle == event.song.songTitle)
        .isNotEmpty;

    if (isFavourite)
        { _favouritesMiddleware.removeFavourite(event.song);}
    else {
        _favouritesMiddleware.addFavourite(event.song);}
  }

  Future<void> _handleUpdateFavouritesEvent(
      UpdateFavouritesEvent event, Emitter<FavoritesState> emit) async {
    print('======== state = ${state.favourites.length}');
    emit(state.copyWith(favourites: event.songs));
  }

  @override
  Future<void> close() {
    _favouritesSubs.cancel();
    return super.close();
  }
}
