from pandas import Series, DataFrame
import numpy as np

class Data():
  def process_files_data(sf):
    sf.files = DataFrame(sf.files, columns=['path', 'extension', 'nel', 'size', 'depth'])
    
    sf.calculate_extensions_stats()
    sf.calculate_nel_stats()
    sf.calculate_sizes_stats()
    sf.calculate_depth_stats()


  def calculate_sizes_stats(sf):
    sf.sizes = dict()
    sf.sizes['hist'] = sf.convert_df_column_to_hist(sf.files, 'size')
    sf.sizes.update(sf.get_summary_indicators_from_hist(sf.sizes['hist'], True))
    sf.find_max_paths(sf.sizes['max'], 'size')


  def calculate_extensions_stats(sf):
    sf.extensions = dict()
    sf.extensions['hist'] = sf.convert_df_column_to_hist(sf.files, 'extension')
    sf.extensions.update(sf.get_summary_indicators_from_hist(sf.extensions['hist']))


  def calculate_nel_stats(sf):
    key = 'nel'
    sf.nel = dict()
    sf.nel['hist'] = sf.convert_df_column_to_hist(sf.files, key)
    sf.nel.update(sf.get_summary_indicators_from_hist(sf.nel['hist'], True))
    sf.find_max_paths(sf.nel['max'], key)

  def calculate_depth_stats(sf):
    key = 'depth'
    sf.depths = dict()
    sf.depths['hist'] = sf.convert_df_column_to_hist(sf.files, key)
    sf.depths.update(sf.get_summary_indicators_from_hist(sf.depths['hist'], True))
    sf.find_max_paths(sf.depths['max'], key)

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

  def find_max_paths(sf, max, key):
    max['freq']['paths'] = sf.files.loc[sf.files[key] == str(max['freq']['index'])]['path'].tolist()
    if 'index' in max:
      max['index']['paths'] = sf.files.loc[sf.files[key] == str(max['index']['index'])]['path'].tolist()