import os
import sys
import json

excluded_dirs = set(['node_modules', '.git'])

rootDir = sys.argv[1]
rootDir = os.getcwd() + os.sep + rootDir

def get_total_files():
  totalFiles = 0
  for root, dirs, files in os.walk(rootDir, topdown=True):
    dirs[:] = [d for d in dirs if d not in excluded_dirs]
    totalFiles += len(files)
  return totalFiles

def path_to_dict(path):
    d = {'name': os.path.basename(path)}
    if os.path.isdir(path):
        d['type'] = "directory"
        d['children'] = [path_to_dict(os.path.join(path,x)) for x in os.listdir(path) if x not in excluded_dirs]
    else:
        d['type'] = "file"
    return d

def save_data_file():
  if not os.path.exists('encina-report'):
    os.makedirs('encina-report')

  data = {
    'total': totalSumFiles,
    'treeDir': treeDir,
    'rootName': rootName,
    'rootDir': rootDir,
    'excluded_dirs': list(excluded_dirs)
  }

  with open('encina-report/data.json', 'w') as datafile:
    json.dump(data, datafile)


totalSumFiles = get_total_files()
treeDir = path_to_dict(rootDir)
rootName = rootDir.split(os.sep)[-2]
save_data_file()