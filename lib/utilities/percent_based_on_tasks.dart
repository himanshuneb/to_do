double percentTasks(int c, int t) {
  double tempC = c.toDouble();
  double tempT = t.toDouble();
  if (tempT == 0) {
    return 0;
  }
  double percent = tempC / tempT;
  return percent;
}
