part of tinygame;

typedef void TExpansionTapCallback(String id);

class TExpansionTap extends TExpansionBase {
  TExpansionTapCallback callback;
  String name;
  int range = 15;
  TExpansionTap(TinyDisplayObject target, this.name, this.callback) : super(target) {
    ;
  }

  void onChangeStageStatus(TinyStage stage, TinyDisplayObject parent) {}
  void onInit(TinyStage stage) {}
  void onTick(TinyStage stage, int timeStamp) {}
  void onPaint(TinyStage stage, TinyCanvas canvas) {}

  Map<int, double> infoX = {};
  Map<int, double> infoY = {};
  Map<int, bool> infoTap = {};

  bool onTouch(TinyStage stage, int id, TinyStagePointerType type, double globalX, double globalY) {
    //print("${id} ${type} ${infoTap[id]} ${infoTap} ${infoTap.containsKey(id)}");
    switch (type) {
      case TinyStagePointerType.DOWN:
        Vector3 v = stage.getCurrentPositionOnDisplayObject(globalX, globalY);
        infoX[id] = globalX;
        infoY[id] = globalY;
        if(target.checkFocus(v.x, v.y)) {
          infoTap[id] = true;
        } else {
          infoTap[id] = false; 
        }
        break;
      case TinyStagePointerType.MOVE:
        if (infoTap.containsKey(id)) {
          if (infoTap[id] == true && !(-range < infoX[id] && infoX[id] < range) || !(-range < infoY[id] && infoY[id] < range)) {
            infoTap[id] = false;
          }
        }
        break;

      case TinyStagePointerType.UP:
        if (infoTap.containsKey(id)) {
          if (infoTap[id] == true) {
            callback(name);
          }
          infoX.remove(id);
          infoY.remove(id);
          infoTap.remove(id);
        }
        break;
      default:
        infoX.clear();
        infoY.clear();
        infoTap.clear();
        break;
    }
    return false;
  }

  void onTouchStart(TinyStage stage, int id, TinyStagePointerType type, double x, double y) {}
  void onTouchEnd(TinyStage stage, int id, TinyStagePointerType type, double x, double y) {}
  void onUnattach() {}
  void onAttach(TinyStage stage, TinyDisplayObject parent) {}
}
