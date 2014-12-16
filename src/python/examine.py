import os
import sys
import json

def get_total_files():
  totalFiles = 0
  for root, dirs, files in os.walk(rootDir, topdown=True):
    dirs[:] = [d for d in dirs if d not in excluded_dirs]
    totalFiles += len(files)
  return totalFiles

def generate_tree_and_extras(path):
    name = os.path.basename(path)
    d = {'name': name}
    if os.path.isdir(path):
        check_special_cases(name)
        d['type'] = "directory"

        for x in os.listdir(path):
          if x not in excluded_dirs:
            if not 'children' in d:
              d['children'] = list()
            d['children'].append(generate_tree_and_extras(os.path.join(path,x)))
          else:
            check_special_cases(x)
    else:
        check_special_cases(name)
        collect_file_extension(name)
        d['type'] = "file"
    return d

def save_data_file():
  if not os.path.exists('encina-report'):
    os.makedirs('encina-report')

  data = {
    'numberFiles': totalSumFiles,
    'treeDir': treeDir,
    'rootName': rootName,
    'rootDir': rootDir,
    'excluded_dirs': list(excluded_dirs),
    'extensions': extensions,
    'special_cases': special_cases
  }

  with open('encina-report/data.json', 'w') as datafile:
    json.dump(data, datafile)

def collect_file_extension(path):
  extension = os.path.splitext(path)[1]
  if extension:
    extension = extension[1:]
    if extension in extensions:
      extensions[extension] += 1
    else:
      extensions[extension] = 1

def check_special_cases(element):
  if element == '.git':
    special_cases['has_git'] = True
  if element == 'package.json':
    special_cases['uses_node'] = True

excluded_dirs = set(['node_modules', '.git'])

rootDir = sys.argv[1]

if rootDir[-1] != os.sep: rootDir += os.sep
  
rootDir = os.getcwd() + os.sep + rootDir

totalSumFiles = get_total_files()
extensions = dict(); special_cases = dict()
treeDir = generate_tree_and_extras(rootDir)
rootName = rootDir.split(os.sep)[-2]
save_data_file()