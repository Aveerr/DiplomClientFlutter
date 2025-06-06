import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/repositories/music_repository.dart';
import 'package:music_player/core/services/music_service.dart';
import 'package:music_player/feature/favorites/domain/bloc.dart';
import 'package:music_player/feature/player/bloc.dart';
import 'package:music_player/feature/playlist/domain/bloc.dart';
import 'package:music_player/feature/search/domain/bloc.dart';

final GetIt _getIt = GetIt.instance;

T instanceOf<T extends Object>({
  String? instanceName,
  dynamic param1,
  dynamic param2,
}) =>
    GetIt.instance.get<T>();

Future<void> registerAppDependencies() async {
  await Future.wait([
    _initRepositories(),
    _initServices(),
    _registerBlocs(),
  ]);
  print('========= registerAppDependencies end');
}

Future<void> _initRepositories() async {
  _getIt
    ..registerLazySingleton(() => Client())
    ..registerFactory(() => MusicRepository(_getIt.get()));
}

Future<void> _initServices() async {
  _getIt
    ..registerFactory(() => MusicService(_getIt.get()))
    ..registerLazySingleton(() => AudioPlayer());
}

Future<void> _registerBlocs() async {
  _getIt
    ..registerFactory(() => PlaylistBloc(_getIt.get()))
    ..registerFactory(() => SearchBloc(_getIt.get()))
    ..registerFactory(() => FavoritesBloc())
    ..registerLazySingleton(() => PlayerBloc(_getIt.get()));
}
