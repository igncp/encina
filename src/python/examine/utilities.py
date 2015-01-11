class Data():
  def relative_path(sf, path):
    return path.replace(sf.root['dir'],'')