part of tinygame_webgl;

class TinyWebglTextObjcet extends TinyDisplayObjectEx {
  TinyWebglImage bodyText;
  CanvasElement bodyCanvasElm;
  int index = 0;
  TExpansionTapCallback callback;

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
  TinyWebglTextObjcet(this.text, this.textureWidth, this.textureHeight, {this.fontSize: 25, this.isBold: false, this.isItalic: false, this.fontFamily: "Century Gothic", this.fillStyle: null, this.strokeStyle: null, this.backgroundColor: null}) {
    if (fillStyle == null) {
      fillStyle = TinyColor.black;
    }
    if (strokeStyle == null) {
      strokeStyle = TinyColor.black;
    }

    bodyCanvasElm = new CanvasElement(width: textureWidth.toInt(), height: textureHeight.toInt());
    bodyText = new TinyWebglImage(bodyCanvasElm);
  }

  Future updateText() async {
    CanvasElementText.makeImage(text, canvasElm: bodyCanvasElm, width: textureWidth.toInt(), height: textureHeight.toInt(), fontFamily: fontFamily,fontsize: fontSize, isBold: isBold, isItalic: isItalic, fillColor: fillStyle, strokeColor: strokeStyle, align: CanvasElementTextAlign.left_top);
    bodyText.update();
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {
    super.onPaint(stage, canvas);
    if (backgroundColor != null) {
      canvas.drawRect(stage, new TinyRect(0.0, 0.0, textureWidth, textureHeight), new TinyPaint(color: backgroundColor));
    }
    canvas.drawImageRect(stage, bodyText, new TinyRect(0.0, 0.0, bodyCanvasElm.width.toDouble(), bodyCanvasElm.height.toDouble()), new TinyRect(0.0, 0.0, bodyCanvasElm.width.toDouble(), bodyCanvasElm.height.toDouble()), new TinyPaint(), transform: TinyCanvasTransform.MIRROR_ROT180);
  }
}
