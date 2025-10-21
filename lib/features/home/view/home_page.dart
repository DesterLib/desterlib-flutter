import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/common/media_list.dart';
import '../../../widgets/common/nav_button.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_events.dart';
import '../bloc/home_states.dart';
import '../repo/home_repository.dart';

class HomePage extends StatefulWidget {
  final HomeRepository homeRepository;

  const HomePage({super.key, required this.homeRepository});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HomeBloc(repository: widget.homeRepository)..add(HomeLoadRequested()),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Colors.grey.shade900,
          body: Stack(
            children: [
              // Content area
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 80), // Space for floating nav
                    // Content area
                    Expanded(
                      child: BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          if (state is HomeLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                              ),
                            );
                          } else if (state is HomeError) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Error: ${state.message}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () => context
                                        .read<HomeBloc>()
                                        .add(HomeLoadRequested()),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          } else if (state is HomeLoaded) {
                            return RefreshIndicator(
                              onRefresh: () async {
                                context.read<HomeBloc>().add(
                                  HomeRefreshRequested(),
                                );
                              },
                              color: Colors.blue,
                              backgroundColor: Colors.grey.shade800,
                              child: _buildContent(context, state),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Floating navigation bar
              Positioned(
                top: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NavButton(
                          label: 'Movies',
                          isSelected: _selectedIndex == 0,
                          onTap: () {
                            setState(() {
                              _selectedIndex = 0;
                            });
                          },
                        ),
                        const SizedBox(width: 4),
                        NavButton(
                          label: 'TV Shows',
                          isSelected: _selectedIndex == 1,
                          onTap: () {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                        ),
                        const SizedBox(width: 4),
                        NavButton(
                          label: 'Library',
                          isSelected: _selectedIndex == 2,
                          onTap: () {
                            setState(() {
                              _selectedIndex = 2;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeLoaded state) {
    switch (_selectedIndex) {
      case 0: // Movies
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Movies',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            MediaList<MovieItem>(
              items: state.movies,
              onTap: (movie) {
                Navigator.pushNamed(
                  context,
                  '/details',
                  arguments: {
                    'mediaId': movie.mediaId ?? movie.id,
                    'type': 'MOVIE',
                  },
                );
              },
            ),
          ],
        );
      case 1: // TV Shows
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'TV Shows',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            MediaList<TvItem>(
              items: state.tvShows,
              onTap: (tv) {
                Navigator.pushNamed(
                  context,
                  '/details',
                  arguments: {
                    'mediaId': tv.mediaId ?? tv.id,
                    'type': 'TV_SHOW',
                  },
                );
              },
            ),
          ],
        );
      case 2: // Library (Both)
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Movies',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            MediaList<MovieItem>(
              items: state.movies,
              onTap: (movie) {
                Navigator.pushNamed(
                  context,
                  '/details',
                  arguments: {
                    'mediaId': movie.mediaId ?? movie.id,
                    'type': 'MOVIE',
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'TV Shows',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            MediaList<TvItem>(
              items: state.tvShows,
              onTap: (tv) {
                Navigator.pushNamed(
                  context,
                  '/details',
                  arguments: {
                    'mediaId': tv.mediaId ?? tv.id,
                    'type': 'TV_SHOW',
                  },
                );
              },
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
