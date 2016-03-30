part of tinygame_flutter;

class TinyGameBuilderForFlutter extends TinyGameBuilder {
  String assetsRoot;

  TinyGameBuilderForFlutter({this.assetsRoot:"web/"}) {
    ;
  }

  String get assetsPath => (assetsRoot.endsWith("/")?assetsRoot:"${assetsRoot}/");

  bool tickInPerFrame = true;
  bool useTestCanvas = true;//false;
  bool useDrawVertexForPrimtive = false;
  TinyFlutterAudioManager audioManager = new TinyFlutterAudioManager();

  @override
  TinyStage createStage(TinyDisplayObject root) {
    return new TinyFlutterStage(this, root,tickInPerFrame:tickInPerFrame, useTestCanvas:useTestCanvas, useDrawVertexForPrimtive:useDrawVertexForPrimtive);
  }

  @override
  Future<TinyImage> loadImageBase(String path) async {
    return new TinyFlutterImage(
        await ResourceLoader.loadImage("${assetsPath}${path}"));
  }

  @override
  Future<TinyAudioSource> loadAudio(String path) async {
    return await audioManager.loadAudioSource("${assetsRoot}${path}");
  }

  @override
  Future<data.Uint8List> loadBytesBase(String path) async {
    return  await ResourceLoader.loadBytes("${assetsRoot}${path}");
  }

  @override
  Future<String> loadStringBase(String path) async {
    String a = await ResourceLoader.loadString("${assetsRoot}${path}");
    return a;
  }

  @override
  Future<TinyFile> loadFile(String name) async {
    await initFile();
    File f = new File("${rootPath.path}/${name}");
    return new TinyFlutterFile(f);
  }

  PathServiceProxy pathServiceProxy;
  Directory rootPath;
  Future initFile() async {
    if (rootPath == null) {
      PathServiceProxy pathServiceProxy = new PathServiceProxy.unbound();
      shell.connectToService("dummy", pathServiceProxy);
      PathServiceGetFilesDirResponseParams dirResponse =
          await pathServiceProxy.ptr.getFilesDir();
      rootPath = new Directory(dirResponse.path);
    }
  }

  @override
  Future<List<String>> getFiles() async {
    await initFile();
    List<String> ret = [];
    await for (FileSystemEntity fse in rootPath.list()) {
      ret.add(fse.path.split("/").last);
    }
    return ret;
  }

  @override
  Future<String> getLocale() async {
    return sky.window.locale.languageCode;
  }

  @override
  Future<double> getDisplayDensity() async {
    return sky.window.devicePixelRatio;
  }

  @override
  TinyTextObjcet createTextObject(
    String text, double textureWidth, double textureHeight,{
      double fontSize: 25.0,
      bool isBold: false,
      bool isItalic: false,
      String fontFamily: "Century Gothic",
      var fillColor: null,
      var strokeColor: null,
      var backgroundColor: null}) {
          return new TinyFlutterTextObject(text, textureWidth, textureHeight,
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
