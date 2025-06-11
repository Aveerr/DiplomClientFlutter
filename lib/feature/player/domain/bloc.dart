import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/middlewares/playlist_middleware.dart';
import 'package:music_player/core/repositories/hive_repository.dart';
import 'package:music_player/feature/playlist/data/song.dart';

class PlayerState {
  final Song? playingSong;
  final bool isPlaying;

  const PlayerState({
    this.playingSong,
    this.isPlaying = false,
  });

  PlayerState copyWith({Song? playingSong, bool? isPlaying}) {
    return PlayerState(
      playingSong: playingSong,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

abstract class PlayerEvent {
  const PlayerEvent();
}

class InitializePlayerEvent extends PlayerEvent {
  const InitializePlayerEvent();
}

class PlayEvent extends PlayerEvent {
  final Song song;

  const PlayEvent(this.song);
}

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final AudioPlayer _player;
  final PlaylistMiddleware _playlistMiddleware;
  // final StoreRepository _storeRepository;

  PlayerBloc(
    this._player,
    this._playlistMiddleware,
    // this._storeRepository,
  ) : super(const PlayerState()) {
    on<InitializePlayerEvent>(_handleInitiailizeFavoritesEvent);
    on<PlayEvent>(_handlePlayEvent);

    add(const InitializePlayerEvent());
  }

  late StreamSubscription<PlayerException> _subs;
  Song? _lastSong;

  Future<void> _handleInitiailizeFavoritesEvent(
      InitializePlayerEvent event, Emitter<PlayerState> emit) async {
    _subs = _player.errorStream.listen((e) {
      print('A stream error occurred: $e');
    });
  }

  Future<void> _handlePlayEvent(PlayEvent event, Emitter<PlayerState> emit) async {
    print('======= a = ${_lastSong?.songTitle} b = ${event.song.songTitle}');
    if (_lastSong?.songTitle != event.song.songTitle) {
      print('========= 1');
      _playlistMiddleware.addPlaylist(event.song);
      // await _player.clearAudioSources();
      _lastSong = event.song;
      emit(state.copyWith(playingSong: event.song, isPlaying: true));

      await _player.setUrl(event.song.downloadUrl);
      await _player.play();
    } else {
      if (state.isPlaying) {
        print('========= 2');
        emit(state.copyWith(playingSong: event.song, isPlaying: false));
        await _player.stop();
      } else {
        print('========= 3 ${event.song.songTitle}');
        emit(state.copyWith(playingSong: event.song, isPlaying: true));
        await _player.play();
      }
    }
  }

  @override
  Future<void> close() {
    _subs.cancel();
    return super.close();
  }
}
