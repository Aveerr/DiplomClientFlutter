import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/feature/playlist/data/song.dart';

class PlayerState {
  final Song? playingSong;

  const PlayerState({
    this.playingSong,
  });

  PlayerState copyWith({Song? playingSong}) {
    return PlayerState(
      playingSong: playingSong,
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

  PlayerBloc(this._player) : super(const PlayerState()) {
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
      // await _player.clearAudioSources();
      _lastSong = event.song;
      emit(state.copyWith(playingSong: event.song));

      await _player.setUrl(event.song.downloadUrl);
      await _player.play();
    } else if (_lastSong != null) {
      if (_player.playing) {
        await _player.stop();
        emit(state.copyWith(playingSong: null));
      } else {
        await _player.play();
        emit(state.copyWith(playingSong: event.song));
      }
    }
  }

  @override
  Future<void> close() {
    _subs.cancel();
    return super.close();
  }
}
