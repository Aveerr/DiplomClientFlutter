import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/widgets/playlist_cell.dart';
import 'package:music_player/feature/favorites/domain/bloc.dart';
import 'package:music_player/feature/favorites/presentation/favorites_screen.dart';
import 'package:music_player/feature/player/domain/bloc.dart';
import 'package:music_player/feature/playlist/presentation/playlist_screen.dart';
import 'package:music_player/feature/search/presentation/search_music_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late final PlayerBloc _playerBloc;
  late final FavoritesBloc _favoritesBloc;

  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(), //Экран с плэйлистами
    FavoriteMusicScreen(), //экран с люимой музыкой
    SearchMusicScreen(), // экран с поиском музыки
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // выбранный экран (его индекс)
    });
  }

  @override
  void initState() {
    super.initState();
    _playerBloc = instanceOf();
    _favoritesBloc = instanceOf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], //выбирается экран который будет показываться
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play),
            label: 'Playlists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.deepOrangeAccent,
        selectedItemColor: Colors.orange,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
      floatingActionButton: BlocBuilder<PlayerBloc, PlayerState>(
          bloc: _playerBloc,
          buildWhen: (p, c) => p.position != c.position || p.isPlaying != c.isPlaying,
          builder: (context, playerState) {
            print('======== <PlayerBloc build = ${playerState.position}');
            return playerState.playingSong != null
                ? AnimatedSlide(
                    duration: const Duration(milliseconds: 300),
                    offset: Offset.zero,
                    child: Container(
                      width: 440,
                      height: 130,
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
                              onLikePressed: () => _favoritesBloc
                                  .add(SwitchFavouriteEvent(playerState.playingSong!)),
                              onPlayPressed: () async =>
                                  _playerBloc.add(PlayEvent(playerState.playingSong!)),
                              musicLogo: playerState.playingSong!.musicLogo,
                              onSeek: (pos) => _playerBloc.add(SeekEvent(
                                Duration(
                                    seconds: (pos * playerState.playingSong!.musicLength).toInt()),
                                needSeekController: true,
                              )),
                            );
                          }),
                    ),
                  )
                : const SizedBox();
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
