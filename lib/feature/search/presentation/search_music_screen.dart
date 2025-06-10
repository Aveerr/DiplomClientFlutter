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

class _SearchMusicScreenState extends State<SearchMusicScreen> {
  late final SearchBloc _bloc;
  late final PlayerBloc _playerBloc;
  late final FavoritesBloc _favoritesBloc;

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
      statusBarColor: Colors.black,
    ));

    _bloc = instanceOf();
    _playerBloc = instanceOf();
    _favoritesBloc = instanceOf();
    // _searchController.addListener(_searchListener);
  }

  void _searchListener() {
    if (!(_timer?.isActive ?? true)) {
      _timer?.cancel();
      _timer = null;
    }

    _timer = Timer(Duration(seconds: 2), () {
      _bloc.add(SearchPlaylistEvent(_searchController.text));
    });
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_searchListener)
      ..dispose();
    super.dispose();
  }

  void _handleSearch() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    _logger.info('Searching for: $_searchQuery');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/back4.png"),
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: BlocBuilder<PlayerBloc, PlayerState>(
        bloc: _playerBloc,
        builder: (context, playerState) {
          print('========= c = ${playerState.playingSong?.songTitle}');
          return BlocBuilder<FavoritesBloc, FavoritesState>(
            bloc: _favoritesBloc,
            builder: (context, favouriteState) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  title: _buildSearchBar(),
                ),
                floatingActionButton: playerState.playingSong != null
                    ? PlaylistCell(
                        title: playerState.playingSong!.songTitle,
                        isFavorite: false,
                        isPlaying: playerState.isPlaying,
                        onLikePressed: () =>
                            _favoritesBloc.add(SwitchFavouriteEvent(playerState.playingSong!)),
                        onPlayPressed: () async =>
                            _playerBloc.add(PlayEvent(playerState.playingSong!)),
                      )
                    : null,
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                body: BlocBuilder<SearchBloc, SearchState>(
                  bloc: _bloc,
                  builder: (context, state) {
                    print('======= state = ${state.songs.length}');
                    if (state.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      itemCount: state.songs.length,
                      itemBuilder: (context, index) {
                        final song = state.songs[index];
                        print(
                            '====== a = ${playerState.playingSong?.songTitle} b = ${song.songTitle}');
                        return PlaylistCell(
                          title: song.songTitle,
                          isFavorite: favouriteState.favourites
                              .where((f) => f.songTitle == song.songTitle)
                              .isNotEmpty,
                          isPlaying: playerState.playingSong?.songTitle == song.songTitle &&
                              playerState.isPlaying,
                          onLikePressed: () => _favoritesBloc.add(SwitchFavouriteEvent(song)),
                          onPlayPressed: () async => _playerBloc.add(PlayEvent(song)),
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search Music',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: _handleSearch,
        ),
      ),
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      onSubmitted: (value) {
        _searchListener();
      },
    );
  }
}
