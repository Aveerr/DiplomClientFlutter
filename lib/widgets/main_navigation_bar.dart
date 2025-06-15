import 'package:flutter/material.dart';
import 'package:music_player/feature/favorites/presentation/favorites_screen.dart';
import 'package:music_player/feature/playlist/presentation/playlist_screen.dart';
import 'package:music_player/feature/search/presentation/search_music_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
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
    );
  }
}
