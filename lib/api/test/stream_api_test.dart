import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for StreamApi
void main() {
  final instance = Openapi().getStreamApi();

  group(StreamApi, () {
    // Stream any media file by ID with byte-range support
    //
    // Streams any media file (movie, TV episode, music, comic) with proper HTTP range request support. This centralized endpoint can handle any media type stored in the database. Supports seeking, partial content delivery, and proper streaming headers for video/audio playback. 
    //
    //Future apiV1StreamIdGet(String id, { String range }) async
    test('test apiV1StreamIdGet', () async {
      // TODO
    });

  });
}
