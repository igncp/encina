import recollection
import storage
import processing
import utilities
import static


class Data(recollection.Data, storage.Data, processing.Data, utilities.Data, static.Data):
  def __init__(sf):
    sf.root = dict()

    sf.files = list()
    sf.dirs = list()

    sf.structure = dict()
    sf.structure['excluded'] = {
      'dirs': []
    }
    sf.meta = dict()
    sf.characteristics = dict()
    sf.tree = dict()

    sf.set_static()
