from pandas import Series

class Data():
  def calculate_lines_mean(sf):
    linesS = Series(sf.nel['hist'])
    number_files = linesS.index
    number_files = number_files.astype(int)
    lines = linesS.multiply(number_files)
    sf.nel['mean'] = lines.mean()
    sf.nel['median'] = lines.median()
    sf.nel['std'] = lines.std()
    
    sf.nel['max'] = dict({
      'lines': dict(),
      'files': dict()
    })
    sf.nel['max']['lines']['lines'] = max(linesS.index.tolist())
    sf.nel['max']['lines']['files'] = sf.nel['hist'][sf.nel['max']['lines']['lines']]
    sf.nel['max']['files']['lines'] = linesS.idxmax()
    sf.nel['max']['files']['files'] = linesS.max()