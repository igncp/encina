import os
import sys

import recollection
import storage
import processing

class Data(recollection.Data, storage.Data, processing.Data):
  def __init__(sf):
    sf.excluded_dirs = set(['node_modules', '.git', 'bower_components'])
    
    sf.extensions = dict()
    sf.special_cases = dict()
    sf.lines = dict()
    sf.tree_dir = dict()
    sf.sizes = dict()

    sf.set_root_dir()
    
    sf.root_name = sf.root_dir.split(os.sep)[-2]

  def set_root_dir(sf):
    sf.root_dir = sys.argv[1]
    if sf.root_dir[-1] != os.sep: sf.root_dir += os.sep
    sf.root_dir = os.path.normpath(os.getcwd() + os.sep + sf.root_dir)