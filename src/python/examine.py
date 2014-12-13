import os
import sys
import json

rootDir = sys.argv[1]
rootDir = os.getcwd() + os.sep + rootDir

total = 0
excluded_files = set(['node_modules', '.git'])
root_info = dict()
for root, dirs, files in os.walk(rootDir, topdown=True):
  dirs[:] = [d for d in dirs if d not in excluded_files]
  if root == rootDir:
    root_info['dirs'] = dirs
    root_info['files'] = files
  total += len(files)

rootName = rootDir.split(os.sep)[-2]

if not os.path.exists('encina-report'):
  os.makedirs('encina-report')

data = {
  'total': total,
  'root_info': root_info,
  'rootName': rootName,
  'rootDir': rootDir
}

with open('encina-report/data.json', 'w') as datafile:
  json.dump(data, datafile)