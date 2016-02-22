part of tinygame;

//typedef LittleUIPaintFunc (TinyStage stage, TinyCanvas canvas);

class TinyDisplayObjectEx extends TinyDisplayObject {
  List<TExpansionBase> extensions = [];
  addExtension(TExpansionBase ex) {
    extensions.add(ex);
  }

  removeExtension(TExpansionBase ex){
    extensions.remove(ex);
  }

  clearExtension() {
    extensions.clear();
  }

  @override
  void onChangeStageStatus(TinyStage stage, TinyDisplayObject parent) {
    for(TExpansionBase b in extensions) {
      b.onChangeStageStatus(stage, parent);
    }
  }

  @override
  void onInit(TinyStage stage) {
    for(TExpansionBase b in extensions) {
      b.onInit(stage);
    }
  }

  @override
  void onTick(TinyStage stage, int timeStamp) {
    for(TExpansionBase b in extensions) {
      b.onTick(stage, timeStamp);
    }
  }

  @override
  void onPaint(TinyStage stage, TinyCanvas canvas){
    for(TExpansionBase b in extensions) {
      b.onPaint(stage, canvas);
    }
  }

  @override
  bool onTouch(TinyStage stage, int id, TinyStagePointerType type, double globalX, globalY){
    bool ret = false;
    for(TExpansionBase b in extensions) {
      ret = ret ||  b.onTouch(stage, id, type, globalX, globalY);
    }
    return ret;
  }

  @override
  void onTouchStart(TinyStage stage, int id, TinyStagePointerType type, double x, double y){
    for(TExpansionBase b in extensions) {
      b.onTouchStart(stage, id, type, x, y);
    }
  }

  @override
  void onTouchEnd(TinyStage stage, int id, TinyStagePointerType type, double x, double y){
    for(TExpansionBase b in extensions) {
      b.onTouchEnd(stage, id, type, x, y);
    }
  }

  @override
  void onUnattach() {
    for(TExpansionBase b in extensions) {
      b.onUnattach();
    }
  }

  @override
  void onAttach(TinyStage stage, TinyDisplayObject parent) {
    for(TExpansionBase b in extensions) {
      b.onAttach(stage, parent);
    }
  }
}
