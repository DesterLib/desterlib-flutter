import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/common/media_list.dart';
import '../../../services/config_service.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_events.dart';
import '../bloc/home_states.dart';
import '../repo/home_repository.dart';

class HomePage extends StatefulWidget {
  final HomeRepository homeRepository;
  final ConfigService configService;

  const HomePage({
    super.key,
    required this.homeRepository,
    required this.configService,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Check if base URL is configured
    if (!widget.configService.isConfigured) {
      return _buildSetupRequired(context);
    }

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
                          return _buildConnectionError(context, state.message);
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

  Widget _buildSetupRequired(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 80),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.settings_suggest,
                        size: 100,
                        color: Colors.blue.withOpacity(0.5),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Welcome to Dester!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'To get started, please configure your Dester server URL in the settings.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to settings page
                          Navigator.pushNamed(context, '/settings');
                        },
                        icon: const Icon(Icons.settings, size: 24),
                        label: const Text('Open Settings'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Connection Error',
              style: TextStyle(
                color: Colors.red.shade300,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  icon: const Icon(Icons.settings, size: 20),
                  label: const Text('Settings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<HomeBloc>().add(HomeLoadRequested());
                  },
                  icon: const Icon(Icons.refresh, size: 20),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
