part of tinygame;

enum TinyStagePointerType { CANCEL, UP, DOWN, MOVE }

abstract class TinyStage {
  double get x;
  double get y;
  double get w;
  double get h;
  double get paddingTop;
  double get paddingBottom;
  double get paddingRight;
  double get paddingLeft;

  bool animeIsStart = false;
  int animeId = 0;
  TinyDisplayObject _root;
  TinyDisplayObject get root => _root;
  void set root(TinyDisplayObject v) {
    _root = v;
  }

  TinyGameBuilder get builder;
  bool startable = false;
  bool isInit = false;

  void start();
  void stop();
  void markPaintshot();
  //

  // todo
  // must to call root.changeStageStatus(this, null);
  void updateSize(double w, double h);
  //
  void kick(int timeStamp) {
    if (isInit == false) {
      _root.init(this);
      isInit = true;
    }
    _root.tick(this, null, timeStamp);
    //markPaint();
  }

  void kickPaint(TinyStage stage, TinyCanvas canvas) {
    canvas.pushMulMatrix(root.mat);
    root.paint(stage, canvas);
    canvas.popMatrix();
  }

  void kickTouch(TinyStage stage, int id, TinyStagePointerType type, double x, double y) {
    stage.pushMulMatrix(root.mat);
    root.touch(stage, null, id, type, x, y);
    stage.popMatrix();
  }

  //
  //
  List<Matrix4> mats = [new Matrix4.identity()];

  pushMulMatrix(Matrix4 mat) {
    mats.add(mats.last * mat);
    //mats.add(mat*mats.last);
  }

  popMatrix() {
    mats.removeLast();
  }

  Matrix4 getMatrix() {
    return mats.last;
  }
  double get xFromMat => this.mats.last.storage[12];
  double get yFromMat => this.mats.last.storage[13];
  double get zFromMat => this.mats.last.storage[14];
  double get sxFromMat =>
    (new Vector3(mats.last.storage[0], mats.last.storage[4], mats.last.storage[8])).length;
  double get syFromMat =>
    (new Vector3(mats.last.storage[1], mats.last.storage[5], mats.last.storage[9])).length;
  double get szFromMat =>
    (new Vector3(mats.last.storage[2], mats.last.storage[6], mats.last.storage[10])).length;
/*
 * call in onTouch
 * TODO remove obj arg;
 */
  Vector3 getCurrentPositionOnDisplayObject(double globalX, double globalY) {
    Matrix4 tmp = getMatrix().clone();
    tmp.invert();
    return tmp * new Vector3(globalX, globalY, 0.0);
  }

  static String toStringPointerType(TinyStagePointerType type) {
    switch (type) {
      case TinyStagePointerType.CANCEL:
        return "pointercancel";
      case TinyStagePointerType.UP:
        return "pointerup";
      case TinyStagePointerType.DOWN:
        return "pointerdown";
      case TinyStagePointerType.MOVE:
        return "pointermove";
      default:
        return "";
    }
  }
}
