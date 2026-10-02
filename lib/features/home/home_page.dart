import 'package:desterlib_client/features/widgets/media_item.dart';
import 'package:desterlib_client/features/widgets/scroll_list.dart';
import 'package:flutter/widgets.dart';

const List<MediaItem> dummyItems = [
  MediaItem(
    id: '1',
    title: 'Dune: Part Two',
    poster: 'https://image.tmdb.org/t/p/w500/1pdfLvkbY9ohJlCjQH2CZjjYVvJ.jpg',
    type: MediaType.movie,
  ),
  MediaItem(
    id: '2',
    title: 'Oppenheimer',
    poster: 'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg',
    type: MediaType.movie,
  ),
  MediaItem(
    id: '3',
    title: 'The Batman',
    poster: 'https://image.tmdb.org/t/p/w500/74xTEgt7R36Fpooo50r9T25onhq.jpg',
    type: MediaType.movie,
  ),
  MediaItem(
    id: '4',
    title: 'Interstellar',
    poster: 'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
    type: MediaType.movie,
  ),
  MediaItem(
    id: '5',
    title: 'Blade Runner 2049',
    poster: 'https://image.tmdb.org/t/p/w500/gajva2L0rPYkEWjzgFlBXCAVBE5.jpg',
    type: MediaType.movie,
  ),
  MediaItem(
    id: '6',
    title: 'Arrival',
    poster: 'https://image.tmdb.org/t/p/w500/x2FJsf1ElAgr63Y3PNPtJrcmpoe.jpg',
    type: MediaType.movie,
  ),
  MediaItem(
    id: '7',
    title: 'The Grand Budapest Hotel',
    poster: 'https://image.tmdb.org/t/p/w500/eWdyYQreja6JGCzqHWXpWHDrrPo.jpg',
    type: MediaType.movie,
  ),
  MediaItem(
    id: '8',
    title: 'Parasite',
    poster: 'https://image.tmdb.org/t/p/w500/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg',
    type: MediaType.movie,
  ),
  MediaItem(
    id: '9',
    title: 'Everything Everywhere All at Once',
    poster: 'https://image.tmdb.org/t/p/w500/u68AjlvlutfEIcpmbYpKcdi09ut.jpg',
    type: MediaType.movie,
  ),
  MediaItem(
    id: '10',
    title: 'Spider-Man: Across the Spider-Verse',
    poster: 'https://image.tmdb.org/t/p/w500/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg',
    type: MediaType.movie,
  ),
  MediaItem(
    id: '11',
    title: 'The Whale',
    poster: 'https://image.tmdb.org/t/p/w500/jQ0gylJMxWSL490sy0RrPj1Lj7e.jpg',
    type: MediaType.movie,
  ),
  MediaItem(
    id: '12',
    title: 'Top Gun: Maverick',
    poster: 'https://image.tmdb.org/t/p/w500/62HCnUTziyWcpDaBO2i1DX17ljH.jpg',
    type: MediaType.movie,
  ),
  MediaItem(
    id: '13',
    title: 'Poor Things',
    poster: 'https://image.tmdb.org/t/p/w500/kCGlIMHnOm8JPXq3rXM6c5wMxcT.jpg',
    type: MediaType.movie,
  ),
  MediaItem(
    id: '14',
    title: 'Killers of the Flower Moon',
    poster: 'https://image.tmdb.org/t/p/w500/dB6Krk806zeqd0YNp2ngQ9zXteH.jpg',
    type: MediaType.movie,
  ),
  MediaItem(
    id: '15',
    title: 'The Zone of Interest',
    poster: 'https://image.tmdb.org/t/p/w500/hUu9zyZmDd8VZegKi1iK1Vk0RYS.jpg',
    type: MediaType.movie,
  ),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _HomeContent();
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 36,
        children: [
          ScrollList(title: "Movies", items: dummyItems),
          ScrollList(title: "TV Shows", items: dummyItems),
          ScrollList(title: "Anime", items: dummyItems),
        ],
      ),
    );
  }
}
