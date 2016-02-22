library css.test;

import 'package:umiuni2d/tinyutil.dart';
import 'package:test/test.dart';

void main() {
  group('#(1)# [TinyCsvDecoder]', () {
    //
    test("xxx,yyy,zzz", () {
      TinyCsvDecoder csv = new TinyCsvDecoder("xxx,yyy,zzz");
      expect([["xxx", "yyy", "zzz"]], csv.parse());
    });
    //
    test('"xxx","yyy","zzz"', () {
      TinyCsvDecoder csv = new TinyCsvDecoder('"xxx","yyy","zzz"');
      expect([["xxx", "yyy", "zzz"]], csv.parse());
    });
    //
    test('"xxx","yyy","zzz"\r\n"aaa","bbb","ccc"', () {
      TinyCsvDecoder csv = new TinyCsvDecoder('"xxx","yyy","zzz"\r\n"aaa","bbb","ccc"');
      expect([["xxx", "yyy", "zzz"],["aaa", "bbb", "ccc"]], csv.parse());
    });
    //
    test('"xxx","yyy","zzz",', () {
      TinyCsvDecoder csv = new TinyCsvDecoder('"xxx","yyy","zzz",');
      expect([["xxx", "yyy", "zzz", ""]], csv.parse());
    });
    //
    test('"x"xx,"yyy","zzz",', () {
      TinyCsvDecoder csv = new TinyCsvDecoder('"x""xx","yyy","zzz",');
      expect([["x\"xx", "yyy", "zzz", ""]], csv.parse());
    });
    //
    test('"x""xx","yyy","zzz",\r\n"aaa","bbb","ccc"\r\n', () {
      TinyCsvDecoder csv = new TinyCsvDecoder('"x""xx","yyy","zzz",\r\n"aaa","bbb","ccc"\r\n');
      expect([["x\"xx", "yyy", "zzz", ""],["aaa", "bbb", "ccc"]], csv.parse());
    });
    //
    test('"x""xx","yyy","zzz",\n"aaa","bbb","ccc"\n', () {
      TinyCsvDecoder csv = new TinyCsvDecoder('"x""xx","yyy","zzz",\n"aaa","bbb","ccc"\n');
      expect([["x\"xx", "yyy", "zzz", ""],["aaa", "bbb", "ccc"]], csv.parse());
    });
    //
    test('"x\\nxx,"yyy","zzz",', () {
      TinyCsvDecoder csv = new TinyCsvDecoder('"x\nxx","yyy","zzz",');
      expect([["x\nxx", "yyy", "zzz", ""]], csv.parse());
    });
  });

  ///
  ///
  ///
  group('#(2)# [TinyCsv.decode]', () {
    //
    test("xxx,yyy,zzz", () {
      TinyCsv csv =  TinyCsv.decode("xxx,yyy,zzz");
      expect([["xxx", "yyy", "zzz"]], csv.value);
      expect(1, csv.row);
      expect(3, csv.col);
    });
    test('"x""xx","yyy","zzz",\n"aaa","bbb","ccc"\n', () {
      TinyCsv csv =  TinyCsv.decode('"x""xx","yyy","zzz",\n"aaa","bbb","ccc"\n');
      expect([["x\"xx", "yyy", "zzz", ""],["aaa", "bbb", "ccc"]], csv.value);
      expect(2, csv.row);
      expect(4, csv.col);
    });
  });
}
