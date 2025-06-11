import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/widgets/playlist_cell.dart';
import 'package:music_player/feature/favorites/domain/bloc.dart';
import 'package:music_player/feature/player/domain/bloc.dart';
import 'package:music_player/feature/playlist/domain/bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PlaylistBloc _bloc;
  late final PlayerBloc _playerBloc;
  late final FavoritesBloc _favoritesBloc;

  @override
  void initState() {
    super.initState();
    _bloc = instanceOf();
    _playerBloc = instanceOf();
    _favoritesBloc = instanceOf();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      bloc: _playerBloc,
      builder: (context, playerState) {
        return Scaffold(
          floatingActionButton: playerState.playingSong != null
              ? PlaylistCell(
                  title: playerState.playingSong!.songTitle,
                  isFavorite: false,
                  isPlaying: playerState.isPlaying,
                  onLikePressed: () {},
                  onPlayPressed: () async => _playerBloc.add(PlayEvent(playerState.playingSong!)),
                )
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/back4.png"),
                repeat: ImageRepeat.repeat,
              ),
            ),
            child: BlocBuilder<PlaylistBloc, PlaylistState>(
              bloc: _bloc,
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Playlist',
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.songs.length,
                        itemBuilder: (context, index) {
                          final song = state.songs[index];
                          print(
                              '====== a = ${playerState.playingSong?.songTitle} b = ${song.songTitle}');
                          return PlaylistCell(
                            title: song.songTitle,
                            isFavorite:
                                state.songs.where((f) => f.songTitle == song.songTitle).isNotEmpty,
                            isPlaying: playerState.playingSong?.songTitle == song.songTitle &&
                                playerState.isPlaying,
                            onLikePressed: () => _favoritesBloc.add(SwitchFavouriteEvent(song)),
                            onPlayPressed: () async => _playerBloc.add(PlayEvent(song)),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
