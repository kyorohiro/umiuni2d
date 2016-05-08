part of tinygame_flutter;

class TinyFlutterStage extends RenderConstrainedBox implements TinyStage {
  TinyStageBase stageBase;
  TinyFlutterStage(this._builder, TinyDisplayObject root,
    { this.tickInPerFrame: true, this.useTestCanvas: false,
      this.useDrawVertexForPrimtive: false, this.tickInterval: 15}
    ) : super(additionalConstraints: const BoxConstraints.expand())
      {
    stageBase = new TinyStageBase(this);
    this.root = root;
    this.canvas = null;
    init();
  }

  @override
  double get x => paintBounds.left;

  @override
  double get y => paintBounds.top;

  @override
  double get w => paintBounds.width;

  @override
  double get h => paintBounds.height;

  @override
  double get paddingTop => sky.window.padding.top;

  @override
  double get paddingBottom => sky.window.padding.bottom;

  @override
  double get paddingRight => sky.window.padding.right;

  @override
  double get paddingLeft => sky.window.padding.left;

  @override
  bool animeIsStart = false;

  @override
  int animeId = 0;

  @override
  bool startable = false;

  @override
  bool isInit = false;

  static const int kMaxOfTouch = 5;
  Map<int, TouchPoint> touchPoints = {};

  TinyGameBuilder _builder;

  @override
  TinyGameBuilder get builder => _builder;
  TinyCanvas canvas;
  bool useTestCanvas = false; // use drawVertex
  bool tickInPerFrame;
  bool useDrawVertexForPrimtive;
  int tickInterval;


  void init() {}

  @override
  void updateSize(double w, double h) {
    root.changeStageStatus(this, null);
  }

  @override
  void start() {
    print("##useTestCanvas ${useTestCanvas}");
    if (animeIsStart == true) {
      return;
    }
    animeIsStart = true;
    isInit = false;
    kickPaintTick();
  }

  void kickPaintTick() {
    if (tickInPerFrame == true) {
    //  print("-tickPaint--${tickInPerFrame}");
      animeId = SchedulerBinding.instance.scheduleFrameCallback(_innerTick);
    } else {
      _innerTickWithOwn();
    }
    //    Scheduler.instance.addPersistentFrameCallback(_innerTick);
  }

/*
  void markPaintshot() {
    if (animeIsStart != true) {
      this.markNeedsPaint();
      kickPaintTick();
//      _innerTickWithOwn();
      int a2 = new DateTime.now().millisecondsSinceEpoch;
      _innerTick(new Duration(milliseconds: new DateTime.now().millisecondsSinceEpoch));

    }
  }
  */
 int onshot = 0;

 @override
 void markPaintshot() {
   if(animeIsStart == true ) {
    return;
   }
   if (onshot == 0) {
      ///    print("->>>>- ${onshot}");
     onshot += 1;
     _markPaintshot();
   } else if (onshot < 3) {
     //print("->>>>- ${onshot}");
     onshot += 1;
   }
 }

 _markPaintshot() async {

   try {
     for (;animeIsStart != true && onshot >= 0;onshot--) {
       this.markNeedsPaint();
       kickPaintTick();
       int a2 = new DateTime.now().millisecondsSinceEpoch;
            //   print("---sssssssssssasdfasdfasdfasdfasdf# ${onshot}#");
       _innerTick(new Duration(milliseconds: new DateTime.now().millisecondsSinceEpoch));
       await new Future.delayed(new Duration(milliseconds: 20));
     }
   } finally {
     onshot = 0;
      //  print("---ZZZZZZZZZZss\n----SSSSZZZZZZZZS");
   }
 }

  _innerTickWithOwn() async {
    int a1 = new DateTime.now().millisecondsSinceEpoch;
    do {
      int a2 = new DateTime.now().millisecondsSinceEpoch;
      _innerTick(new Duration(milliseconds: new DateTime.now().millisecondsSinceEpoch));
      int t = this.tickInterval + (this.tickInterval - (a2 - a1));

      if (t < 5) {
        t = 5;
      } else if (t > this.tickInterval) {
        t = this.tickInterval;
      }
      //print("## ${t} ${(a2-a1)}");
      a1 = a2;
      await new Future.delayed(new Duration(milliseconds: t));
    } while (animeIsStart == true);
  }

  int timeCount = 0;
  int timeEpoc = 0;
  void _innerTick(Duration timeStamp) {
    //print("-tick----${timeStamp}");
    if (timeEpoc == 0) {
      timeEpoc = timeStamp.inMilliseconds;
      timeCount = 0;
    }
    if (timeCount > 60) {
      int cTimeEpoc = timeStamp.inMilliseconds;
      //print("fps[A]? : ${cTimeEpoc} ${timeEpoc} ${timeCount}");
      if (cTimeEpoc - timeEpoc != 0) {
        print("fps[A]? : ${1000~/((cTimeEpoc-timeEpoc)/timeCount)} ${timeCount} ${(cTimeEpoc-timeEpoc)/timeCount}");
      }
      timeCount = 0;
      timeEpoc = cTimeEpoc;
    }
    timeCount++;
    // TODO
    if (startable) {
      kick(timeStamp.inMilliseconds);
    }
    this.markNeedsPaint();
    if (animeIsStart == true && tickInPerFrame == true) {
      //print("-------------asdfasdfasdfasdfasd");
      animeId = SchedulerBinding.instance.scheduleFrameCallback(_innerTick);
    } else {
//      print("============\n adsf \n ==============");
    }
  }

  @override
  void stop() {
    if (animeIsStart == true) {
      SchedulerBinding.instance.cancelFrameCallbackWithId(animeId);
    }
    animeIsStart = false;
  }

  @override
  void performLayout() {
    size = constraints.biggest;
    startable = true;
  }
/*
  @override
  bool hitTest(HitTestResult result, {Point position}) {
    result.add(new BoxHitTestEntry(this, position));
    return true;
  }
*/
@override
bool hitTestSelf(Point position) => true;
  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    if (this.canvas == null) {
      if (this.useTestCanvas == true) {
        this.canvas = new TinyFlutterCanvas(context.canvas);
      } else {
        this.canvas = new TinyFlutterNCanvas(context.canvas, useDrawVertexForPrimtive: useDrawVertexForPrimtive);
      }
    }

    if (this.useTestCanvas == true) {
      (this.canvas as TinyFlutterCanvas).canvas = context.canvas;
    } else {
      (this.canvas as TinyFlutterNCanvas).canvas = context.canvas;
    }
    //context.canvas.save();
    this.canvas.clear();
    kickPaint(this, this.canvas);
    this.canvas.flush();

  }

  TinyStagePointerType toEvent(PointerEvent e) {
    if (e is PointerUpEvent) {
      return TinyStagePointerType.UP;
    } else if (e is PointerDownEvent) {
      return TinyStagePointerType.DOWN;
    } else if (e is PointerCancelEvent) {
      return TinyStagePointerType.CANCEL;
    } else if (e is PointerMoveEvent) {
      return TinyStagePointerType.MOVE;
    } else if (e is PointerUpEvent) {
      return TinyStagePointerType.UP;
    } else {
      return TinyStagePointerType.CANCEL;
    }
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry en) {
    if (!(event is PointerEvent || !(en is BoxHitTestEntry))) {
      return;
    }

    BoxHitTestEntry entry = en;
    PointerEvent e = event;
    if (!touchPoints.containsKey(e.pointer)) {
      touchPoints[e.pointer] = new TouchPoint(-1.0, -1.0);
    }

//"pointerdown"
    if (event is PointerDownEvent) {
      touchPoints[e.pointer].x = entry.localPosition.x;
      touchPoints[e.pointer].y = entry.localPosition.y;
    } else {
      touchPoints[e.pointer].x = e.position.x;
      touchPoints[e.pointer].y = e.position.y;
    }
    //print("#### ${toEvent(event)} ${touchPoints[e.pointer].x}, ${touchPoints[e.pointer].y}");
    kickTouch(this, e.pointer, toEvent(event), touchPoints[e.pointer].x, touchPoints[e.pointer].y);

//== "pointerup"
    if (event is PointerUpEvent) {
      touchPoints.remove(e.pointer);
    }
//"pointercancel"
    if (event is PointerCancelEvent) {
      touchPoints.clear();
    }
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

class TouchPoint {
  double x;
  double y;
  TouchPoint(this.x, this.y) {
    ;
  }
}
