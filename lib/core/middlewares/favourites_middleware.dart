import 'dart:async';

import 'package:music_player/feature/playlist/data/song.dart';

class FavouritesMiddleware {
  StreamController<List<Song>> _favouritesController = StreamController();
  List<Song> _favourites = const [];

  List<Song> get favourites => _favourites;
  Stream<List<Song>> get favouritesStream => _favouritesController.stream;

  void addFavourite(Song song) {
    final updatedList = [..._favourites, song];
    _favouritesController.add(_favourites = updatedList);
  }

  void removeFavourite(Song song) {
    final updatedList = List.of(_favourites)..removeWhere((f) => f.songTitle == song.songTitle);
    _favouritesController.add(_favourites = updatedList);
  }
}
