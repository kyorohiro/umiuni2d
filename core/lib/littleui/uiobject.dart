part of littleui;

typedef LittleUIPaintFunc(TinyStage stage, TinyCanvas canvas);

class LittleUIObject extends TinyDisplayObjectEx {
  List<LittleUIPaintFunc> func = [];
  double w = 0.0;
  double h = 0.0;
  bool isFullWidth;
  bool isFullHeight;
  TinyColor backgroundColor;

  //StreamController c = null;

  LittleUIObject(this.w, this.h, {this.backgroundColor:null, this.isFullWidth: false, this.isFullHeight: false}) {
    if(this.backgroundColor == null) {
      backgroundColor = new TinyColor.argb(0xff, 0xee, 0xff, 0xee);
    }
  }

  void onAttach(TinyStage stage, TinyDisplayObject parent) {
    onChangeStageStatus(stage, parent);
  }

  void onChangeStageStatus(TinyStage stage, TinyDisplayObject parent) {
    double tw = w;
    double th = h;
    //print("###### ${isFullWidth} ${isFullHeight}");
    if (isFullWidth) {
      w = ((parent == null || false == parent is LittleUIObject) ? stage.w : (parent as LittleUIObject).w);
    }
    if (isFullHeight) {
      h = ((parent == null || false == parent is LittleUIObject) ? stage.h : (parent as LittleUIObject).h);
    }
    if (isFullHeight || isFullWidth) {
      if (tw != w || th != h) {
        changeStatus(parent);
        stage.markPaintshot();
      }
    }
  }

  void onChangeStatus(TinyDisplayObject parent) {}

  void changeStatus(TinyDisplayObject parent) {
    onChangeStatus(parent);
    for (TinyDisplayObject d in child) {
      if (d is LittleUIObject) {
        d.changeStatus(this);
      }
    }
  }

  void onTick(TinyStage stage, int timeStamp) {}

  void onPaint(TinyStage stage, TinyCanvas canvas) {
    TinyPaint p = new TinyPaint(color:backgroundColor);
    canvas.drawRect(stage, new TinyRect(0.0, 0.0, w, h), p);
  }

  bool checkFocus(double localX, double localY) {
    return (0<localX && localX< w && 0 < localY && localY < h );
  }
}
