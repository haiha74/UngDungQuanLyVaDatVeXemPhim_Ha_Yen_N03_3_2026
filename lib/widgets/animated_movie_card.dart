import 'package:flutter/material.dart';

import '../models/movie.dart';

class AnimatedMovieCard extends StatefulWidget {
  const AnimatedMovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    this.compact = false,
  });

  final Movie movie;
  final VoidCallback onTap;
  final bool compact;

  @override
  State<AnimatedMovieCard> createState() => _AnimatedMovieCardState();
}

class _AnimatedMovieCardState extends State<AnimatedMovieCard> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _active = true),
      onExit: (_) => setState(() => _active = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _active = true),
        onTapCancel: () => setState(() => _active = false),
        onTapUp: (_) {
          setState(() => _active = false);
          widget.onTap();
        },
        child: AnimatedScale(
          scale: _active ? 0.97 : 1,
          duration: const Duration(milliseconds: 180),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            decoration: BoxDecoration(
              color: const Color(0xFF18181D),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _active ? const Color(0xFFE5383B) : const Color(0xFF2B2B31)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: _active ? 0.45 : 0.28),
                  blurRadius: _active ? 24 : 14,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: widget.onTap,
              splashColor: const Color(0xFFE5383B).withValues(alpha: 0.18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Hero(
                      tag: 'movie-poster-${widget.movie.id}',
                      child: Image.network(
                        widget.movie.posterUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFF2A2A30),
                          child: const Icon(Icons.local_movies, color: Colors.white54, size: 44),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(widget.compact ? 10 : 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${widget.movie.runtime} min',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
