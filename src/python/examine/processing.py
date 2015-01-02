from pandas import Series, DataFrame
import numpy as np

class Data():
  def process_files_data(sf):
    sf.files = DataFrame(sf.files, columns=['extension', 'nel', 'size'])
    
    sf.calculate_extensions_stats()
    sf.calculate_nel_stats()
    sf.calculate_sizes_stats()


  def calculate_sizes_stats(sf):
    sf.sizes = dict()
    sf.sizes['hist'] = sf.convert_df_column_to_hist(sf.files, 'size')
    sf.sizes.update(sf.get_summary_indicators_from_hist(sf.sizes['hist'], True))


  def calculate_extensions_stats(sf):
    sf.extensions = dict()
    sf.extensions['hist'] = sf.convert_df_column_to_hist(sf.files, 'extension')
    sf.extensions.update(sf.get_summary_indicators_from_hist(sf.extensions['hist']))


  def calculate_nel_stats(sf):
    sf.nel = dict()
    sf.nel['hist'] = sf.convert_df_column_to_hist(sf.files, 'nel')
    sf.nel.update(sf.get_summary_indicators_from_hist(sf.nel['hist'], True))


  def convert_df_column_to_hist(sf, df, column):
    return df[column].value_counts().to_dict()


  def get_summary_indicators_from_hist(sf, hist, int_index= False):
    seriesHist = Series(hist)
    maxs = {
      'freq': dict()
    }
    
    maxs['freq']['freq'] = seriesHist.max()
    maxs['freq']['index'] = seriesHist.idxmax()
    total_index = 'NA'

    if int_index:
      index = seriesHist.index
      index = index.astype(int)
      index_list = index.tolist()
      total_index = sum(index_list)
      
      maxs['freq']['index'] = int(maxs['freq']['index'])
      
      seriesHist = seriesHist.multiply(index)

      maxs['index'] = dict()
      maxs['index']['index'] = max(index_list)
      maxs['index']['freq'] = hist[str(maxs['index']['index'])]

    return {
      'mean': seriesHist.mean(),
      'median': seriesHist.median(),
      'std': seriesHist.std(),
      'max': maxs,
      'total_index': total_index
    }