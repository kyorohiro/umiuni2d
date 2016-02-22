part of tinygame;

abstract class TinyGameBuilder {
  Map<String, TinyImage> cach = {};
  Map<String, String> cachString = {};
  Map<String, Uint8List> cachBytes = {};

  TinyStage createStage(TinyDisplayObject root);
  Future<TinyAudioSource> loadAudio(String path);
  Future<String> loadStringBase(String path);
  Future<TinyImage> loadImageBase(String path);
  Future<Uint8List> loadBytesBase(String path);
  Future<TinyImage> loadImage(String path) async {
    if (cach.containsKey(path)) {
      return cach[path];
    }
    cach[path] = await loadImageBase(path);
    return cach[path];
  }

  Future<String> loadString(String path) async {
    if (cachString.containsKey(path)) {
      return cachString[path];
    }
    cachString[path] = await loadStringBase(path);
    return cachString[path];
  }

  Future<Uint8List> loadBytes(String path) async {
    if (cachBytes.containsKey(path)) {
      return cachBytes[path];
    }
    cachBytes[path] = await loadBytesBase(path);
    return cachBytes[path];
  }

  Uint8List getBytes(String path) {
    if (cachBytes.containsKey(path)) {
      return cachBytes[path];
    }
    return null;
  }

  String getString(String path) {
    if (cachString.containsKey(path)) {
      return cachString[path];
    }
    return null;
  }

  TinyImage getImage(String path) {
    if (cach.containsKey(path)) {
      return cach[path];
    }
    return null;
  }

  Future clearImageCash({bool callDispose: true, List<String> excepts: null}) async {
    Map<String, TinyImage> nextImageCach = {};
    excepts = (excepts == null ? [] : excepts);
    if (callDispose == true) {
      for (String k in cach.keys) {
        if (false == excepts.contains(k)) {
          TinyImage i = cach[k];
          i.dispose();
        } else {
          nextImageCach[k] = cach[k];
        }
      }
    }
    cach.clear();
    cach = nextImageCach;
  }

  Future clearStringCash() async {
    cachString.clear();
  }

  Future clearBytesCash() async {
    cachBytes.clear();
  }

  Future<TinyFile> loadFile(String name);
  Future<List<String>> getFiles();
  Future<String> getLocale();
  Future<double> getDisplayDensity();
}
