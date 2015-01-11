from pandas import Series, DataFrame
import numpy as np

class Data():
  def process_files_data(sf):
    sf.files = DataFrame(sf.files, columns=['path', 'extension', 'nel', 'size', 'depth'])
    
    sf.calculate_extensions_stats()
    sf.calculate_nel_stats()
    sf.calculate_sizes_stats()
    sf.calculate_depth_stats()

  def process_dirs_data(sf):
    for row in sf.dirs:
      row.append(float(row[2]) / float(row[3]))

    sf.dirs_df = DataFrame(sf.dirs, columns=['path', 'inside_dirs', 'inside_files', 'total_children', 'files_percent'])
    sf.dirs = {
      'inside_files': dict(),
      'inside_dirs': dict(),
      'total_children': dict(),
      'files_percent': dict()
    }
    sf.calculate_dirs_stats('inside_files')
    sf.calculate_dirs_stats('inside_dirs')
    sf.calculate_dirs_stats('total_children')
    # TODO: calc stats of 'files_percent' (float)
    
  def calculate_dirs_stats(sf, key):
    sf.dirs[key]['hist'] = sf.convert_df_column_to_hist(sf.dirs_df, key)
    sf.dirs[key].update(sf.get_summary_indicators_from_hist(sf.dirs[key]['hist'], True))
    if key != 'files_percent': sf.find_max_paths_in_dirs(sf.dirs[key]['max'], key)


  def calculate_sizes_stats(sf):
    sf.sizes = dict()
    sf.sizes['hist'] = sf.convert_df_column_to_hist(sf.files, 'size')
    sf.sizes.update(sf.get_summary_indicators_from_hist(sf.sizes['hist'], True))
    sf.find_max_paths_in_files(sf.sizes['max'], 'size')


  def calculate_extensions_stats(sf):
    sf.extensions = dict()
    sf.extensions['hist'] = sf.convert_df_column_to_hist(sf.files, 'extension')
    sf.extensions.update(sf.get_summary_indicators_from_hist(sf.extensions['hist']))


  def calculate_nel_stats(sf):
    key = 'nel'
    sf.nel = dict()
    sf.nel['hist'] = sf.convert_df_column_to_hist(sf.files, key)
    sf.nel.update(sf.get_summary_indicators_from_hist(sf.nel['hist'], True))
    sf.find_max_paths_in_files(sf.nel['max'], key)

  def calculate_depth_stats(sf):
    key = 'depth'
    sf.depths = dict()
    sf.depths['hist'] = sf.convert_df_column_to_hist(sf.files, key)
    sf.depths.update(sf.get_summary_indicators_from_hist(sf.depths['hist'], True))
    sf.find_max_paths_in_files(sf.depths['max'], key)

  def convert_df_column_to_hist(sf, df, column):
    return df[column].value_counts().to_dict()


  def get_summary_indicators_from_hist(sf, hist, int_index= False):
    seriesHist = Series(hist)
    maxs = {
      'freq': dict()
    }
    
    means = {'freq': seriesHist.mean()}
    medians = {'freq': seriesHist.median()}
    stds = {'freq': seriesHist.std()}
    
    maxs['freq']['freq'] = seriesHist.max()
    maxs['freq']['index'] = seriesHist.idxmax()
    index_total = 'NA'

    if int_index:
      index = seriesHist.index
      index = index.astype(int)
      index_list = index.tolist()
      index_total = sum(index_list)
      index_series = Series(index_list)

      means['index'] = index_series.mean()
      medians['index'] = index_series.median()
      stds['index'] = index_series.std()
      
      maxs['freq']['index'] = int(maxs['freq']['index'])

      maxs['index'] = dict()
      maxs['index']['index'] = max(index_list)
      maxs['index']['freq'] = hist[str(maxs['index']['index'])]

    return {
      'means': means,
      'medians': medians,
      'stds': stds,
      'max': maxs,
      'index_total': index_total
    }

  def find_max_paths(sf, df, max, key):
    max['freq']['paths'] = df.loc[df[key] == str(max['freq']['index'])]['path'].tolist()
    if 'index' in max:
      max['index']['paths'] = df.loc[df[key] == str(max['index']['index'])]['path'].tolist()

  def find_max_paths_in_files(sf, max, key):
    sf.find_max_paths(sf.files, max, key)
    
  def find_max_paths_in_dirs(sf, max, key):
    sf.find_max_paths(sf.dirs_df, max, key)