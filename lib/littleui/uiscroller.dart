part of littleui;

abstract class LittleUIScrollerInfo {
  double get top;
  double get left;
  double get right;
  double get bottom;
  //LittleUIObject getIndex(int i);
  void onAttach(LittleUIScroller parent);
  void updateInRange(TinyDisplayObject body, TinyDisplayObject topLayer, double left, double top, double right, double bottom);
}

class LittleUIScroller extends LittleUIObject {
  TinyGameBuilder builder;
  LittleUIScrollerInfo info;
  int head = 0;
  int tail = 0;
  LittleUIObject body;
  LittleUIObject topLayer;
  LittleUIScroller(this.builder, this.info, {double width: 100.0, double height: 100.0, isFullWidth: true, isFullHeight: true}) : super(width, height, isFullWidth: isFullWidth, isFullHeight: isFullHeight) {
    body = new LittleUIObject(w, h, isFullWidth: true, isFullHeight: true);
    topLayer = new LittleUIObject(w, h, isFullWidth: true, isFullHeight: true);
    body.backgroundColor = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    topLayer.backgroundColor = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    addChild(body);
    addChild(topLayer);
//    this.backgroundColor = new TinyColor.argb(0x00, 0xff, 0xff, 0xff);
    //new Future((){
    this.info.onAttach(this);
    //});
  }

  int i = 0;
  void onPaint(TinyStage stage, TinyCanvas canvas) {
    TinyPaint p = new TinyPaint(color: this.backgroundColor);
    canvas.drawRect(stage, new TinyRect(0.0, 0.0, w, h), p);
  }

  bool isPush = false;
  double prevY = 0.0;
  double speedY = 0.0;

  inRange(TinyStage stage, double globalX, double globalY) {
    Vector3 v = stage.getCurrentPositionOnDisplayObject(globalX, globalY);
    if (0 < v.x && v.x < w && 0 < v.y && v.y < h) {
      return true;
    } else {
      return false;
    }
  }

  void onTick(TinyStage stage, int timeStamp) {
    //print("======================ZZZZ ${y} ${speedY} ${isPush}");
    if (isPush == false && speedY != 999.0 && (-1.0 > speedY || speedY > 1.0)) {
      if (speedY > 0) {
        speedY *= 0.85;
      } else {
        speedY *= 0.85;
      }

      if (!(-1 * this.body.y + this.body.h / 2 > info.bottom && speedY > 0)) {
        if (!(this.body.y > info.top && speedY < 0)) {
          body.mat.translate(0.0, -1 * speedY, 0.0);
        }
      }
      //
      if (this.body.y > info.top && speedY < 0) {
        body.mat.translate(0.0, -1 * (this.body.y - info.top) / 10, 0.0);
      }

      //
      //
      info.updateInRange(this.body, this.topLayer, this.body.x, this.body.y, this.body.x + this.w, this.body.y - this.h);

      new Future(() {
        stage.markPaintshot();
      });
    }
  }

  bool onTouch(TinyStage stage, int id, TinyStagePointerType type, double globalX, double globalY) {
    //  print("======================XXXX ${y} ${speedY} ${isPush}");
    switch (type) {
      case TinyStagePointerType.DOWN:
        if (true == inRange(stage, globalX, globalY)) {
          isPush = true;
          prevY = globalY;
          speedY = 999.0;
          stage.markPaintshot();
        }
        break;
      case TinyStagePointerType.UP:
        isPush = false;
        stage.markPaintshot();
        break;
      case TinyStagePointerType.MOVE:
        if (isPush == true) {
          if (false == inRange(stage, globalX, globalY)) {
            isPush = false;
            stage.markPaintshot();
          } else {
            if (!(-1 * this.body.y + this.body.h / 2 > info.bottom && (prevY - globalY) > 0)) {
              if (!(this.body.y > info.top && (prevY - globalY) < 0)) {
                body.mat.translate(0.0, -1 * (prevY - globalY), 0.0);
              }
            }
            if (speedY == 999.0) {
              speedY = prevY - globalY;
            } else {
              speedY = (prevY - globalY) - speedY;
            }
            stage.markPaintshot();
            prevY = globalY;
          }
        }
        break;
      case TinyStagePointerType.CANCEL:
        isPush = false;
        stage.markPaintshot();
        break;
    }
//    mat.translate(x);
    return false;
  }
}
