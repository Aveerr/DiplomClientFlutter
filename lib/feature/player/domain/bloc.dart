import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/middlewares/playlist_middleware.dart';
import 'package:music_player/core/repositories/hive_repository.dart';
import 'package:music_player/feature/playlist/data/song.dart';

class PlayerState {
  final Song? playingSong;
  final bool isPlaying;
  final Duration position;
  final Duration duration;

  const PlayerState({
    this.playingSong,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  PlayerState copyWith({
    Song? playingSong,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
  }) {
    return PlayerState(
      playingSong: playingSong ?? this.playingSong,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
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

class PauseEvent extends PlayerEvent {
  const PauseEvent();
}

class PreviousEvent extends PlayerEvent {
  const PreviousEvent();
}

class NextEvent extends PlayerEvent {
  const NextEvent();
}

class SeekEvent extends PlayerEvent {
  final Duration position;

  const SeekEvent(this.position);
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
    on<PauseEvent>(_handlePauseEvent);
    on<PreviousEvent>(_handlePreviousEvent);
    on<NextEvent>(_handleNextEvent);
    on<SeekEvent>(_handleSeekEvent);

    add(const InitializePlayerEvent());
  }

  late StreamSubscription<PlayerException> _subs;
  Song? _lastSong;

  Future<void> _handleInitiailizeFavoritesEvent(
      InitializePlayerEvent event, Emitter<PlayerState> emit) async {
    _subs = _player.errorStream.listen((e) {
      print('A stream error occurred: $e');
    });

    _player.positionStream.listen((position) {
      emit(state.copyWith(position: position));
    });

    _player.durationStream.listen((duration) {
      if (duration != null) {
        emit(state.copyWith(duration: duration));
      }
    });
  }

  Future<void> _handlePlayEvent(PlayEvent event, Emitter<PlayerState> emit) async {
    print('======= a = ${_lastSong?.songTitle} b = ${event.song.songTitle}');
    if (_lastSong?.songTitle != event.song.songTitle) {
      print('========= 1');
      _playlistMiddleware.addPlaylist(event.song);
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

  Future<void> _handlePauseEvent(PauseEvent event, Emitter<PlayerState> emit) async {
    if (state.isPlaying) {
      emit(state.copyWith(isPlaying: false));
      await _player.pause();
    }
  }

  Future<void> _handlePreviousEvent(PreviousEvent event, Emitter<PlayerState> emit) async {
    // TODO: Implement previous track logic
  }

  Future<void> _handleNextEvent(NextEvent event, Emitter<PlayerState> emit) async {
    // TODO: Implement next track logic
  }

  Future<void> _handleSeekEvent(SeekEvent event, Emitter<PlayerState> emit) async {
    await _player.seek(event.position);
  }

  @override
  Future<void> close() {
    _subs.cancel();
    return super.close();
  }
}
