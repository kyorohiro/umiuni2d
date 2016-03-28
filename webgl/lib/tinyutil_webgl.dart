library tinyutil.webgl;

import 'dart:html' as html;
import 'dart:async';
import 'package:umiuni2d/tinygame.dart';

class ImageElementResizer {
  static Future<html.ImageElement> resize(html.ImageElement imageTmp, {int nextHeight: 300}) async {
    html.ImageElement returnValue = new html.ImageElement();

    html.CanvasElement canvasForResize = new html.CanvasElement();
    html.CanvasRenderingContext2D context = canvasForResize.context2D;
    double aspect = (imageTmp.width / imageTmp.height);
    canvasForResize.width = (nextHeight * aspect).toInt();
    canvasForResize.height = nextHeight;
    context.drawImageToRect(imageTmp, new html.Rectangle(0, 0, canvasForResize.width, canvasForResize.height), sourceRect: new html.Rectangle(0, 0, imageTmp.width, imageTmp.height));

    returnValue.src = canvasForResize.toDataUrl();
    returnValue.width = (nextHeight * imageTmp.width ~/ imageTmp.height).toInt();
    returnValue.height = nextHeight;

    return returnValue;
  }
}

enum CanvasElementTextAlign {
  left_top,
  left_center,
  center_top,
  center_center,
}

class CanvasElementText {

  // http://stackoverflow.com/questions/5680013/how-to-be-notified-once-a-web-font-has-loaded
  static Future waitForWebFont(List<String> fonts) async {
    for(String font in fonts) {
      html.SpanElement span = new html.SpanElement();
      span.text = "xxx";
      span.style.position = "absolute";
      span.style.top = "-10000px";
      span.style.left = "-10000px";
      span.style.fontSize = "30px";
      span.style.fontFamily = "sans-serif";
      span.style.fontVariant = "normal";
      span.style.fontStyle = "normal";
      span.style.fontWeight = "normal";
      span.style.letterSpacing = "0";
      html.document.body.append(span);
      //
      var width = span.offsetWidth;
      //
      span.style.fontFamily = font;
      for(int j=0;j<10;j++) {
        if(span != null && span.offsetWidth != width) {
          print("--------------------------${font}-OK!!");
          span.parent.children.remove(span);
          span = null;
          break;
        }
        await new Future.delayed(new Duration(milliseconds: 50));
      }
    }
  }

  static html.CanvasRenderingContext2D resetCanvasImage(
    {
      int fontSize: 25,
      bool isBold:false, bool isItalic:false,
      String fontFamily: "Century Gothic",
      TinyColor fillStyle: null,
      TinyColor strokeStyle: null,
      int textureHeight: 300, int textureWidth: 300,
      html.CanvasElement canvasElm: null
    }) {
    //
    if (canvasElm == null) {
      canvasElm = new html.CanvasElement();
    }

    canvasElm.style.width = "${textureWidth}px";
    canvasElm.style.height = "${textureHeight}px";
    //
    html.CanvasRenderingContext2D context = canvasElm.context2D;
    canvasElm.width = textureWidth;
    canvasElm.height = textureHeight;
    String fontStyle = (isItalic?"italic ":"") + (isBold?"bold ":"");

    context.font = "${fontStyle}${fontSize}px ${fontFamily}";
    if(strokeStyle != null) {
      context.strokeStyle = strokeStyle.toRGBAString();
    }
    if(fillStyle != null) {
      context.fillStyle = fillStyle.toRGBAString();
    }
    //context.lineCap = "round";
    //context.lineJoin = "round";
    return context;
  }


  static html.CanvasElement makeImage(String message,
    {
     TinyColor fillColor:null,
     TinyColor strokeColor:null,
     num fontsize: 25,
     bool isBold:false, bool isItalic:false,
     String fontFamily: "Century Gothic",
     int height: 300,
     int width: 300,
     html.CanvasElement canvasElm: null,
     CanvasElementTextAlign align:CanvasElementTextAlign.center_center,
     bool resizeHeight:true}) {

    if (canvasElm == null) {
      canvasElm = new html.CanvasElement();
    }

    canvasElm.style.width = "${width}px";
    canvasElm.style.height = "${height}px";

    html.CanvasRenderingContext2D context =
    resetCanvasImage(
      fontSize: fontsize, isBold: isBold, isItalic: isItalic, fontFamily: fontFamily,
      fillStyle: fillColor, strokeStyle: strokeColor,
      textureHeight: height, textureWidth: width,
      canvasElm: canvasElm);

    TextLines lines = new TextLines.fromContext2D(context, message, width, fontsize);
    //
    if(resizeHeight == true) {
      if(lines.height > height) {
        canvasElm.height = (lines.height * 1.0).toInt();
        resetCanvasImage(fontSize: fontsize, isBold: isBold, isItalic:isItalic, fontFamily: fontFamily, fillStyle: fillColor, textureHeight: canvasElm.height, textureWidth: width, canvasElm: canvasElm);
      }
    }
    //
    int beginY = 0;
    int beginX = 0;
    if(align == CanvasElementTextAlign.center_center) {
       beginY = (height - lines.height) ~/ 2;
       beginX = (width - lines.width) ~/ 2;
    } else if(align == CanvasElementTextAlign.center_top) {
       beginY = 0;
       beginX = (width - lines.width) ~/ 2;
    } else if(align == CanvasElementTextAlign.left_top) {
      beginY = 0;
      beginX = 0;
    } else {
      beginY = (height - lines.height) ~/ 2;
      beginX = 0;
    }

    int h = 0;
    for (int i=0;i<lines.texts.length;i++) {
      String t = lines.texts[i];
      context.fillText(t, beginX, beginY + h + fontsize);
      h += lines.fontHeights[i];
    }

    return canvasElm;
  }
}


class TextLines {
  int _width = 0;
  int _height = 0;
  int get width => _width;
  int get height => _height;
  List<int> size = [];
  List<num> fontHeights = [];
  List<String> texts = [];

  TextLines.fromContext2D(html.CanvasRenderingContext2D context, String message, int width, int fontHeight) {
    _width = 0;
    _height = 0;

    for (int i = 0; i < message.length; i++) {
      html.TextMetrics m = context.measureText(message.substring(0, i));
      if (m.width > width) {
        String tmp = message.substring(0, i - 1);
        message = message.substring(i - 1);
        m = context.measureText(tmp);
        i = 0;
        //print("##  ${message}");
        _height += fontHeight*1.2;
        if (_width < m.width) {
          _width = m.width;
        }
        texts.add(tmp);
        size.add(m.width);
        fontHeights.add(fontHeight*1.2);
      }
    }
    html.TextMetrics m = context.measureText(message);
    texts.add(message);
    size.add(m.width);
    fontHeights.add(fontHeight*1.2);
    _height += fontHeight*1.2;
    if (_width < m.width) {
      _width = m.width;
    }
  }
}
