part of tinygame_webgl;

class TinyWebglStage extends Object with TinyStage {
  TinyWebglContext glContext;
  double get x => 0.0;
  double get y => 0.0;
  double get w => glContext.widht;
  double get h => glContext.height;

  double get paddingTop => 0.0;
  double get paddingBottom => 0.0;
  double get paddingRight => 0.0;
  double get paddingLeft => 0.0;

  int lastUpdateTime = 0;
  int tappedEventTime = 0;
  bool animeIsStart = false;
  int animeId = 0;
  int paintInterval;
  int tickInterval;
  TinyGameBuilder _builder;
  TinyGameBuilder get builder => _builder;

  int countKickMv = 0;
  num prevTime = 0;

  TinyStageBase stageBase;
  TinyWebglStage(this._builder, TinyDisplayObject root, {width: 600.0, height: 400.0, String selectors: null, this.tickInterval: 15, this.paintInterval: 40}) {
    stageBase = new TinyStageBase(this);
    glContext = new TinyWebglContext(width: width, height: height, selectors: selectors);
    this.root = root;
    mouseTest();
    touchTtest();
  }

  // todo
  void updateSize(double w, double h) {
    glContext.widht = w;
    glContext.height = h;
    root.changeStageStatus(this, null);
  }

  int onshot = 0;
  void markPaintshot() {
    if(animeIsStart == true) {
      return;
    }
    if(onshot<=0){
      onshot =1;
      start(oneshot: true);
    } else if(onshot<3) {
      onshot++;
    }

  }

  void init() {}

  void start({oneshot:false}) {
    if(animeIsStart == true) {
      return;
    }
    if (oneshot == false && animeIsStart == false) {
      animeIsStart = true;
    }
    if(_animeIsOn == false) {
      print("A sanimeIsStart ok");
      _anime();
    }
  }

  bool isTMode = false;
  bool _animeIsOn = false;
  TinyCanvas c = null;
  Future _anime() async {
          print("--a1-");
    _animeIsOn = true;
    try {
      double sum = 0.0;
      double sum_a = 0.0;
      int count = 0;

      int interval = tickInterval;
      int prevInterval = tickInterval;
      if (prevTime == null || prevTime == 0) {
        prevTime = new DateTime.now().millisecondsSinceEpoch;
      }
      do {
        //if(animeIsStart)
        {
          int t = tickInterval - (interval - prevInterval);
          if (t < 5) {
            t = 5;
          } else if (t > tickInterval) {
            t = tickInterval;
          }
          prevInterval = t;
          await new Future.delayed(new Duration(milliseconds: t));
          countKickMv = 0;
        }
        num currentTime = new DateTime.now().millisecondsSinceEpoch;
        lastUpdateTime = currentTime;

        interval = (currentTime - prevTime);
        kick((prevTime + interval).toInt());
        sum += interval;
        sum_a += interval;
        count++;
        prevTime = currentTime;
        markPaintshot();
        if (animeIsStart == false || sum_a > paintInterval) {
          new Future(() {
            if(c == null) {
              c = new TinyWebglCanvas(glContext);
            }
            c.clear();
            kickPaint(this, c);
            c.flush();
            //(c as TinyWebglCanvasTS).flushraw();
          });
          sum_a = 0.0;
        }
        if (count > 60) {
          print("###fps  ${1000~/(sum~/count)} ${onshot}");
          sum = 0.0;
          count = 0;
        }
      } while (((--onshot)>=0) || animeIsStart);
    } catch (e) {} finally {
      _animeIsOn = false;
      print("--a-");

    }
  }

  void stop() {
    animeIsStart = false;
  }

  void touchTtest() {
    Map touchs = {};
    oStu(TouchEvent e) {
      e.preventDefault();
      tappedEventTime = lastUpdateTime;
      for (Touch t in e.changedTouches) {
        int x = t.page.x - glContext._canvasElement.offsetLeft;
        int y = t.page.y - glContext._canvasElement.offsetTop;
        if (touchs.containsKey(t.identifier)) {
          countKickMv++;
          //if(countKickMv < 3) {
//          print("MOVE ${touchs}");
          kickTouch(this, t.identifier + 1, TinyStagePointerType.MOVE, x.toDouble(), y.toDouble());
          //}
        } else {
//          print("DOWN ${touchs}");
          touchs[t.identifier] = t;
          kickTouch(this, t.identifier + 1, TinyStagePointerType.DOWN, x.toDouble(), y.toDouble());
        }
      }
    }
    oEnd(TouchEvent e) {
      e.preventDefault();
      tappedEventTime = lastUpdateTime;
      for (Touch t in e.changedTouches) {
        if (touchs.containsKey(t.identifier)) {
          int x = t.page.x - glContext._canvasElement.offsetLeft;
          int y = t.page.y - glContext._canvasElement.offsetTop;
          touchs.remove(t.identifier);
          kickTouch(this, t.identifier + 1, TinyStagePointerType.UP, x.toDouble(), y.toDouble());
        }
      }
    }
    glContext._canvasElement.onTouchCancel.listen(oEnd);
    glContext._canvasElement.onTouchEnd.listen(oEnd);
    glContext._canvasElement.onTouchEnter.listen(oStu);
    glContext._canvasElement.onTouchLeave.listen(oStu);
    glContext._canvasElement.onTouchMove.listen(oStu);
    glContext._canvasElement.onTouchStart.listen(oStu);
  }

  void mouseTest() {
    bool isTap = false;
    glContext.canvasElement.onMouseDown.listen((MouseEvent e) {
      e.preventDefault();
      if (tappedEventTime + 500 < lastUpdateTime) {
        //print("down offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
        //print("down");
        isTap = true;
        kickTouch(this, 0, TinyStagePointerType.DOWN, e.offset.x.toDouble(), e.offset.y.toDouble());
      }
    });
    glContext.canvasElement.onMouseUp.listen((MouseEvent e) {
      e.preventDefault();
      if (tappedEventTime + 500 < lastUpdateTime) {
        //print("up offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
        if (isTap == true) {
          kickTouch(this, 0, TinyStagePointerType.UP, e.offset.x.toDouble(), e.offset.y.toDouble());
          isTap = false;
        }
      }
    });
    glContext.canvasElement.onMouseEnter.listen((MouseEvent e) {
      e.preventDefault();
      if (tappedEventTime + 500 < lastUpdateTime) {
        // print("enter offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
        if (isTap == true) {
          //root.touch(this, 0, "pointercancel", e.offsetX.toDouble(), e.offsetY.toDouble());
        }
      }
    });
    glContext.canvasElement.onMouseLeave.listen((MouseEvent e) {
      e.preventDefault();
      if (tappedEventTime + 500 < lastUpdateTime) {
        //  print("leave offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
        //print("move");
        if (isTap == true) {
          kickTouch(this, 0, TinyStagePointerType.CANCEL, e.offset.x.toDouble(), e.offset.y.toDouble());
          isTap = false;
        }
      }
    });
    glContext.canvasElement.onMouseMove.listen((MouseEvent e) {
      e.preventDefault();
      if (tappedEventTime + 500 < lastUpdateTime) {
        //print("move offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
        if (isTap == true) {
          kickTouch(this, 0, TinyStagePointerType.MOVE, e.offset.x.toDouble(), e.offset.y.toDouble());
        } //else {
        //  kickTouch(this, 0, TinyStagePointerType.DOWN, e.offset.x.toDouble(), e.offset.y.toDouble());
        //  isTap == true;
        //}
      }
    });

    glContext.canvasElement.onMouseOut.listen((MouseEvent e) {
      e.preventDefault();
      if (tappedEventTime + 500 < lastUpdateTime) {
        // print("out offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
        if (isTap == true) {
          kickTouch(this, 0, TinyStagePointerType.CANCEL, e.offset.x.toDouble(), e.offset.y.toDouble());
          isTap = false;
        }
      }
    });

    glContext.canvasElement.onMouseOver.listen((MouseEvent e) {
      e.preventDefault();
      if (tappedEventTime + 500 < lastUpdateTime) {
        // print("over offset=${e.offsetX}:${e.offsetY}  client=${e.clientX}:${e.clientY} screen=${e.screenX}:${e.screenY}");
        if (isTap == true) {
          // root.touch(this, 0, event.type, e.offsetX.toDouble(), e.offsetY.toDouble());
        }
      }
    });
  }



  //
  //
  //
  //
  @override
  TinyDisplayObject get root => stageBase.root;

  @override
  void set root(TinyDisplayObject v) {
    stageBase.root = v;
  }

  @override
  void kick(int timeStamp) {
    stageBase.kick(timeStamp);
  }

  @override
  void kickPaint(TinyStage stage, TinyCanvas canvas) {
    stageBase.kickPaint(stage, canvas);
  }

  @override
  void kickTouch(TinyStage stage, int id, TinyStagePointerType type, double x, double y) {
    stageBase.kickTouch(stage, id, type, x, y);
  }

  @override
  List<Matrix4> get mats => stageBase.mats;

  @override
  pushMulMatrix(Matrix4 mat) {
    return stageBase.pushMulMatrix(mat);
  }

  @override
  popMatrix() {
    return stageBase.popMatrix();
  }

  @override
  Matrix4 getMatrix() {
    return stageBase.getMatrix();
  }

  @override
  double get xFromMat => stageBase.xFromMat;

  @override
  double get yFromMat => stageBase.yFromMat;

  @override
  double get zFromMat => stageBase.zFromMat;

  @override
  double get sxFromMat => stageBase.sxFromMat;

  @override
  double get syFromMat => stageBase.syFromMat;

  @override
  double get szFromMat => stageBase.szFromMat;

  @override
  Vector3 getCurrentPositionOnDisplayObject(double globalX, double globalY) {
    return stageBase.getCurrentPositionOnDisplayObject(globalX, globalY);
  }
}
