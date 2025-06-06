import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:music_player/core/locator.dart';
import 'package:music_player/core/widgets/playlist_cell.dart';
import 'package:music_player/feature/player/bloc.dart';
import 'package:music_player/feature/search/domain/bloc.dart';

class SearchMusicScreen extends StatefulWidget {
  const SearchMusicScreen({super.key});

  @override
  State<SearchMusicScreen> createState() => _SearchMusicScreenState();
}

class _SearchMusicScreenState extends State<SearchMusicScreen> {
  late final SearchBloc _bloc;
  late final PlayerBloc _playerBloc;

  final TextEditingController _searchController = TextEditingController();
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
    _searchController.addListener(_searchListener);
  }

  void _searchListener() => _bloc.add(SearchPlaylistEvent(_searchController.text));

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
    // TODO: Implement actual search functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: _buildSearchBar(),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        bloc: _bloc,
        builder: (context, state) {
          print('======= state = ${state.songs.length}');
          return BlocBuilder<PlayerBloc, PlayerState>(
            bloc: _playerBloc,
            builder: (context, playerState) {
              return ListView.builder(
                itemCount: state.songs.length,
                itemBuilder: (context, index) {
                  final song = state.songs[index];
                  print('====== a = ${playerState.playingSong?.songTitle} b = ${song.songTitle}');
                  return PlaylistCell(
                    title: song.songTitle,
                    isFavorite: false,
                    isPlaying: playerState.playingSong?.songTitle == song.songTitle,
                    onLikePressed: () {},
                    onPlayPressed: () async => _playerBloc.add(PlayEvent(song)),
                  );
                },
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
        _handleSearch();
      },
    );
  }
}
