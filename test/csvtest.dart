library css.test;

import 'package:umiuni2d/tinyutil.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    //
    //
    test("xxx,yyy,zzz", () {
      TinyCsv csv = new TinyCsv("xxx,yyy,zzz");
      expect([["xxx", "yyy", "zzz"]], csv.parse());
    });
    test('"xxx","yyy","zzz"', () {
      TinyCsv csv = new TinyCsv('"xxx","yyy","zzz"');
      expect([["xxx", "yyy", "zzz"]], csv.parse());
    });
    test('"xxx","yyy","zzz"\r\n"aaa","bbb","ccc"', () {
      TinyCsv csv = new TinyCsv('"xxx","yyy","zzz"\r\n"aaa","bbb","ccc"');
      expect([["xxx", "yyy", "zzz"],["aaa", "bbb", "ccc"]], csv.parse());
    });

    //
    //
    test('"xxx","yyy","zzz",', () {
      TinyCsv csv = new TinyCsv('"xxx","yyy","zzz",');
      expect([["xxx", "yyy", "zzz", ""]], csv.parse());
    });

    //
    //
    test('"x"xx,"yyy","zzz",', () {
      TinyCsv csv = new TinyCsv('"x""xx","yyy","zzz",');
      expect([["x\"xx", "yyy", "zzz", ""]], csv.parse());
    });

    //
    //
    test('"x""xx","yyy","zzz",\r\n"aaa","bbb","ccc"\r\n', () {
      TinyCsv csv = new TinyCsv('"x""xx","yyy","zzz",\r\n"aaa","bbb","ccc"\r\n');
      expect([["x\"xx", "yyy", "zzz", ""],["aaa", "bbb", "ccc"]], csv.parse());
    });

    //
    //
    test('"x""xx","yyy","zzz",\n"aaa","bbb","ccc"\n', () {
      TinyCsv csv = new TinyCsv('"x""xx","yyy","zzz",\n"aaa","bbb","ccc"\n');
      expect([["x\"xx", "yyy", "zzz", ""],["aaa", "bbb", "ccc"]], csv.parse());
    });

    //
    //
    //
    test('"x\\nxx,"yyy","zzz",', () {
      TinyCsv csv = new TinyCsv('"x\nxx","yyy","zzz",');
      expect([["x\nxx", "yyy", "zzz", ""]], csv.parse());
    });
  });
}
