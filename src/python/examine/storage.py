import os
import json

class Data():
  def save_file(sf):
    if not os.path.exists('encina-report'):
      os.makedirs('encina-report')

    data = {
      'numberFiles': sf.total_files,
      'treeDir': sf.tree_dir,
      'rootName': sf.root_name,
      'rootDir': sf.root_dir,
      'excluded_dirs': list(sf.excluded_dirs),
      'extensions': sf.extensions,
      'special_cases': sf.special_cases,
      'lines': sf.lines,
      'linesMean': str(sf.lines_mean),
      'sizes': sf.sizes
    }

    with open('encina-report/data.json', 'w') as datafile:
      json.dump(data, datafile)