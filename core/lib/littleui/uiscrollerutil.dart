part of littleui;

class LittleUIScrollerInfoSize {
  double baseSize = 100.0;
  List<double> sizePerItem = [];
  List<double> totalSizePerItem = [];

  void clear() {
      sizePerItem.clear();
      totalSizePerItem.clear();
  }

  double getSizePerItem(int id) {
    return sizePerItem[id];
  }

  double getTotalSizePerItem(int id) {
    if (id == 0) {
      return 0.0;
    }
    return totalSizePerItem[id - 1];
  }

  double get totalSize {
    if (totalSizePerItem.length == 0) {
      return 0.0;
    }
    return totalSizePerItem[totalSizePerItem.length - 1];
  }

  List<int> getIdsFromPosition(double top, double bottom) {
    top = -top; // ~/ 100 - 1;
    bottom = -bottom; // ~/ 100 + 1;
    List<int> ret = [0, 0];

    int index = 0;
    for (; index < totalSizePerItem.length; index++) {
      if (top >= getTotalSizePerItem(index)) {
        ret[0] = index;
        break;
      }
    }
    for (; index < totalSizePerItem.length; index++) {
      if (bottom <= getTotalSizePerItem(index)) {
        ret[1] = index;
        break;
      }
    }

    //
    //
    if (ret[0] >= 1) {
      ret[0] -= 1;
    }
    if ((ret[1] + 1) < totalSizePerItem.length) {
      ret[1] += 1;
    }
    return ret;
  }

  void update(int id, double height) {
    if (id >= sizePerItem.length) {
      for (int i = sizePerItem.length; i <= id; i++) {
        double h = baseSize;
        if (i == id) {
          h = height;
        }
        if (i != 0) {
          sizePerItem.add(h);
          totalSizePerItem.add(h + totalSizePerItem[i - 1]);
        } else {
          sizePerItem.add(h);
          totalSizePerItem.add(h);
        }
      }
    } else {
      if (height == sizePerItem[id]) {
        return;
      }
      double h = height;

      if (id != 0) {
        sizePerItem[id] = h;
        totalSizePerItem[id] = h + totalSizePerItem[id - 1];
      } else {
        sizePerItem[id] = h;
        totalSizePerItem[id] = h;
      }

      for (int i = id + 1; i < sizePerItem.length; i++) {
        totalSizePerItem[i] = sizePerItem[i] + totalSizePerItem[i - 1];
      }
    }
  }
}
