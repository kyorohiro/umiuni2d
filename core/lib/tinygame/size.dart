part of tinygame;


class TinySize {
  double w;
  double h;
  TinySize(this.w, this.h) {}

  @override
  bool operator ==(o) => o is TinySize && o.w == w && o.h == h;

  @override
  int get hashCode => JenkinsHash.calc([w.hashCode, h.hashCode]);

  @override
  String toString() {
    return "w:${w}, h:${h}";
  }
}
