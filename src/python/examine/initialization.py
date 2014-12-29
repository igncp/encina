import os
import sys

import recollection
import storage
import processing

class Data(recollection.Data, storage.Data, processing.Data):
  def __init__(sf):
    sf.root = dict()

    sf.files = list()
    
    sf.structure = dict()
    sf.characteristics = dict()
    sf.tree = dict()
    
    sf.structure['excluded_dirs'] = ['node_modules', '.git', 'bower_components']