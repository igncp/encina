import json


class Data():
  def recollect_packagejson(sf, path):
    if 'packagejson' not in sf.special:
      sf.special['packagejson'] = {
        'files': []
      }

    file_data = open(path)
    packagejson = json.load(file_data)
    relative_path = path.replace(sf.root['dir'], '')
    sf.special['packagejson']['files'].append({
        'path': relative_path,
        'data': packagejson
      })
    file_data.close()
