library tinyutil.csv;


class TinyCsv {
  int _col = 0;
  int _row = 0;
  int get col => _col;
  int get row => _row;
  List<List<String>> value;

  static TinyCsv decode(String source) {
    return null;
  }  
}

class TinyCsvDecoder {
  int index = 0;
  String source;
  TinyCsvDecoder(this.source) {}

  List<List<String>> parse() {
    List ret = [];
    do {
      ret.add(parseRow());
      parseEND(modIndex: true);
    } while (index < source.length);
    return ret;
  }

  List parseRow() {
    List col = [];
    do {
      col.add(parseValue());
    } while (parseConmma(modIndex: true));
    return col;
  }

  //doubleQuote
  String parseValue() {
    StringBuffer buffer = new StringBuffer();
    bool useDoubleQuote = parseDoubleQuote(modIndex: true);
    while (true) {
      //print("# ${index} : ${buffer.toString()} ${useDoubleQuote}");
      if (useDoubleQuote) {
        if (parseDoubleQuote(modIndex: true)) {
          return buffer.toString();
        }
      } else if (parseConmma()) {
        return buffer.toString();
      } else if (parseEND(modIndex: false)) {
        return buffer.toString();
      }
      if (parseDoubleDoubleQuote(modIndex: true)) {
        buffer.write('"');
      } else {
        buffer.write(source[index]);
        index++;
      }
    }
  }

  bool parseDoubleDoubleQuote({bool modIndex: false}) {
    if (source[index] == '"' && (index < source.length - 1) && source[index + 1] == '"') {
      if (modIndex == true) {
        index += 2;
      }
      return true;
    } else {
      return false;
    }
  }

  bool parseDoubleQuote({bool modIndex: false}) {
    if (index < source.length && source[index] == '"' && ((index == source.length - 1) || source[index + 1] != '"')) {
      if (modIndex == true) {
        index++;
      }
      return true;
    } else {
      return false;
    }
  }

  bool parseConmma({bool modIndex: false}) {
    if (index < source.length && source[index] == ',') {
      if (modIndex == true) {
        index++;
      }
      return true;
    } else {
      return false;
    }
  }

  parseEND({bool modIndex: false}) {
    if (index >= source.length) {
      return true;
    } else if (index + 1 < source.length && source[index] == '\r' && source[index + 1] == '\n') {
      if (modIndex) {
        index += 2;
      }
      return true;
    } else if (index < source.length && source[index] == '\n') {
      if (modIndex) {
        index += 1;
      }
      return true;
    } else {
      return false;
    }
  }
}
