import os
import sys
import json

class Data():
  def set_structure(sf):
    total_files = 0
    total_dirs = 0
    
    for root, dirs, files in os.walk(sf.root['dir'], topdown=True):
      dirs[:] = [d for d in dirs if d not in sf.structure['excluded_dirs']]
      total_files += len(files)
      total_dirs += len(dirs)
    
    sf.structure['total_files'] = total_files
    sf.structure['total_dirs'] = total_dirs

  def count_nels(sf, path):
    counter = 0
    with open(path, 'r') as f:
      for line in f:
        if line.strip() != '': counter += 1
    return counter

  def set_tree_and_extras(sf): sf.tree = sf.generate_tree_and_extras()
  
  def generate_tree_and_extras(sf, path=''):
      if path == '': path = sf.root['dir']
      name = os.path.basename(path)
      d = {'name': name}
      if os.path.isdir(path):
          sf.check_characteristics(name)
          d['type'] = 'directory'

          for name in os.listdir(path):
            if name not in sf.structure['excluded_dirs']:
              if not 'children' in d:
                d['children'] = list()
              new_path = os.path.join(path,name)
              d['children'].append(sf.generate_tree_and_extras(new_path))
            else:
              sf.check_characteristics(name)
      else:

          sf.check_characteristics(name)
          d['extension'] = sf.get_file_extension(name)
          d['lines'] = str(sf.count_nels(path))
          d['size'] = str(sf.get_size(path))
          d['type'] = "file"
          sf.files.append([d['extension'], d['lines'], d['size']])
      
      return d

  def get_file_extension(sf, path):
    extension = os.path.splitext(path)[1]
    
    if extension:
      extension = extension[1:]
    else:
      extension = 'NA'

    return extension

  def check_characteristics(sf, element):
    if element == '.git':
      sf.characteristics['has_git'] = True
    if element == 'package.json':
      sf.characteristics['uses_node'] = True
    if element == 'bower.json':
      sf.characteristics['uses_bower'] = True

  def get_size(sf, path):
    size = os.path.getsize(path)
    return size

  def set_root_data(sf):
    sf.root['dir'] = sys.argv[1]
    if sf.root['dir'][-1] != os.sep: sf.root['dir'] += os.sep
    sf.root['dir'] = os.path.normpath(os.getcwd() + os.sep + sf.root['dir'])
    sf.root['name'] = sf.root['dir'].split(os.sep)[-1]