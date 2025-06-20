import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/widgets/playlist_cell.dart';
import 'package:music_player/feature/favorites/domain/bloc.dart';
import 'package:music_player/feature/player/domain/bloc.dart';
import 'package:music_player/feature/playlist/domain/bloc.dart';
import 'package:music_player/feature/player/presentation/player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final PlaylistBloc _bloc;
  late final PlayerBloc _playerBloc;
  late final FavoritesBloc _favoritesBloc;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _bloc = instanceOf();
    _playerBloc = instanceOf();
    _favoritesBloc = instanceOf();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      bloc: _playerBloc,
      builder: (context, playerState) {
        print('======== <PlayerBloc build');
        return Scaffold(
          extendBody: true,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.orange.shade200,
                ],
              ),
            ),
            child: SafeArea(
              child: BlocBuilder<PlaylistBloc, PlaylistState>(
                bloc: _bloc,
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Playlist',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${state.songs.length} songs',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.deepOrangeAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.shuffle,
                                color: Colors.deepOrangeAccent,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          itemCount: state.songs.length,
                          itemBuilder: (context, index) {
                            print('========= state.songs = ${state.songs}');
                            final song = state.songs[index];
                            print('========= song.musicLogo = ${song.musicLogo}');
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: PlaylistCell(
                                title: song.songTitle,
                                isFavorite: false,
                                isPlaying: playerState.playingSong?.songTitle == song.songTitle &&
                                    playerState.isPlaying,
                                onLikePressed: () => _favoritesBloc.add(SwitchFavouriteEvent(song)),
                                onPlayPressed: () async => _playerBloc.add(PlayEvent(song)),
                                musicLogo: song.musicLogo,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          floatingActionButton: playerState.playingSong != null
              ? AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  offset: Offset.zero,
                  child: Container(
                    width: 440,
                    height: 120,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepOrangeAccent.withOpacity(0.0),
                          Colors.white.withOpacity(0.0),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: BlocBuilder<FavoritesBloc, FavoritesState>(
                        bloc: _favoritesBloc,
                        builder: (context, favoritesState) {
                          return PlaylistCell(
                            title: playerState.playingSong!.songTitle,
                            isBookmark: true,
                            position: playerState.position,
                            isFavorite: favoritesState.favourites
                                .where((f) => f.songTitle == playerState.playingSong!.songTitle)
                                .isNotEmpty,
                            isPlaying: playerState.isPlaying,
                            onLikePressed: () =>
                                _favoritesBloc.add(SwitchFavouriteEvent(playerState.playingSong!)),
                            onPlayPressed: () async =>
                                _playerBloc.add(PlayEvent(playerState.playingSong!)),
                            musicLogo: playerState.playingSong!.musicLogo,
                          );
                        }),
                  ),
                )
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
