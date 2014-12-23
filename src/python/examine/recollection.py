import os
import sys
import json

class Data():
  def get_total_files(sf):
    totalFiles = 0
    for root, dirs, files in os.walk(sf.root_dir, topdown=True):
      dirs[:] = [d for d in dirs if d not in sf.excluded_dirs]
      totalFiles += len(files)
    sf.total_files = totalFiles

  def count_lines_and_collect(sf, path):
    counter = 0
    with open(path, 'r') as f:
      for line in f:
        if line.strip() != '': counter += 1
    
    if str(counter) in sf.lines:
      sf.lines[str(counter)] += 1
    else:
      sf.lines[str(counter)] = 1
    
    return counter

  def set_tree_and_extras(sf): sf.tree_dir = sf.generate_tree_and_extras()
  
  def generate_tree_and_extras(sf, path=''):
      if path == '': path = sf.root_dir
      name = os.path.basename(path)
      d = {'name': name}
      if os.path.isdir(path):
          sf.check_special_cases(name)
          d['type'] = 'directory'

          for name in os.listdir(path):
            if name not in sf.excluded_dirs:
              if not 'children' in d:
                d['children'] = list()
              new_path = os.path.join(path,name)
              d['children'].append(sf.generate_tree_and_extras(new_path))
            else:
              sf.check_special_cases(name)
      else:
          sf.check_special_cases(name)
          d['extension'] = sf.collect_file_extension(name)
          d['lines'] = str(sf.count_lines_and_collect(path))
          d['size'] = str(sf.get_sizes_and_collect(path))
          d['type'] = "file"
      
      return d

  def collect_file_extension(sf, path):
    extension = os.path.splitext(path)[1]
    
    if extension:
      extension = extension[1:]
      if extension in sf.extensions:
        sf.extensions[extension] += 1
      else:
        sf.extensions[extension] = 1
    else:
      extension = 'NA'

    return extension

  def check_special_cases(sf, element):
    if element == '.git':
      sf.special_cases['has_git'] = True
    if element == 'package.json':
      sf.special_cases['uses_node'] = True
    if element == 'bower.json':
      sf.special_cases['uses_bower'] = True

  def get_sizes_and_collect(sf, path):
    size = os.path.getsize(path)
    if str(size) in sf.sizes:
      sf.sizes[str(size)] += 1
    else:
      sf.sizes[str(size)] = 1
    
    return size