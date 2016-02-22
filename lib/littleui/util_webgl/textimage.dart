import 'dart:html' as html;
import 'dart:async';

class TextImageUtil {
  static Future<html.ImageElement> makeImage(String message, {String color:"rgb(2,169,159)", int fontsize:25, int height: 300, int width:300}) async {
    html.CanvasElement canvasElm = new html.CanvasElement();
    html.CanvasRenderingContext2D context = canvasElm.context2D;
    canvasElm.width = width;
    canvasElm.height = height;
    context.font = "bold ${fontsize}px Century Gothic";
    context.strokeStyle = "rgb(2,169,159)";
    context.fillStyle = "${color}";

    num h = 0;
    num w = 0;
    List<String> texts = [];

    for(int i=0;i<message.length;i++) {
      html.TextMetrics m = context.measureText(message.substring(0,i));
      if(m.width > width){
        String tmp = message.substring(0,i-1);
        message = message.substring(i-1);
        m = context.measureText(tmp);
        i=0;
        //context.fillText(tmp, 0, h+ m.actualBoundingBoxAscent);
        h += fontsize*1.25;//m.actualBoundingBoxAscent+m.actualBoundingBoxDescent;
        if(w < m.width) {
          w = m.width;
        }
        //print("## ${h} ${m.actualBoundingBoxAscent} ${m.actualBoundingBoxDescent} ${message}");
        texts.add(tmp);
      };
    }
    html.TextMetrics m = context.measureText(message);
    h += fontsize*1.25*2.0;//(m.actualBoundingBoxAscent+m.actualBoundingBoxDescent)*2.0;
    if(w < m.width) {
      w = m.width;
    }
    texts.add(message);
    //
    //
    int beginY = (height-h)~/2;
    int beginX = (width-w)~/2;
    print("###########${beginX} ${beginY}");
    h=0;
    for(String t in texts) {
      h += fontsize*1.25;//(m.actualBoundingBoxAscent+m.actualBoundingBoxDescent);
      context.fillText(t, beginX, beginY+h+fontsize);//m.actualBoundingBoxAscent);
    }

    html.ImageElement ret = new html.ImageElement();
    ret.src = canvasElm.toDataUrl();
    ret.width = 300;
    ret.height = 300;
    return ret;
  }
}
