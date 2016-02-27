library scs.test;

import 'package:umiuni2d/littleui.dart';
import 'package:test/test.dart';

void main() {
  group('#(2)# [TinyCsv.decode]', () {
    //
    test("A", () {
      InfoSize h = new InfoSize();
      h.update(3, 50.0);
//      print("### ${h.heightsPlus}");
      expect(100.0, h.totalSizePerItem[0]);
      expect(200.0, h.totalSizePerItem[1]);
      expect(300.0, h.totalSizePerItem[2]);
      expect(350.0, h.totalSizePerItem[3]);
    });
    test("1", () {
      InfoSize h = new InfoSize();
      h.update(0, 50.0);
      expect(50.0, h.totalSizePerItem[0]);
    });
    test("B", () {
      InfoSize h = new InfoSize();
      h.update(3, 50.0);
      h.update(1, 150.0);
      expect(100.0, h.totalSizePerItem[0]);
      expect(250.0, h.totalSizePerItem[1]);
      expect(350.0, h.totalSizePerItem[2]);
      expect(400.0, h.totalSizePerItem[3]);
    });
    test("B1", () {
      InfoSize h = new InfoSize();
      h.update(3, 50.0);
      h.update(0, 150.0);
      expect(150.0, h.totalSizePerItem[0]);
      expect(250.0, h.totalSizePerItem[1]);
      expect(350.0, h.totalSizePerItem[2]);
      expect(400.0, h.totalSizePerItem[3]);
    });
    test("B2", () {
      InfoSize h = new InfoSize();
      h.update(3, 50.0);
      h.update(3, 150.0);
      expect(100.0, h.totalSizePerItem[0]);
      expect(200.0, h.totalSizePerItem[1]);
      expect(300.0, h.totalSizePerItem[2]);
      expect(450.0, h.totalSizePerItem[3]);
    });
  });

}
