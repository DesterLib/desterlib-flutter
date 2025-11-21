// API client for fetching data from the server
class HomeDataSource {
  // Get movies list from API
  Future<List<Map<String, dynamic>>> getMoviesList() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return dummy data (mimicking what Swagger-generated client would return)
    return [
      {
        'id': '1',
        'title': 'The Dark Knight',
        'posterPath': '/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
        'backdropPath': '/hqkIcbrOHL86UncnHIsHVcVmzue.jpg',
        'overview': 'Batman raises the stakes in his war on crime...',
        'releaseDate': '2008-07-18',
        'rating': 9.0,
      },
      {
        'id': '2',
        'title': 'Inception',
        'posterPath': '/oYuLEt3zVCKq57qu2F8dT7NIa6f.jpg',
        'backdropPath': '/s3TBrRGB1iav7gFOCNx3H31MoES.jpg',
        'overview': 'A skilled thief is given a chance at redemption...',
        'releaseDate': '2010-07-16',
        'rating': 8.8,
      },
    ];
  }

  // Get TV shows list from API
  Future<List<Map<String, dynamic>>> getTVShowsList() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return dummy data (mimicking what Swagger-generated client would return)
    return [
      {
        'id': '1',
        'title': 'Breaking Bad',
        'posterPath': '/ggFHVNu6YYI5L9pCfOacjizRGt.jpg',
        'backdropPath': '/tsRy63Mu5cu8etL1X7ZLyf7UP1M.jpg',
        'overview':
            'A high school chemistry teacher turned methamphetamine manufacturer...',
        'firstAirDate': '2008-01-20',
        'rating': 9.5,
      },
      {
        'id': '2',
        'title': 'Game of Thrones',
        'posterPath': '/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg',
        'backdropPath': '/2OMB0ynKlyIenMJWI2Dy9IWT4c.jpg',
        'overview':
            'Nine noble families fight for control over the lands of Westeros...',
        'firstAirDate': '2011-04-17',
        'rating': 9.3,
      },
    ];
  }
}
