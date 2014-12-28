import os
import json

class Data():
  def save_file(sf):
    if not os.path.exists('encina-report'):
      os.makedirs('encina-report')

    data = {
      'root': sf.root,
      'nel': sf.nel, # Non Empty Lines
      'sizes': sf.sizes,
      'extensions': sf.extensions,
      'structure': sf.structure,
      'characteristics': sf.characteristics,
      'tree': sf.tree
    }

    with open('encina-report/data.json', 'w') as datafile:
      json.dump(data, datafile)