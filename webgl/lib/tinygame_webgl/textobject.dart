part of tinygame_webgl;

class TinyWebglTextObjcet extends TinyTextObjcet {
  TinyWebglImage bodyText;
  CanvasElement bodyCanvasElm;
  int index = 0;
  TExpansionTapCallback callback;

  TinyWebglTextObjcet(text, textureWidth, textureHeight, {fontSize: 25, isBold: false, isItalic: false, fontFamily: "Century Gothic", fillStyle: null, strokeStyle: null, backgroundColor: null}) : super(text, textureWidth, textureHeight, fontSize: fontSize, isBold: isBold, isItalic: isItalic, fontFamily: fontFamily, fillStyle: fillStyle, strokeStyle: strokeStyle, backgroundColor: backgroundColor) {
    bodyCanvasElm = new CanvasElement(width: textureWidth.toInt(), height: textureHeight.toInt());
    bodyText = new TinyWebglImage(bodyCanvasElm);
  }

  Future updateText() async {
    CanvasElementText.makeImage(text, canvasElm: bodyCanvasElm, width: textureWidth.toInt(), height: textureHeight.toInt(), fontFamily: fontFamily, fontsize: fontSize, isBold: isBold, isItalic: isItalic, fillColor: fillStyle, strokeColor: strokeStyle, align: CanvasElementTextAlign.left_top);
    bodyText.update();
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {
    super.onPaint(stage, canvas);
    canvas.drawImageRect(stage, bodyText, new TinyRect(0.0, 0.0, bodyCanvasElm.width.toDouble(), bodyCanvasElm.height.toDouble()), new TinyRect(0.0, 0.0, bodyCanvasElm.width.toDouble(), bodyCanvasElm.height.toDouble()), new TinyPaint(), transform: TinyCanvasTransform.MIRROR_ROT180);
  }
}
