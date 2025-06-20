import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart' hide PlayerState;
import 'package:music_player/feature/player/domain/bloc.dart';
import 'package:music_player/feature/favorites/domain/bloc.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, playerState) {
        if (playerState.playingSong == null) {
          return const SizedBox.shrink();
        }
        return BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, favoritesState) {
            final isFavorite = favoritesState.favourites
                .where((f) => f.songTitle == playerState.playingSong?.songTitle)
                .isNotEmpty;
            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Column(
                  children: [
                    // Верхняя панель с кнопками
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
                          ),
                          Text(
                            'Now Playing',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Добавить функционал для кнопки меню
                            },
                            icon: const Icon(Icons.more_vert, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),

                    // Основной контент
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            // Обложка альбома
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Hero(
                                tag: 'music_logo_${playerState.playingSong!.songTitle}',
                                child: Container(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.width - 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image: NetworkImage(playerState.playingSong!.musicLogo),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Информация о песне
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  Text(
                                    playerState.playingSong!.songTitle,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Unknown Artist',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Прогресс-бар
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  SliderTheme(
                                    data: SliderThemeData(
                                      trackHeight: 4,
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 6,
                                      ),
                                      overlayShape: const RoundSliderOverlayShape(
                                        overlayRadius: 14,
                                      ),
                                      activeTrackColor: Colors.deepOrange,
                                      inactiveTrackColor: Colors.grey[300],
                                      thumbColor: Colors.deepOrange,
                                      overlayColor: Colors.deepOrange.withOpacity(0.2),
                                    ),
                                    child: Slider(
                                      value: playerState.position,
                                      max: playerState.duration.inSeconds.toDouble(),
                                      onChanged: (value) {
                                        context.read<PlayerBloc>().add(
                                              SeekEvent(Duration(seconds: value.toInt())),
                                            );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatDuration(playerState.duration),
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          _formatDuration(playerState.duration),
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Кнопки управления
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // Добавить функционал для кнопки повтора
                                    },
                                    icon: Icon(
                                      Icons.repeat,
                                      color: Colors.grey[600],
                                      size: 28,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context.read<PlayerBloc>().add(
                                            const PreviousEvent(),
                                          );
                                    },
                                    icon: const Icon(
                                      Icons.skip_previous,
                                      color: Colors.black87,
                                      size: 32,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.deepOrange,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.deepOrange.withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        if (playerState.isPlaying) {
                                          context.read<PlayerBloc>().add(
                                                const PauseEvent(),
                                              );
                                        } else {
                                          context.read<PlayerBloc>().add(
                                                PlayEvent(playerState.playingSong!),
                                              );
                                        }
                                      },
                                      icon: Icon(
                                        playerState.isPlaying ? Icons.pause : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                      iconSize: 32,
                                      padding: const EdgeInsets.all(16),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context.read<PlayerBloc>().add(
                                            const NextEvent(),
                                          );
                                    },
                                    icon: const Icon(
                                      Icons.skip_next,
                                      color: Colors.black87,
                                      size: 32,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context.read<FavoritesBloc>().add(
                                            SwitchFavouriteEvent(playerState.playingSong!),
                                          );
                                    },
                                    icon: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? Colors.deepOrange : Colors.grey[600],
                                      size: 28,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
