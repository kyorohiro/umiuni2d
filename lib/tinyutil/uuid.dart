library tinyutil.uuid;

import 'dart:math' as math;
import 'dart:typed_data';

class TinyUuid {
  static math.Random _random = new math.Random();

  static String createUuid() {
    return s4() + s4() + "-" + s4() + "-" + s4() + "-" + s4() + "-" + s4() + s4() + s4();
  }

  static String normalizeUUIDString(String uuid) {
    if (uuid.contains("-")) {
      return uuid;
    } else {
      return "${uuid.substring(0,8)}-${uuid.substring(8,12)}" + "-${uuid.substring(12,16)}-${uuid.substring(16,20)}" + "-${uuid.substring(20)}".toLowerCase();
    }
  }

  static String s4() {
    return (_random.nextInt(0xFFFF) + 0x10000).toRadixString(16).substring(0, 4);
  }

  static List<String> _v = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"];

  static String toStringFromBytes(Uint8List uuidBytes, {int start: 0}) {
    StringBuffer buffer = new StringBuffer();
    for (int i = 0; i < 16; i++) {
      int v = uuidBytes[i + start];
      buffer.write(_v[0xf & (v >> 4)]);
      buffer.write(_v[0xf & (v >> 0)]);
    }
    return normalizeUUIDString(buffer.toString());
  }

  static Uint8List toBytesFromUUID(String normalizedUUID) {
    Uint8List buffer = new Uint8List(16);
    int i = 0;
    int j = 0;
    List<int> codeUnits = normalizedUUID.codeUnits;
    while (j < codeUnits.length) {
      int v1 = -1;
      int v2 = -1;
      int datam = codeUnits[j++];
      if (48 <= datam && datam <= 57) {
        v1 = datam - 48;
      } else if (65 <= datam && datam <= 70) {
        v1 = datam - 65 + 10;
      } else if (97 <= datam && datam <= 102) {
        v1 = datam - 97 + 10;
      }
      if (v1 < 0) {
        continue;
      }
      datam = codeUnits[j++];
      if (48 <= datam && datam <= 57) {
        v2 = datam - 48;
      } else if (65 <= datam && datam <= 70) {
        v2 = datam - 65 + 10;
      } else if (97 <= datam && datam <= 102) {
        v2 = datam - 97 + 10;
      }
      buffer[i++] = v1 << 4 | v2;
    }
    return buffer;
  }
}
