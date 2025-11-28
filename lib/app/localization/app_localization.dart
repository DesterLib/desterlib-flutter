/// Localization keys helper class
/// Usage: 'app.title'.tr() or AppLocalization.appTitle.tr()
class AppLocalization {
  // App
  static const String appTitle = 'app.title';

  // Home
  static const String homeTitle = 'home.title';
  static const String homeMovies = 'home.movies';
  static const String homeTvShows = 'home.tvShows';
  static const String homeRetry = 'home.retry';
  static const String homeError = 'home.error';
  static const String homeNoMoviesAvailable = 'home.noMoviesAvailable';
  static const String homeNoTVShowsAvailable = 'home.noTVShowsAvailable';

  // Settings
  static const String settingsTitle = 'settings.title';

  // Settings - Servers
  static const String settingsServersTitle = 'settings.servers.title';
  static const String settingsServersConnectionStatus =
      'settings.servers.connectionStatus';
  static const String settingsServersManageServers =
      'settings.servers.manageServers';
  static const String settingsServersConnected = 'settings.servers.connected';
  static const String settingsServersDisconnected =
      'settings.servers.disconnected';
  static const String settingsServersError = 'settings.servers.error';
  static const String settingsServersChecking = 'settings.servers.checking';
  static const String settingsServersApiUrl = 'settings.servers.apiUrl';
  static const String settingsServersEnterApiUrl =
      'settings.servers.enterApiUrl';
  static const String settingsServersSave = 'settings.servers.save';
  static const String settingsServersClose = 'settings.servers.close';
  static const String settingsServersManageApiConnection =
      'settings.servers.manageApiConnection';
  static const String settingsServersStatusTab = 'settings.servers.statusTab';
  static const String settingsServersApisTab = 'settings.servers.apisTab';
  static const String settingsServersAddApi = 'settings.servers.addApi';
  static const String settingsServersApiLabel = 'settings.servers.apiLabel';
  static const String settingsServersEnterApiLabel =
      'settings.servers.enterApiLabel';
  static const String settingsServersSetActive = 'settings.servers.setActive';
  static const String settingsServersActive = 'settings.servers.active';
  static const String settingsServersDelete = 'settings.servers.delete';
  static const String settingsServersNoApisConfigured =
      'settings.servers.noApisConfigured';
  static const String settingsServersAddFirstApi =
      'settings.servers.addFirstApi';

  // Settings - Libraries
  static const String settingsLibrariesTitle = 'settings.libraries.title';
  static const String settingsLibrariesManageLibraries =
      'settings.libraries.manageLibraries';
  static const String settingsLibrariesNoLibrariesAvailable =
      'settings.libraries.noLibrariesAvailable';
  static const String settingsLibrariesAddFirstLibrary =
      'settings.libraries.addFirstLibrary';
  static const String settingsLibrariesAddLibrary =
      'settings.libraries.addLibrary';
  static const String settingsLibrariesLibraryName =
      'settings.libraries.libraryName';
  static const String settingsLibrariesLibraryDescription =
      'settings.libraries.libraryDescription';
  static const String settingsLibrariesLibraryType =
      'settings.libraries.libraryType';
  static const String settingsLibrariesLibraryPath =
      'settings.libraries.libraryPath';
  static const String settingsLibrariesEnterLibraryName =
      'settings.libraries.enterLibraryName';
  static const String settingsLibrariesEnterLibraryDescription =
      'settings.libraries.enterLibraryDescription';
  static const String settingsLibrariesEnterLibraryPath =
      'settings.libraries.enterLibraryPath';
  static const String settingsLibrariesEditLibrary =
      'settings.libraries.editLibrary';
  static const String settingsLibrariesDeleteLibrary =
      'settings.libraries.deleteLibrary';
  static const String settingsLibrariesConfirmDeleteLibrary =
      'settings.libraries.confirmDeleteLibrary';
  static const String settingsLibrariesMediaCount =
      'settings.libraries.mediaCount';

  // Settings - Metadata
  static const String settingsMetadataTitle = 'settings.metadata.title';
  static const String settingsMetadataDescription =
      'settings.metadata.description';
  static const String settingsMetadataManageProviders =
      'settings.metadata.manageProviders';
  static const String settingsMetadataProvidersTitle =
      'settings.metadata.providersTitle';
  static const String settingsMetadataProviderTmdb =
      'settings.metadata.providerTmdb';
  static const String settingsMetadataConfigured =
      'settings.metadata.configured';
  static const String settingsMetadataNotConfigured =
      'settings.metadata.notConfigured';
  static const String settingsMetadataProviderSaved =
      'settings.metadata.providerSaved';

  // Settings - TMDB (kept for backward compatibility with modal)
  static const String settingsTmdbTitle = 'settings.tmdb.title';
  static const String settingsTmdbApiKey = 'settings.tmdb.apiKey';
  static const String settingsTmdbEnterApiKey = 'settings.tmdb.enterApiKey';
  static const String settingsTmdbApiKeyHelper = 'settings.tmdb.apiKeyHelper';
  static const String settingsTmdbApiKeyRequired =
      'settings.tmdb.apiKeyRequired';
  static const String settingsTmdbApiKeyNotSet = 'settings.tmdb.apiKeyNotSet';
  static const String settingsTmdbApiKeySaved = 'settings.tmdb.apiKeySaved';
  static const String settingsTmdbApiKeyRequiredForLibrary =
      'settings.tmdb.apiKeyRequiredForLibrary';

  // Settings - Scan
  static const String settingsScanSettingsTitle = 'settings.scan.settingsTitle';
  static const String settingsScanSettingsSaved = 'settings.scan.settingsSaved';
  static const String settingsScanSettingsSaveError =
      'settings.scan.settingsSaveError';
  static const String settingsScanMediaType = 'settings.scan.mediaType';
  static const String settingsScanMediaTypeHint = 'settings.scan.mediaTypeHint';
  static const String settingsScanMediaTypeHelper =
      'settings.scan.mediaTypeHelper';
  static const String settingsScanMaxDepth = 'settings.scan.maxDepth';
  static const String settingsScanMaxDepthHint = 'settings.scan.maxDepthHint';
  static const String settingsScanMaxDepthHelper =
      'settings.scan.maxDepthHelper';
  static const String settingsScanMaxDepthInvalid =
      'settings.scan.maxDepthInvalid';
  static const String settingsScanMovieDepth = 'settings.scan.movieDepth';
  static const String settingsScanMovieDepthHint =
      'settings.scan.movieDepthHint';
  static const String settingsScanMovieDepthHelper =
      'settings.scan.movieDepthHelper';
  static const String settingsScanMovieDepthInvalid =
      'settings.scan.movieDepthInvalid';
  static const String settingsScanTvDepth = 'settings.scan.tvDepth';
  static const String settingsScanTvDepthHint = 'settings.scan.tvDepthHint';
  static const String settingsScanTvDepthHelper = 'settings.scan.tvDepthHelper';
  static const String settingsScanTvDepthInvalid =
      'settings.scan.tvDepthInvalid';
  static const String settingsScanFileExtensions =
      'settings.scan.fileExtensions';
  static const String settingsScanFileExtensionsHint =
      'settings.scan.fileExtensionsHint';
  static const String settingsScanFileExtensionsHelper =
      'settings.scan.fileExtensionsHelper';
  static const String settingsScanFilenamePattern =
      'settings.scan.filenamePattern';
  static const String settingsScanFilenamePatternHint =
      'settings.scan.filenamePatternHint';
  static const String settingsScanFilenamePatternHelper =
      'settings.scan.filenamePatternHelper';
  static const String settingsScanExcludePattern =
      'settings.scan.excludePattern';
  static const String settingsScanExcludePatternHint =
      'settings.scan.excludePatternHint';
  static const String settingsScanExcludePatternHelper =
      'settings.scan.excludePatternHelper';
  static const String settingsScanIncludePattern =
      'settings.scan.includePattern';
  static const String settingsScanIncludePatternHint =
      'settings.scan.includePatternHint';
  static const String settingsScanIncludePatternHelper =
      'settings.scan.includePatternHelper';
  static const String settingsScanDirectoryPattern =
      'settings.scan.directoryPattern';
  static const String settingsScanDirectoryPatternHint =
      'settings.scan.directoryPatternHint';
  static const String settingsScanDirectoryPatternHelper =
      'settings.scan.directoryPatternHelper';
  static const String settingsScanExcludeDirectories =
      'settings.scan.excludeDirectories';
  static const String settingsScanExcludeDirectoriesHint =
      'settings.scan.excludeDirectoriesHint';
  static const String settingsScanExcludeDirectoriesHelper =
      'settings.scan.excludeDirectoriesHelper';
  static const String settingsScanIncludeDirectories =
      'settings.scan.includeDirectories';
  static const String settingsScanIncludeDirectoriesHint =
      'settings.scan.includeDirectoriesHint';
  static const String settingsScanIncludeDirectoriesHelper =
      'settings.scan.includeDirectoriesHelper';
  static const String settingsScanRescan = 'settings.scan.rescan';
  static const String settingsScanRescanHint = 'settings.scan.rescanHint';
  static const String settingsScanRescanHelper = 'settings.scan.rescanHelper';
  static const String settingsScanBatchScan = 'settings.scan.batchScan';
  static const String settingsScanBatchScanHint = 'settings.scan.batchScanHint';
  static const String settingsScanBatchScanHelper =
      'settings.scan.batchScanHelper';
  static const String settingsScanMinFileSize = 'settings.scan.minFileSize';
  static const String settingsScanMinFileSizeHint =
      'settings.scan.minFileSizeHint';
  static const String settingsScanMinFileSizeHelper =
      'settings.scan.minFileSizeHelper';
  static const String settingsScanMinFileSizeInvalid =
      'settings.scan.minFileSizeInvalid';
  static const String settingsScanMaxFileSize = 'settings.scan.maxFileSize';
  static const String settingsScanMaxFileSizeHint =
      'settings.scan.maxFileSizeHint';
  static const String settingsScanMaxFileSizeHelper =
      'settings.scan.maxFileSizeHelper';
  static const String settingsScanMaxFileSizeInvalid =
      'settings.scan.maxFileSizeInvalid';
  static const String settingsScanFollowSymlinks =
      'settings.scan.followSymlinks';
  static const String settingsScanFollowSymlinksHint =
      'settings.scan.followSymlinksHint';
  static const String settingsScanFollowSymlinksHelper =
      'settings.scan.followSymlinksHelper';
  static const String settingsScanGeneralGroupHelper =
      'settings.scan.generalGroupHelper';
  static const String settingsScanDepthGroupHelper =
      'settings.scan.depthGroupHelper';
  static const String settingsScanFileSizeGroupHelper =
      'settings.scan.fileSizeGroupHelper';
  static const String settingsScanFileFiltersGroupHelper =
      'settings.scan.fileFiltersGroupHelper';
  static const String settingsScanPatternsGroupHelper =
      'settings.scan.patternsGroupHelper';
  static const String settingsScanDirectoriesGroupHelper =
      'settings.scan.directoriesGroupHelper';
  static const String settingsScanRegexInvalid = 'settings.scan.regexInvalid';
  static const String settingsScanSettingsSave = 'settings.scan.save';
  static const String settingsScanGeneralSection =
      'settings.scan.generalSection';
  static const String settingsScanMediaTypeSpecificSection =
      'settings.scan.mediaTypeSpecificSection';
  static const String settingsScanMediaTypeSpecificHelper =
      'settings.scan.mediaTypeSpecificHelper';
  static const String settingsScanMovieSpecificSettings =
      'settings.scan.movieSpecificSettings';
  static const String settingsScanTvShowSpecificSettings =
      'settings.scan.tvShowSpecificSettings';
  static const String settingsScanScanDepthSection =
      'settings.scan.scanDepthSection';
  static const String settingsScanDirectoryNameRegexPatternSection =
      'settings.scan.directoryNameRegexPatternSection';
  static const String settingsScanFileNameRegexPatternSection =
      'settings.scan.fileNameRegexPatternSection';

  // Settings - Reset
  static const String settingsResetTitle = 'settings.reset.title';
  static const String settingsResetHelper = 'settings.reset.helper';
  static const String settingsResetFullHelper = 'settings.reset.fullHelper';
  static const String settingsResetScanSettings =
      'settings.reset.resetScanSettings';
  static const String settingsResetAllSettings =
      'settings.reset.resetAllSettings';
  static const String settingsResetConfirmTitle = 'settings.reset.confirmTitle';
  static const String settingsResetScanConfirmMessage =
      'settings.reset.resetScanConfirmMessage';
  static const String settingsResetAllConfirmMessage =
      'settings.reset.resetAllConfirmMessage';
  static const String settingsResetScanSuccess =
      'settings.reset.resetScanSuccess';
  static const String settingsResetAllSuccess =
      'settings.reset.resetAllSuccess';
  static const String settingsResetScanError = 'settings.reset.resetScanError';
  static const String settingsResetAllError = 'settings.reset.resetAllError';

  // Common
  static const String cancel = 'common.cancel';
  static const String reset = 'common.reset';
}
