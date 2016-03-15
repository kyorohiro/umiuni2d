part of tinygame;


class TinyPoint {
  double x;
  double y;
  TinyPoint(this.x, this.y) {}

  @override
  bool operator ==(o) => o is TinyPoint && o.x == x && o.y == y;

  @override
  int get hashCode => JenkinsHash.calc([x.hashCode, y.hashCode]);

  @override
  String toString() {
    return "x:${x}, y:${y}";
  }
}
