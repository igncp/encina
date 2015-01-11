import recollection
import storage
import processing
import utilities

class Data(recollection.Data, storage.Data, processing.Data, utilities.Data):
  def __init__(sf):
    sf.root = dict()

    sf.files = list()
    sf.dirs = list()
    
    sf.structure = dict()
    sf.meta = dict()
    sf.characteristics = dict()
    sf.tree = dict()

    sf.structure['excluded_dirs'] = ['node_modules', '.git', 'bower_components']