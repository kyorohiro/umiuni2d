part of tinygame_flutter;

class TinyFlutterTextObject extends TinyDisplayObject {
  int fontSize;
  bool isBold;
  bool isItalic;
  String fontFamily;
  TinyColor fillStyle;
  TinyColor strokeStyle;
  double textureHeight;
  double textureWidth;

  TinyColor backgroundColor = null;
  String text;
  TinyFlutterTextObject(this.text, this.textureWidth, this.textureHeight, {this.fontSize: 25, this.isBold: false, this.isItalic: false, this.fontFamily: "Century Gothic", this.fillStyle: null, this.strokeStyle: null, this.backgroundColor: null}) {
    if (fillStyle == null) {
      fillStyle = TinyColor.black;
    }
    if (strokeStyle == null) {
      strokeStyle = TinyColor.black;
    }
  }

  Future updateText() async {
  }


  void onPaint(TinyStage stage, TinyCanvas canvas) {
    //
    if (!(canvas is TinyFlutterCanvas)) {
      return;
    }
    TinyFlutterCanvas fcanvas = canvas;
    Canvas nativeCanvas = fcanvas.canvas;
    Color textColor = const Color.fromARGB(0xaa, 0x33, 0x22, 0x22);
    //TextStyle textStyle = new TextStyle(fontSize: 50.0, color: textColor);
    TextStyle textStyle =
    new TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize.toDouble(),
      fontStyle: (isItalic?FontStyle.italic:FontStyle.normal),
      fontWeight: (isBold?FontWeight.w500:FontWeight.w300),
      color: textColor);
    TextSpan testStyledSpan = new TextSpan(text: "Hello Text!! こんにちは!!", style: textStyle);
    TextPainter textPainter = new TextPainter(testStyledSpan);

    textPainter.maxWidth = textureWidth; //constraints.maxWidth;
    textPainter.minWidth = textureWidth; //constraints.minWidth;
    textPainter.minHeight = textureHeight;
    textPainter.maxHeight = textureHeight;
    textPainter.layout();
    textPainter.paint(nativeCanvas, new sky.Offset(0.0, 0.0));
  }
}
