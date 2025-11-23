/// Use case interface for deleting a library
abstract class DeleteLibrary {
  Future<void> call(String id);
}
