import os
import json

class Data():
  def save_file(sf):
    if not os.path.exists('encina-report'):
      os.makedirs('encina-report')

    packagejson = open(os.path.dirname(os.path.abspath(__file__)) + '/../../../package.json')
    package = json.load(packagejson)
    packagejson.close()
    meta = {
      'version': package['version']
    }

    data = {
      'root': sf.root,
      'nel': sf.nel, # Non Empty Lines
      'sizes': sf.sizes,
      'extensions': sf.extensions,
      'structure': sf.structure,
      'characteristics': sf.characteristics,
      'tree': sf.tree,
      'meta': meta
    }

    with open('encina-report/data.json', 'w') as datafile:
      json.dump(data, datafile)