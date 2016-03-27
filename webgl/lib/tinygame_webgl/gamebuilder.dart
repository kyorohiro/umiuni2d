part of tinygame_webgl;

class TinyGameBuilderForWebgl extends TinyGameBuilder {
  String assetsRoot = "";
  String get assetsPath => (assetsRoot.endsWith("/")?assetsRoot:"${assetsRoot}/");
  int width = 600;
  int height = 400;
  int paintInterval = 40;
  int tickInterval = 15;
  String selectors = null;
  TinyGameBuilderForWebgl({this.assetsRoot:""}) {}

  TinyStage createStage(TinyDisplayObject root) {
    return new TinyWebglStage(this, root, width:width, height:height, selectors:selectors, tickInterval:tickInterval, paintInterval:paintInterval);
  }

  Future<TinyImage> loadImageBase(String path) async {
    ImageElement elm = await TinyWebglLoader.loadImage("${assetsPath}${path}");
    return new TinyWebglImage(elm);
  }

  Future<TinyAudioSource> loadAudio(String path) async {
    print("--A--");
    Completer<TinyAudioSource> c = new Completer();
    AudioContext context = new AudioContext();
    HttpRequest request = new HttpRequest();
    request.open("GET", "${assetsRoot}${path}");
    request.responseType = "arraybuffer";
    request.onLoad.listen((ProgressEvent e) async {
      print("--B--");
      try {
        AudioBuffer buffer = await context.decodeAudioData(request.response);
        c.complete(new TinyWebglAudioSource(context, buffer));
      } catch(e) {
        print("--D-${path}- ${e}");
        c.completeError(e);
      }
    });
    request.onError.listen((ProgressEvent e) {
      print("--C--");
      c.completeError(e);
    });
    request.send();
    print("--D--");
    return c.future;
  }

  Future<Uint8List> loadBytesBase(String path) async {
    Completer<Uint8List> c = new Completer();
    HttpRequest request = new HttpRequest();
    request.open("GET", "${assetsRoot}${path}");
    request.responseType = "arraybuffer";
    request.onLoad.listen((ProgressEvent e) async {
      ByteBuffer buffer = request.response;
      c.complete(buffer.asUint8List());
    });
    request.onError.listen((ProgressEvent e) {
      c.completeError(e);
    });
    request.send();
    return c.future;
  }

  Future<String> loadStringBase(String path) async {
    Uint8List buffer = await loadBytesBase(path);
    return await conv.UTF8.decode(buffer, allowMalformed: true);
  }

  Future<TinyFile> loadFile(String name) async {
    return new TinyWebglFile(name);
  }

  Future<List<String>> getFiles() async {
    FileSystem e = await window.requestFileSystem(1024, persistent: true);
    List<Entry> files = await e.root.createReader().readEntries();
    List<String> ret = [];
    for (Entry e in files) {
      if (e.isFile) {
        ret.add(e.name);
      }
    }
    return ret;
  }

  Future<String> getLocale() async {
    return window.navigator.language;
  }

  Future<double> getDisplayDensity() async {
    return window.devicePixelRatio;
  }

  TinyTextObjcet createTextObject(
    String text, double textureWidth, double textureHeight,{
      double fontSize: 25.0,
      bool isBold: false,
      bool isItalic: false,
      String fontFamily: "Century Gothic",
      var fillColor: null,
      var strokeColor: null,
      var backgroundColor: null}) {
          return new TinyWebglTextObjcet(text, textureWidth, textureHeight,
            fontSize: fontSize,
            isBold: isBold,
            isItalic: isItalic,
            fontFamily: fontFamily,
            fillColor : fillColor,
            strokeColor: strokeColor,
            backgroundColor: backgroundColor
          );
      }
}
