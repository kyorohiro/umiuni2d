library tinyutil.jenkinshash;

class JenkinsHash {
  static int calc(List<int> vs) {
    int v1 = 0;
    for (int v2 in vs) {
      v1 += v2;
      v1 += v1 << 10;
      v1 ^= (v1 >> 6);
    }
    v1 += v1 << 3;
    v1 ^= v1 >> 11;
    v1 += v1 << 15;

    return v1;
  }
}
