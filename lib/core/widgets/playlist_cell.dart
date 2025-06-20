import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/core/utils/constants.dart';

class PlaylistCell extends StatelessWidget {
  final String title;
  final bool isFavorite;
  final bool isPlaying;
  final bool isBookmark;
  final VoidCallback onLikePressed;
  final VoidCallback onPlayPressed;
  final void Function(double)? onSeek;
  final String musicLogo;
  final double? position;

  const PlaylistCell({
    super.key,
    required this.title,
    required this.isFavorite,
    required this.isPlaying,
    required this.onLikePressed,
    required this.onPlayPressed,
    required this.musicLogo,
    this.isBookmark = false,
    this.position,
    this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    print('========= position = $position');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPlaying
              ? [
                  Colors.orangeAccent.withOpacity(0.9),
                  Colors.orange.withOpacity(0.9),
                ]
              : [
                  Colors.white,
                  Colors.white,
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPlayPressed,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'music_logo_$title',
                      flightShuttleBuilder: (
                        BuildContext flightContext,
                        Animation<double> animation,
                        HeroFlightDirection flightDirection,
                        BuildContext fromHeroContext,
                        BuildContext toHeroContext,
                      ) {
                        return SingleChildScrollView(
                          child: DefaultTextStyle(
                            style: DefaultTextStyle.of(fromHeroContext).style,
                            child: toHeroContext.widget,
                          ),
                        );
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          image: DecorationImage(
                            image: NetworkImage(musicLogo),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isPlaying ? FontWeight.w600 : FontWeight.w500,
                              color: isPlaying ? Colors.white : Colors.black87,
                              letterSpacing: 0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap to play',
                            style: TextStyle(
                              fontSize: 12,
                              color: isPlaying ? Colors.white.withOpacity(0.8) : Colors.black54,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: onLikePressed,
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isPlaying ? Colors.white : Colors.black54,
                            size: 24,
                          ),
                          splashRadius: 24,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isPlaying
                                ? Colors.white.withOpacity(0.2)
                                : Colors.black.withOpacity(0.05),
                          ),
                          child: IconButton(
                            onPressed: onPlayPressed,
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: isPlaying ? Colors.white : Colors.black87,
                              size: 28,
                            ),
                            splashRadius: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (isBookmark) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 10,
                    child: Slider(
                      value: position ?? 0.0,
                      thumbColor: Colors.deepOrangeAccent,
                      onChanged: (_) {},
                      onChangeEnd: onSeek,
                      activeColor: Colors.orange,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
