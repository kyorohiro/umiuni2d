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

class LittleUIScrollerInnerInfo {
  bool isPush = false;
  double prevY = 0.0;
  double prevX = 0.0;
}

class LittleUIScroller extends LittleUIObject {
  TinyGameBuilder builder;
  LittleUIScrollerInfo info;
  int head = 0;
  int tail = 0;
  double spring = 0.1;
  double springOrientation = 0.01;
  double braking = 0.95;
  LittleUIObject body;
  LittleUIObject topLayer;
  LittleUIScroller(this.builder, this.info, {
    double width: 100.0, double height: 100.0, isFullWidth: true, isFullHeight: true,
    this.springOrientation: 0.9}) : super(width, height, isFullWidth: isFullWidth, isFullHeight: isFullHeight) {
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

  //bool isPush = false;
  //double prevY = 0.0;
  //double speedY = 0.0;
  Map<int, LittleUIScrollerInnerInfo> infos = {};
  LittleUIScrollerInnerInfo getInfo(int id) {
    if (false == infos.containsKey(id)) {
      infos[id] = new LittleUIScrollerInnerInfo();
    }
    return infos[id];
  }

  inRange(TinyStage stage, double globalX, double globalY) {
    Vector3 v = stage.getCurrentPositionOnDisplayObject(globalX, globalY);
    if (0 < v.x && v.x < w && 0 < v.y && v.y < h) {
      return true;
    } else {
      return false;
    }
  }

  double speedY = 0.0;
  double speedX = 0.0;

  bool brake(int curr, int prev) {
    double late = 1.0;
    if (prev != 0 && curr != prev) {
      late = (curr - prev) / 10;
    }
    if (late > 3.0) {
      late = 1.0;
    }
    bool needUpdata = false;
    if ((-1.0 > speedY || speedY > 1.0)) {
      if (speedY > 0) {
        speedY *= braking;
      } else {
        speedY *= braking;
      }

      body.mat.translate(0.0, -1 * speedY, 0.0);
      needUpdata = true;
    }
    if ((-1.0 > speedX || speedX > 1.0)) {
      if (speedX > 0) {
        speedX *= braking;
      } else {
        speedX *= braking;
      }

      body.mat.translate(-1 * speedX, 0.0, 0.0);
      needUpdata = true;
    }
    return needUpdata;
  }

  bool bounce(int curr, int prev) {
    double late = 1.0;
    if (prev != 0 && curr != prev) {
      late = (curr - prev) / 10;
    }
    if (late > 3.0) {
      late = 1.0;
    }
    //  print("##bounced ${info.top} ${info.bottom} ${body.y} ${body.h} ${curr} ${prev} ${late} ${(curr-prev)}");
    bool isResetSpeed = false;
    if (this.body.y > info.top + 1) {
      body.mat.translate(0.0, -1 * (this.body.y - info.top) * spring * late, 0.0);
      isResetSpeed = true;
    } else {
      double d = info.bottom;
      if (this.body.h > (info.bottom - info.top)) {
        d = body.h;
      }
      //
      if ((-1 * this.body.y + this.body.h) > d + 1) {
        body.mat.translate(0.0, -1 * (d - (-1 * this.body.y + this.body.h)) * spring * late, 0.0);
        isResetSpeed = true;
      }
    }
    if (isResetSpeed) {
      speedY = 0.0;
    }
    //
    double r = (info.right > this.body.w?info.right:this.body.w);
    if (-1*this.body.x < info.left) {
      body.mat.translate((info.left-this.body.x)*springOrientation, 0.0, 0.0);
      isResetSpeed = true;
    } else if((-1*this.body.x+this.body.w) > r) {
      body.mat.translate(1 * ((-1*this.body.x+this.body.w)- r)*springOrientation, 0.0, 0.0);
      isResetSpeed = true;
    }
    if (isResetSpeed) {
      speedX = 0.0;
    }
    return isResetSpeed;
  }

  int prevTime = 0;
  void onTick(TinyStage stage, int timeStamp) {
    //      print("#--#${speedY} ${infos.length}");
    bool needUpdata = false;
    if (infos.length != 0) {
      return;
    }

    //
    if (prevTime == 0) {
      prevTime = timeStamp;
    }
    needUpdata = needUpdata || bounce(timeStamp, prevTime);
    needUpdata = needUpdata || brake(timeStamp, prevTime);
    prevTime = timeStamp;
    if (needUpdata) {
      //
      //
      info.updateInRange(this.body, this.topLayer, this.body.x, this.body.y, this.body.x + this.w, this.body.y - this.h);

      new Future(() {
        //print("#++#${speedY} ${infos.length}");
        stage.markPaintshot();
      });
    }
  }

  redesign() {
    for (int i = 0; i < 3; i++) {
      info.updateInRange(this.body, this.topLayer, this.body.x, this.body.y, this.body.x + this.w, this.body.y - this.h);
    }
  }

  bool onTouch(TinyStage stage, int id, TinyStagePointerType type, double globalX, double globalY) {
    //print("${this.body.y}+${this.body.h} > ${info.bottom}");
    //  print("======================XXXX ${y} ${speedY} ${isPush}");
    switch (type) {
      case TinyStagePointerType.DOWN:
        if (true == inRange(stage, globalX, globalY)) {
          LittleUIScrollerInnerInfo i = getInfo(id);
          i.isPush = true;
          i.prevY = globalY;
          i.prevX = globalX;
          stage.markPaintshot();
        }
        break;
      case TinyStagePointerType.UP:
        LittleUIScrollerInnerInfo i = getInfo(id);
        i.isPush = false;
        stage.markPaintshot();
        infos.remove(id);
        break;
      case TinyStagePointerType.MOVE:
        LittleUIScrollerInnerInfo i = getInfo(id);
        if (i.isPush == true) {
          if (false == inRange(stage, globalX, globalY)) {
            i.isPush = false;
            stage.markPaintshot();
            return false;
          }
          //
          //
          //if (!(-1 * this.body.y + this.body.h*1 > info.bottom && (i.prevY - globalY) > 0)) {
          if (this.body.y > info.top && (i.prevY - globalY) < 0) {
            body.mat.translate(0.0, -1 * (i.prevY - globalY) / 3, 0.0);
          } else if (-1 * this.body.y + this.body.h * 1 > info.bottom) {
            body.mat.translate(0.0, -1 * (i.prevY - globalY) / 3, 0.0);
          } else {
            //  print("---------${i.prevY} - ${globalY}");
            body.mat.translate(0.0, -1 * (i.prevY - globalY), 0.0);
            info.updateInRange(this.body, this.topLayer, this.body.x, this.body.y, this.body.x + this.w, this.body.y - this.h);
          }
          //}
          //
          if (speedY == 999.0) {
            speedY = i.prevY - globalY;
          } else {
            speedY = (i.prevY - globalY) - speedY;
          }

          //
          //
          {
            if ((-1*this.body.x) < info.left) {
              body.mat.translate(-1 * (i.prevX - globalX)*(1.0-springOrientation), 0.0, 0.0);
            }
            else if ( (-1*this.body.x+this.body.w) > info.right) {
              body.mat.translate(-1 * (i.prevX - globalX)*(1.0-springOrientation), 0.0, 0.0);
            }
            else {
              body.mat.translate(-1 * (i.prevX - globalX), 0.0, 0.0);
            }
            //print("##># ${this.body.x} < ${info.left}");
            //print("##># ${this.body.x} + ${this.body.w} > ${info.right}");

            info.updateInRange(
              this.body, this.topLayer, this.body.x, this.body.y, this.body.x + this.w, this.body.y - this.h);
          }
          //
          //
          if (speedX == 999.0) {
            speedX = i.prevX - globalX;
          } else {
            speedX = (i.prevX - globalX) - speedX;
          }

          stage.markPaintshot();
          i.prevY = globalY;
          i.prevX = globalX;
        }
        break;
      case TinyStagePointerType.CANCEL:
//        LittleUIScrollerInnerInfo i = getInfo(id);
//        isPush = false;
        infos.clear();
        stage.markPaintshot();
        break;
    }
//    mat.translate(x);
    return false;
  }
}
