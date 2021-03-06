import os
import sys
import recollection_git
import recollection_packagejson


class Data(recollection_git.Data, recollection_packagejson.Data):
  def set_structure(sf):
    total_files = 0
    total_dirs = 0

    for root, dirs, files in os.walk(sf.root['dir'], topdown=True):
      dirs[:] = [d for d in dirs if d not in sf.static['excluded']['all']['dir']]
      files[:] = [d for d in files if d not in sf.static['excluded']['all']['file']
        and sf.get_file_extension(d) not in sf.static['excluded']['all']['extension']]
      
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
  
  def generate_tree_and_extras(sf, path='', top_depth=''):
      if path == '': path = sf.root['dir']
      if top_depth == '':
        top_depth = path.count(os.sep)
        sf.structure['top_depth'] = top_depth
      name = os.path.basename(path)
      d = {'name': name}
      if os.path.isdir(path):
        sf.check_characteristics('dir', name, path)
        if name not in sf.static['excluded']['all']['dir']:
          d['type'] = 'directory'
          inside_files = []
          inside_dirs = []
          list_dir = os.listdir(path)
          
          for child_name in list_dir:
            new_path = os.path.join(path, child_name)
            
            if os.path.isdir(new_path):
              inside_dirs.append(child_name)
            else: inside_files.append(child_name)
            
            if 'children' not in d: d['children'] = list()

            child = sf.generate_tree_and_extras(new_path, top_depth)
            
            if child is not False: d['children'].append(child)
          
          sf.dirs.append([sf.relative_path(path) + '/', str(len(inside_dirs)),
            str(len(inside_files)), str(len(inside_files) + len(inside_dirs))])
            
          return d
        else:
          sf.structure['excluded']['all']['dir'].append(name)
          return False
      else:
        sf.check_characteristics('dir', name, path)
        d['extension'] = sf.get_file_extension(name)
        sf.check_characteristics('file', name, path)
        sf.check_characteristics('extension', d['extension'], path)
        
        permitted_extension = d['extension'] not in sf.static['excluded']['all']['extension']
        permitted_file = name not in sf.static['excluded']['all']['file']
        if permitted_extension and permitted_file:
            d['lines'] = str(sf.count_nels(path))
            d['size'] = str(sf.get_size(path))
            d['depth'] = str(path.count(os.sep) - top_depth)
            d['type'] = "file"
            
            sf.files.append([name, sf.relative_path(path), d['extension'], d['lines'],
              d['size'], d['depth']])
            return d
        else:
          if not permitted_extension:
            if d['extension'] not in sf.structure['excluded']['all']['extension']:
              sf.structure['excluded']['all']['extension'].append(d['extension'])
          if not permitted_file:
            if name not in sf.structure['excluded']['all']['file']:
              sf.structure['excluded']['all']['file'].append(name)

      return False

  def get_file_extension(sf, path):
    extension = os.path.splitext(path)[1]
    
    if extension:
      extension = extension[1:]
    else:
      extension = 'NA'

    return extension

  def check_characteristics(sf, children_type, name, path):
    if children_type in sf.static['characteristics']['raw']:
      for possible_charac in sf.static['characteristics']['raw'][children_type]:
        if name == possible_charac['name']:
          if children_type not in sf.characteristics: sf.characteristics[children_type] = dict()
          if name not in sf.characteristics[children_type]:
            sf.characteristics[children_type][name] = possible_charac['desc']
          if 'method' in possible_charac:
            charac_method = getattr(sf, possible_charac['method'])
            charac_method(path)

  def get_size(sf, path):
    size = os.path.getsize(path)
    return size

  def set_root_data(sf):
    sf.root['dir'] = sys.argv[1]
    if sf.root['dir'][-1] != os.sep: sf.root['dir'] += os.sep
    sf.root['dir'] = os.path.normpath(os.getcwd() + os.sep + sf.root['dir'])
    sf.root['name'] = sf.root['dir'].split(os.sep)[-1]
