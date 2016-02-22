part of tinygame;

abstract class TinyFile {
  Future<int> write(List<int> buffer, int offset);
  Future<List<int>> read(int offset, int length);
  Future<int> getLength();
  Future<int> truncate(int fileSize);
}
