double percentTasks(int c, int t) {
  double tempC = c.toDouble();
  double tempT = t.toDouble();
  if (tempT == 0) {
    return 100;
  }
  double percent = tempC / tempT * 100;
  percent = num.parse(percent.toStringAsFixed(2));
  return percent;
}
