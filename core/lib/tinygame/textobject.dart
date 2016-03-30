part of tinygame;

class TinyTextObjcet extends TinyDisplayObjectEx {
  double fontSize;
  bool isBold;
  bool isItalic;
  String fontFamily;
  TinyColor fillStyle;
  TinyColor strokeStyle;
  double height;
  double width;
  TinyColor backgroundColor = null;
  String text;
  TinyTextObjcet(this.text, this.width, this.height, {this.fontSize: 25.0, this.isBold: false, this.isItalic: false, this.fontFamily: "Century Gothic", this.fillStyle: null, this.strokeStyle: null, this.backgroundColor: null}) {
    if (fillStyle == null) {
      fillStyle = TinyColor.black;
    }
    if (strokeStyle == null) {
      strokeStyle = TinyColor.black;
    }

  }

  Future updateLayout() async {
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {
    super.onPaint(stage, canvas);
    if (backgroundColor != null) {
      canvas.drawRect(stage, new TinyRect(0.0, 0.0, width, height), new TinyPaint(color: backgroundColor));
    }
  }
}
