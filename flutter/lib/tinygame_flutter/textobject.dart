part of tinygame_flutter;

class TinyFlutterTextObject extends TinyTextObjcet {

  TinyFlutterTextObject(
    text, textureWidth, textureHeight,
    {fontSize: 25, isBold: false, isItalic: false,
     fontFamily: "Century Gothic", fillColor: null,
     strokeColor: null, backgroundColor: null}):
     super(text, textureWidth, textureHeight,
          fontSize: fontSize, isBold: isBold, isItalic: isItalic,
          fontFamily: fontFamily, fillStyle: fillColor,
          strokeStyle: strokeColor, backgroundColor: backgroundColor) {
            ;
  }

  @override
  Future updateText() async {
  }

  @override
  void onPaint(TinyStage stage, TinyCanvas canvas) {
    //
    super.onPaint(stage, canvas);
    if (!(canvas is TinyFlutterCanvas)) {
      return;
    }
    TinyFlutterCanvas fcanvas = canvas;
    Canvas nativeCanvas = fcanvas.canvas;
    Color textColor = new Color.fromARGB(fillStyle.a, fillStyle.r, fillStyle.g, fillStyle.b);
    //TextStyle textStyle = new TextStyle(fontSize: 50.0, color: textColor);
    TextStyle textStyle =
    new TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize.toDouble(),
      fontStyle: (isItalic?FontStyle.italic:FontStyle.normal),
      fontWeight: (isBold?FontWeight.w500:FontWeight.w300),
      color: textColor);
    TextSpan testStyledSpan = new TextSpan(text: text, style: textStyle);
    TextPainter textPainter = new TextPainter(testStyledSpan);

    textPainter.maxWidth = textureWidth; //constraints.maxWidth;
    textPainter.minWidth = textureWidth; //constraints.minWidth;
    textPainter.minHeight = textureHeight;
    textPainter.maxHeight = textureHeight;

    textPainter.layout();
    textPainter.paint(nativeCanvas, new sky.Offset(0.0, 0.0));
  }
}
