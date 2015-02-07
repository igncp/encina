import os
import json
import time
import platform


class Data():
  def linux_distribution(sf):
      try:
        dist = platform.linux_distribution()
        sf.meta['linux'] = ' '.join(dist)
      except:
        pass

  def save_file(sf):
    if not os.path.exists('encina-reports'):
      os.makedirs('encina-reports')
      os.makedirs('encina-reports/data')

    packagejson = open(os.path.dirname(os.path.abspath(__file__)) + '/../../../package.json')
    package = json.load(packagejson)
    packagejson.close()

    sf.meta['version'] = package['version']
    sf.meta['os'] = platform.system() + ' ' + platform.release()
    sf.meta['machine'] = platform.machine()
    sf.meta['tzname'] = time.tzname[0]
    sf.meta['time'] = time.time()
    sf.linux_distribution()

    data = {
      'depths': sf.depths,
      'root': sf.root,
      'nel': sf.nel,  # Non Empty Lines
      'sizes': sf.sizes,
      'extensions': sf.extensions,
      'structure': sf.structure,
      'characteristics': sf.characteristics,
      'tree': sf.tree,
      'dirs': sf.dirs,
      'meta': sf.meta
    }

    file_name = "{}-{}".format(data['root']['name'], str(int(time.time())))
    with open('encina-reports/data/' + file_name + '.json', 'w') as datafile:
      json.dump(data, datafile)
