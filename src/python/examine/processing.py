from pandas import Series

class Data():
  def calculate_lines_mean(sf):
    lines = Series(sf.lines)
    number_files = lines.index
    number_files = number_files.astype(int)
    lines = lines.multiply(number_files)
    sf.lines_mean = lines.mean()