/// Settings entity representing application settings
class Settings {
  final String? tmdbApiKey;
  final bool firstRun;

  const Settings({this.tmdbApiKey, required this.firstRun});
}
