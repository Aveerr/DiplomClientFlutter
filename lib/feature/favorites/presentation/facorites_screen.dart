import 'package:flutter/material.dart';

class FavoriteMusicScreen extends StatelessWidget {
  const FavoriteMusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back4.png"),
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: const Center(
          child: Text(
            'Welcome to Second Screen!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              shadows: [
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 