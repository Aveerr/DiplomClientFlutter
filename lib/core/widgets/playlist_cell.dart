import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_player/core/utils/constants.dart';

class PlaylistCell extends StatelessWidget {
  final String title;
  final bool isFavorite;
  final bool isPlaying;
  final VoidCallback onPlayPressed;
  final VoidCallback onLikePressed;

  const PlaylistCell({
    required this.title,
    required this.onPlayPressed,
    required this.onLikePressed,
    this.isFavorite = false,
    this.isPlaying = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPlayPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.yellow,
        ),
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(title)),
            SvgPicture.asset(
              SvgPaths.like,
              colorFilter: ColorFilter.mode(
                isFavorite ? Colors.black : Colors.black45,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
