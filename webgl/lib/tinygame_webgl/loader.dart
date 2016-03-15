part of tinygame_webgl;

class TinyWebglLoader {
  static Future<ImageElement> loadImage(String path) async {
    Completer<ImageElement> c = new Completer();
    ImageElement elm = new ImageElement(src: path);
    elm.onLoad.listen((_) {
      c.complete(elm);
    });
    elm.onError.listen((_) {
      c.completeError("failed to load image ${path}");
    });
    return c.future;
  }

  static Future<String> loadString(String path) async {
    return await HttpRequest.getString(path);
  }
}
