part of tinygame;


enum TinyPaintStyle { fill, stroke }

class TinyPaint {
  TinyColor color;
  TinyPaintStyle style = TinyPaintStyle.fill;
  double strokeWidth = 1.0;
  TinyPaint({this.color}) {
    if (this.color == null) {
      color = new TinyColor.argb(0xff, 0xff, 0xff, 0xff);
    }
  }
}
