part of tinygame;

typedef void TExpansionButtonCallback(String id);
typedef bool TExpansionButtonCheckFocus(double localX, double localY);

class TExpansionButton extends TExpansionBase {
  bool isTouch = false;
  bool isFocus = false;
  // if release joystickm input ture;
  bool registerUp = false;
  // if down joystickm input ture;
  bool registerDown = false;
  bool exclusiveTouch;
  String buttonName;
  TExpansionButtonCallback onTouchCallback;
  TExpansionButtonCheckFocus handleCheckFocus;



  TExpansionButton(TinyDisplayObject target, this.buttonName,this.onTouchCallback,
    {this.exclusiveTouch:true, this.handleCheckFocus:null}): super(target){
  }

  bool checkFocus(double localX, double localY) {
    if(handleCheckFocus == null) {
      return target.checkFocus(localX, localY);
    } else {
      return handleCheckFocus(localX, localY);
    }
  }

  bool onTouch(TinyStage stage, int id, TinyStagePointerType type, double globalX, globalY){
    Vector3 v = stage.getCurrentPositionOnDisplayObject(globalX, globalY);
    double x = v.x;
    double y = v.y;
    //print("########## (${x},${y})   (${globalX},${globalY} ${target.mat.storage[12]} ${target.mat.storage[13]})");
    bool ret = false;
    switch (type) {
      case TinyStagePointerType.DOWN:
        if (checkFocus(x, y)) {
          ret = true;
          isTouch = true;
          isFocus = true;
          registerDown = true;
        }
        break;
      case TinyStagePointerType.MOVE:
        if (checkFocus(x, y)) {
          ret = true;
          isFocus = true;
        } else {
          isTouch = false;
          isFocus = false;
          registerUp = true;
        }
        break;
      case TinyStagePointerType.UP:
        if (isTouch == true && onTouchCallback != null) {
          registerUp = true;
          new Future(() {
            onTouchCallback(buttonName);
          });
        }
        isTouch = false;
        isFocus = false;
        break;
      default:
        isTouch = false;
        isFocus = false;
    }
    if (exclusiveTouch == true) {
      return ret;
    } else {
      return false;
    }
  }

}

class TExpansionBase {
  TinyDisplayObject target;
  TExpansionBase(this.target) {
    ;
  }
  void onChangeStageStatus(TinyStage stage, TinyDisplayObject parent) {}
  void onInit(TinyStage stage) {}
  void onTick(TinyStage stage, int timeStamp) {}
  void onPaint(TinyStage stage, TinyCanvas canvas){}
  bool onTouch(TinyStage stage, int id, TinyStagePointerType type, double globalX, globalY){return false;}
  void onTouchStart(TinyStage stage, int id, TinyStagePointerType type, double x, double y){}
  void onTouchEnd(TinyStage stage, int id, TinyStagePointerType type, double x, double y){}
  void onUnattach() {}
  void onAttach(TinyStage stage, TinyDisplayObject parent) {}
}
