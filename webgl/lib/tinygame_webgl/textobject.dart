part of tinygame_webgl;

class TinyWebglTextObjcet extends TinyTextObjcet {
  TinyWebglImage bodyText;
  CanvasElement bodyCanvasElm;
  int index = 0;
  TExpansionTapCallback callback;
  double magnufication = 1.50;

  TinyWebglTextObjcet(text, textureWidth, textureHeight, {fontSize: 25, isBold: false, isItalic: false, fontFamily: "Century Gothic", fillColor: null, strokeColor: null, backgroundColor: null}) : super(text, textureWidth, textureHeight, fontSize: fontSize, isBold: isBold, isItalic: isItalic, fontFamily: fontFamily, fillStyle: fillColor, strokeStyle: strokeColor, backgroundColor: backgroundColor) {
    bodyCanvasElm = new CanvasElement(width: textureWidth.toInt(), height: textureHeight.toInt());
    bodyText = new TinyWebglImage(bodyCanvasElm);
  }

  Future updateText() async {
    CanvasElementText.makeImage(text, canvasElm: bodyCanvasElm,
      width: (textureWidth*magnufication).toInt(), height: (textureHeight*magnufication).toInt(),
      fontFamily: fontFamily, fontsize: (fontSize*magnufication),
      isBold: isBold, isItalic: isItalic, fillColor: fillStyle, strokeColor: strokeStyle, align: CanvasElementTextAlign.left_top);
    bodyText.update();
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {
    super.onPaint(stage, canvas);
    if(stage is TinyWebglStage) {
      double sx = stage.sxFromMat;
      if(magnufication != sx) {
        print(":: ${magnufication} = ${sx}");
        magnufication = sx;
        updateText().then((_){
          stage.markPaintshot();
        });
      }
    //  CanvasElement elm = (stage as TinyWebglStage).glContext._canvasElement;
    //  double t = elm.height / elm.offsetHeight;
    }
    canvas.drawImageRect(stage, bodyText,
       new TinyRect(0.0, 0.0, textureWidth*magnufication, textureHeight*magnufication),
       new TinyRect(0.0, 0.0, textureWidth, textureHeight),
       new TinyPaint(), transform: TinyCanvasTransform.MIRROR_ROT180);
  }
}
