part of tinygame_webgl;

class TinyWebglContext {
  RenderingContext GL;
  CanvasElement _canvasElement;
  CanvasElement get canvasElement => _canvasElement;
  double widht;
  double height;
  String selectors;
  TinyWebglContext({width: 600.0, height: 400.0, this.selectors: null}) {
    this.widht = width;
    this.height = height;
    if (selectors == null) {
      _canvasElement = new CanvasElement(width: widht.toInt(), height: height.toInt());
      _canvasElement.style.width = "${widht.toInt()}px";
      _canvasElement.style.height = "${height.toInt()}px";
      document.body.append(_canvasElement);
    } else {
      _canvasElement = window.document.querySelector(selectors);
      if (width != null) {
        _canvasElement.width = _canvasElement.offsetWidth;
      } else {
        this.widht = _canvasElement.offsetWidth.toDouble();
      }
      if (height != null) {
        _canvasElement.height = height;
      } else {
        this.height = _canvasElement.offsetHeight.toDouble();
      }
    }

    GL = _canvasElement.getContext3d(stencil: true);
  }
}
