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

class _FavoriteMusicScreenState extends State<FavoriteMusicScreen>
    with SingleTickerProviderStateMixin {
  late final FavoritesBloc _bloc;
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
        return Scaffold(
          extendBody: true,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.orange.shade200],
              ),
            ),
            child: SafeArea(
              child: BlocBuilder<FavoritesBloc, FavoritesState>(
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
                                  'Favorites',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${state.favourites.length} songs',
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
                                Icons.favorite,
                                color: Colors.deepOrangeAccent,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (state.favourites.isEmpty)
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrangeAccent.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.favorite_border,
                                    size: 64,
                                    color: Colors.deepOrangeAccent,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'No favorite songs yet',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Add songs to your favorites',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            itemCount: state.favourites.length,
                            itemBuilder: (context, index) {
                              final song = state.favourites[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: PlaylistCell(
                                  title: song.songTitle,
                                  isFavorite: true,
                                  isPlaying: playerState.playingSong?.songTitle == song.songTitle &&
                                      playerState.isPlaying,
                                  onLikePressed: () => _bloc.add(SwitchFavouriteEvent(song)),
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
                    height: 100,
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
                          isFavorite: favoritesState.favourites
                              .where((f) => f.songTitle == playerState.playingSong!.songTitle)
                              .isNotEmpty,
                          isPlaying: playerState.isPlaying,
                          onLikePressed: () =>
                              _bloc.add(SwitchFavouriteEvent(playerState.playingSong!)),
                          onPlayPressed: () async =>
                              _playerBloc.add(PlayEvent(playerState.playingSong!)),
                          musicLogo: playerState.playingSong!.musicLogo,
                        );
                      },
                    ),
                  ),
                )
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
