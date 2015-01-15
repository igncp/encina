import yaml
import os


class Data():
  def set_static(sf):
    def loadYaml(path):
      fileData = open(os.path.realpath(path))
      data = yaml.safe_load(fileData)
      fileData.close()
      return data

    def setExcludedAll(type):
      exc_list = sf.static['excluded']['raw'][type]
      if exc_list is not None:
        return [obj['name'] for obj in exc_list
          if 'except' not in obj or 'for' not in obj]
      else:
        return []

    sf.static = dict()
    static_path = os.path.realpath(__file__ + '/../../../static')
    excluded_path = os.path.realpath((static_path + '/excluded'))

    sf.static['excluded'] = dict()
    sf.static['excluded']['raw'] = dict()
    sf.static['excluded']['all'] = dict()
    sf.static['excluded']['raw']['dirs'] = loadYaml(excluded_path + '/directories.yml')
    sf.static['excluded']['raw']['files'] = loadYaml(excluded_path + '/files.yml')
    sf.static['excluded']['raw']['exts'] = loadYaml(excluded_path + '/extensions.yml')

    for type in ['dirs', 'files', 'exts']:
      sf.static['excluded']['all'][type] = setExcludedAll(type)
