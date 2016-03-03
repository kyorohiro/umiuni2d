part of tinygame;

class TExpansionTap extends TExpansionBase {
  TExpansionTap(TinyDisplayObject target) : super(target) {
    ;
  }
  void onChangeStageStatus(TinyStage stage, TinyDisplayObject parent) {}
  void onInit(TinyStage stage) {}
  void onTick(TinyStage stage, int timeStamp) {}
  void onPaint(TinyStage stage, TinyCanvas canvas) {}
  bool onTouch(TinyStage stage, int id, TinyStagePointerType type, double globalX, globalY) {
    return false;
  }

  void onTouchStart(TinyStage stage, int id, TinyStagePointerType type, double x, double y) {}
  void onTouchEnd(TinyStage stage, int id, TinyStagePointerType type, double x, double y) {}
  void onUnattach() {}
  void onAttach(TinyStage stage, TinyDisplayObject parent) {}
}
