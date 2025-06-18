import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/middlewares/favourites_middleware.dart';
import 'package:music_player/core/middlewares/playlist_middleware.dart';
import 'package:music_player/core/repositories/hive_repository.dart';
import 'package:music_player/core/repositories/music_repository.dart';
import 'package:music_player/core/services/music_service.dart';
import 'package:music_player/core/utils/hive_box.dart';
import 'package:music_player/feature/favorites/domain/bloc.dart';
import 'package:music_player/feature/player/domain/bloc.dart';
import 'package:music_player/feature/playlist/data/tdo/favorite_tdo.dart';
import 'package:music_player/feature/playlist/data/tdo/playlist_tdo.dart';
import 'package:music_player/feature/playlist/domain/bloc.dart';
import 'package:music_player/feature/search/domain/bloc.dart';
import 'package:path_provider/path_provider.dart';

final GetIt _getIt = GetIt.instance;

const _favoriteKey = 'favorite';
const _playlistKey = 'playlist';

T instanceOf<T extends Object>({
  String? instanceName,
  dynamic param1,
  dynamic param2,
}) =>
    GetIt.instance.get<T>();

Future<void> registerAppDependencies() async {
  await Future.wait([
    _initHive(),
    _initRepositories(),
    _initServices(),
    _registerBlocs(),
  ]);
}

Future<void> _initHive() async {
  Directory directory = await getApplicationDocumentsDirectory();

  Hive.init(directory.path);

  await HiveBox.registerAdapters();
  await HiveBox.openAll();
}

Future<void> _initRepositories() async {
  _getIt
    ..registerLazySingleton(() => Client())
    ..registerFactory(() => MusicRepository(_getIt.get()))
    ..registerFactory<StoreRepository>(
      () => HiveStoreRepository<FavoriteTdo>(box: favoritesBox),
      instanceName: _favoriteKey,
    )
    ..registerFactory<StoreRepository>(
      () => HiveStoreRepository<PlaylistTdo>(box: playlistBox),
      instanceName: _playlistKey,
    );
}

Future<void> _initServices() async {
  _getIt
    ..registerFactory(() => MusicService(_getIt.get()))
    ..registerLazySingleton(() => AudioPlayer())
    ..registerLazySingleton(() => FavouritesMiddleware())
    ..registerLazySingleton(() => PlaylistMiddleware());
}

Future<void> _registerBlocs() async {
  _getIt
    ..registerLazySingleton(() => PlaylistBloc(
        _getIt.get(),
        _getIt.get(),
        _getIt.get(
          instanceName: _playlistKey,
        )))
    ..registerLazySingleton(() => SearchBloc(_getIt.get(), _getIt.get()))
    ..registerLazySingleton(() => FavoritesBloc(_getIt.get()))
    ..registerLazySingleton(() => PlayerBloc(
          _getIt.get(),
          _getIt.get(),
          // _getIt.get(instanceName: _playlistKey),
        ));
}
