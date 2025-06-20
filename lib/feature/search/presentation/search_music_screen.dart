import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/widgets/playlist_cell.dart';
import 'package:music_player/feature/favorites/domain/bloc.dart';
import 'package:music_player/feature/player/domain/bloc.dart';
import 'package:music_player/feature/search/domain/bloc.dart';

class SearchMusicScreen extends StatefulWidget {
  const SearchMusicScreen({super.key});

  @override
  State<SearchMusicScreen> createState() => _SearchMusicScreenState();
}

class _SearchMusicScreenState extends State<SearchMusicScreen> with SingleTickerProviderStateMixin {
  late final SearchBloc _bloc;
  late final PlayerBloc _playerBloc;
  late final FavoritesBloc _favoritesBloc;
  late final AnimationController _animationController;

  final TextEditingController _searchController = TextEditingController();
  Timer? _timer;
  String _searchQuery = '';
  final _logger = Logger('SearchMusicScreen');

  @override
  void initState() {
    super.initState();
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    });
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _bloc = instanceOf();
    _playerBloc = instanceOf();
    _favoritesBloc = instanceOf();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  // void _searchListener() {
  //   if (!(_timer?.isActive ?? true)) {
  //     _timer?.cancel();
  //     _timer = null;
  //   }
  //
  //   _timer = Timer(const Duration(seconds: 2), () {
  //     _bloc.add(SearchPlaylistEvent(_searchController.text));
  //   });
  // }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: BlocBuilder<PlayerBloc, PlayerState>(
        bloc: _playerBloc,
        builder: (context, playerState) {
          return BlocBuilder<FavoritesBloc, FavoritesState>(
            bloc: _favoritesBloc,
            builder: (context, favouriteState) {
              return Scaffold(
                extendBody: true,
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: _buildSearchBar(),
                      ),
                      Expanded(
                        child: BlocBuilder<SearchBloc, SearchState>(
                          bloc: _bloc,
                          builder: (context, state) {
                            if (state.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            }

                            if (state.songs.isEmpty && _searchQuery.isNotEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 64,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No results found',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Try different search terms',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              itemCount: state.songs.length,
                              itemBuilder: (context, index) {
                                final song = state.songs[index];
                                return PlaylistCell(
                                  title: song.songTitle,
                                  isFavorite: favouriteState.favourites
                                      .where((f) => f.songTitle == song.songTitle)
                                      .isNotEmpty,
                                  isPlaying: playerState.playingSong?.songTitle == song.songTitle &&
                                      playerState.isPlaying,
                                  onLikePressed: () =>
                                      _favoritesBloc.add(SwitchFavouriteEvent(song)),
                                  onPlayPressed: () async => _playerBloc.add(PlayEvent(song)),
                                  musicLogo: song.musicLogo,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Search songs...',
          hintStyle: TextStyle(
            color: Colors.black45,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.deepOrangeAccent,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        onSubmitted: (value) => _bloc.add(SearchPlaylistEvent(_searchController.text)),
      ),
    );
  }
}
