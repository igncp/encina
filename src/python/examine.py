import os
import sys
import json

rootDir = sys.argv[1]

total = 0
exclude = set(['node_modules', '.git'])
for root, dirs, files in os.walk(rootDir, topdown=True):
  dirs[:] = [d for d in dirs if d not in exclude]
  total += len(files)

if not os.path.exists('encina-report'):
  os.makedirs('encina-report')

data = {'total': total}

with open('encina-report/data.json', 'w') as datafile:
  json.dump(data, datafile)