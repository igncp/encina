import yaml
import os


class Data():
  def set_static(sf):
    def loadYaml(path):
      fileData = open(os.path.realpath(path))
      data = yaml.safe_load(fileData)
      fileData.close()
      return data

    static_path = os.path.realpath(__file__ + '/../../../static')
    
    def set_raw(key):
      path = os.path.realpath((static_path + '/' + key))
      sf.static[key] = dict()
      sf.static[key]['raw'] = dict()
      sf.static[key]['raw']['dir'] = loadYaml(path + '/directories.yml')
      sf.static[key]['raw']['file'] = loadYaml(path + '/files.yml')
      sf.static[key]['raw']['extension'] = loadYaml(path + '/extensions.yml')
      for type in ['dir', 'file', 'extension']:
        if sf.static[key]['raw'][type] is None: sf.static[key]['raw'][type] = []

    def set_excluded(type):
      exc_list = sf.static['excluded']['raw'][type]
      if exc_list:
        sf.static['excluded']['all'][type] = [obj['name'] for obj in exc_list
          if 'except' not in obj and 'for' not in obj]
        for possibility in sf.static['excluded']['specific_possibilities']:
          if possibility not in sf.static['excluded']: sf.static['excluded'][possibility] = dict()
          sf.static['excluded'][possibility][type] = [obj['name'] for obj in exc_list
          if ('except' in obj and possibility not in obj['except']) or
            ('for' in obj and possibility in obj['for'])]
      else:
        sf.static['excluded']['all'][type] = []
        for possibility in sf.static['excluded']['specific_possibilities']:
          if possibility not in sf.static['excluded']: sf.static['excluded'][possibility] = dict()
          sf.static['excluded'][possibility][type] = []

    sf.static = dict()
    set_raw('excluded')
    sf.static['excluded']['all'] = dict()
    sf.static['excluded']['specific_possibilities'] = ['nel', 'size', 'extension']

    for type in ['dir', 'file', 'extension']: set_excluded(type)
    
    set_raw('characteristics')