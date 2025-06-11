import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/widgets/playlist_cell.dart';
import 'package:music_player/feature/favorites/domain/bloc.dart';
import 'package:music_player/feature/player/domain/bloc.dart';

class FavoriteMusicScreen extends StatefulWidget {
  const FavoriteMusicScreen({super.key});

  @override
  State<FavoriteMusicScreen> createState() => _FavoriteMusicScreenState();
}

class _FavoriteMusicScreenState extends State<FavoriteMusicScreen> {
  late final FavoritesBloc _bloc;
  late final PlayerBloc _playerBloc;

  @override
  void initState() {
    super.initState();
    _bloc = instanceOf();
    _playerBloc = instanceOf();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
        bloc: _playerBloc,
        builder: (context, playerState) {
          print('========= c = ${playerState.playingSong?.songTitle}');
          return Scaffold(
            floatingActionButton: playerState.playingSong != null
                ? PlaylistCell(
                    title: playerState.playingSong!.songTitle,
                    isFavorite: false,
                    isPlaying: playerState.isPlaying,
                    onLikePressed: () =>
                        () => _bloc.add(SwitchFavouriteEvent(playerState.playingSong!)),
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
              child: BlocBuilder<FavoritesBloc, FavoritesState>(
                bloc: _bloc,
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Favourites',
                        style: TextStyle(fontSize: 32, color: Colors.white),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.favourites.length,
                          itemBuilder: (context, index) {
                            final song = state.favourites[index];
                            print(
                                '====== a = ${playerState.playingSong?.songTitle} b = ${song.songTitle}');
                            return PlaylistCell(
                              title: song.songTitle,
                              isFavorite: state.favourites
                                  .where((f) => f.songTitle == song.songTitle)
                                  .isNotEmpty,
                              isPlaying: playerState.playingSong?.songTitle == song.songTitle &&
                                  playerState.isPlaying,
                              onLikePressed: () => _bloc.add(SwitchFavouriteEvent(song)),
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
        });
  }
}
