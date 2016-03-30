part of tinygame_flutter;



class TinyFlutterImage implements TinyImage {
  ImageInfo rawImage;
  TinyFlutterImage(this.rawImage) {
    ;
  }
  @override
  int get w => rawImage.image.width;

  @override
  int get h => rawImage.image.height;

  @override
  void dispose() {;}
}

class ResourceLoader {
  static AssetBundle getAssetBundle() {
    if (rootBundle != null) {
      return rootBundle;
    } else {
      return new NetworkAssetBundle(new Uri.directory(Uri.base.origin));
    }
  }

  static Future<ImageInfo> loadImage(String url) async {
    AssetBundle bundle = getAssetBundle();
    ImageResource resource = bundle.loadImage(url);
    return resource.first;
  }

  static Future<String> loadString(String url) async {
    AssetBundle bundle = getAssetBundle();
    String b = await bundle.loadString(url);
    //print("-a-${url} -- ${b}");
    return b;
  }

  // TODO
  static Future<data.Uint8List> loadBytes(String url) async {
    AssetBundle bundle = getAssetBundle();
    MojoDataPipeConsumer b = await bundle.load(url);
    data.ByteData d1 = await DataPipeDrainer.drainHandle(b);
    //print("-a-${url} -- ${b}");
    return d1.buffer.asUint8List();//b;
  }

  static Future<MojoDataPipeConsumer> loadMojoData(String url) async {
    AssetBundle bundle = getAssetBundle();
    return await bundle.load(url);
  }
}
