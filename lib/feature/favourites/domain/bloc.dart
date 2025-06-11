// import 'dart:async';
//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:music_player/feature/playlist/data/song.dart';
//
// class FavouritesState {
//   final List<Song> favourites;
//
//   const FavouritesState({
//     this.favourites = const [],
//   });
//
//   FavouritesState copyWith({List<Song>? favourites}) {
//     return FavouritesState(
//       favourites: favourites ?? this.favourites,
//     );
//   }
// }
//
// abstract class FavouritesEvent {
//   const FavouritesEvent();
// }
//
// class InitializeFavouritesEvent extends FavouritesEvent {
//   const InitializeFavouritesEvent();
// }
//
// class SwitchFavouriteEvent extends FavouritesEvent {
//   final Song song;
//
//   const SwitchFavouriteEvent(this.song);
// }
//
// class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
//   final AudioPlayer _player;
//
//   PlayerBloc(this._player) : super(const PlayerState()) {
//     on<InitializeFavouritesEvent>(_handleInitiailizeFavoritesEvent);
//     on<SwitchFavouriteEvent>(_handlePlayEvent);
//
//     add(const InitializePlayerEvent());
//   }
//
//   late StreamSubscription<PlayerException> _subs;
//   Song? _lastSong;
//
//   Future<void> _handleInitiailizeFavoritesEvent(
//       InitializeFavouritesEvent event, Emitter<PlayerState> emit) async {
//     _subs = _player.errorStream.listen((e) {
//       print('A stream error occurred: $e');
//     });
//   }
//
//   Future<void> _handlePlayEvent(SwitchFavouriteEvent event, Emitter<PlayerState> emit) async {
//     print('======= a = ${_lastSong?.songTitle} b = ${event.song.songTitle}');
//     if (_lastSong?.songTitle != event.song.songTitle) {
//       print('========= 1');
//       // await _player.clearAudioSources();
//       _lastSong = event.song;
//       emit(state.copyWith(playingSong: event.song, isPlaying: true));
//
//       await _player.setUrl(event.song.downloadUrl);
//       await _player.play();
//     } else  {
//       if (state.isPlaying) {
//         print('========= 2');
//         emit(state.copyWith(playingSong: event.song, isPlaying: false));
//         await _player.stop();
//       } else {
//         print('========= 3 ${event.song.songTitle}');
//         emit(state.copyWith(playingSong: event.song, isPlaying: true));
//         await _player.play();
//       }
//     }
//   }
//
//   @override
//   Future<void> close() {
//     _subs.cancel();
//     return super.close();
//   }
// }
