import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/common/media_list.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HomeBloc(repository: widget.homeRepository)..add(HomeLoadRequested()),
      child: Builder(
        builder: (context) => SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 80), // Space for floating nav
              // Content area
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1220),
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
                                  onPressed: () => context.read<HomeBloc>().add(
                                    HomeLoadRequested(),
                                  ),
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
                            child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
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
                                        'mediaId': movie.id,
                                        'type': 'MOVIE',
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
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
                                        'mediaId': tv.id,
                                        'type': 'TV_SHOW',
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
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
}
