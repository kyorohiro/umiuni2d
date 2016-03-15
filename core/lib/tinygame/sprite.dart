part of tinygame;

class TinySprite extends TinyDisplayObjectEx {
  TinyImage image;
  double centerX;
  double centerY;

  double _x = 0.0;
  double _y = 0.0;
  double _rotation = 0.0;
  double _scaleX = 1.0;
  double _scaleY = 1.0;

  double get x => _x;
  double get y => _y;
  double get rotation => _rotation;
  double get scaleX => _scaleX;
  double get scaleY => _scaleY;

//
  double get w => image.w * scaleX;
  double get h => image.h * scaleY;
  void updateScaleW(double w, {bool isScaleY: true}) {
    scaleX = w / image.w;
    scaleY = scaleY;
  }

  void updateScaleH(double h, {bool isScaleX: true}) {
    scaleY = h / image.h;
    scaleX = scaleY;
  }

//
  bool _update = true;
  int currentFrameID = 0;
  int get numOfFrameID => _src.length;

  void set x(double v) {
    _x = v;
    _update = true;
  }

  void set y(double v) {
    _y = v;
    _update = true;
  }

  void set rotation(double v) {
    _rotation = v;
    _update = true;
  }

  void set scaleX(double v) {
    _scaleX = v;
    _update = true;
  }

  void set scaleY(double v) {
    _scaleY = v;
    _update = true;
  }

  List<TinyRect> _src = [];
  List<TinyRect> _dst = [];
  List<TinyCanvasTransform> _trans = [];
  TinyPaint _paint;

  TinySprite.simple(this.image, {this.centerX, this.centerY, List<TinyRect> srcs, List<TinyRect> dsts, List<TinyCanvasTransform> transforms}) {
    if (centerX == null) {
      centerX = image.w / 2;
    }
    if (centerY == null) {
      centerY = image.h / 2;
    }
    if (srcs != null && dsts != null && transforms != null && srcs.length == dsts.length && srcs.length == transforms.length && srcs.length > 0) {
      _src.addAll(srcs);
      _dst.addAll(dsts);
      _trans.addAll(transforms);
    } else {
      _src.add(new TinyRect(0.0, 0.0, image.w.toDouble(), image.h.toDouble()));
      _dst.add(new TinyRect(0.0, 0.0, image.w.toDouble(), image.h.toDouble()));
      _trans.add(TinyCanvasTransform.NONE);
    }
    _paint = new TinyPaint();
  }

  void updateMat() {
    if (_update) {
      mat.setIdentity();
      mat.translate(x, y, 0.0);
      mat.scale(scaleX, scaleY, 1.0);
      // mat.translate(centerX, centerY, 0.0);
      mat.rotateZ(rotation);
      mat.translate(-centerX, -centerY, 0.0);
      _update = false;
    }
  }

  bool checkFocus(double localX, double localY) {
    updateMat();
//    print("--${localX}:${localY}, ${image.w}:${image.h}a");
    if (0 < localX && localX < image.w) {
      if (0 < localY && localY < image.h) {
        return true;
      }
    }
    return false;
  }

  void onTick(TinyStage stage, int timeStamp) {
    updateMat();
  }

  void onPaint(TinyStage stage, TinyCanvas canvas) {
    int id = currentFrameID;
    if (id >= _src.length) {
      id = _src.length - 1;
    }
    canvas.drawImageRect(stage, image, _src[id], _dst[id], _paint, transform: _trans[id]);
  }
}
