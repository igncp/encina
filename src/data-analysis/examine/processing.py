from pandas import Series, DataFrame
import pandas as pd

# Disable warning when converting hist.to_dict()
pd.options.mode.chained_assignment = None


class Data():
  def process_files_data(sf):
    sf.files = DataFrame(sf.files, columns=['file', 'path', 'extension', 'nel', 'size', 'depth'])

    sf.calculate_extensions_stats()
    sf.calculate_nel_stats()
    sf.calculate_sizes_stats()
    sf.calculate_depth_stats()

  def process_dirs_data(sf):
    for row in sf.dirs:
      if int(row[3]) != 0:
        row.append(float(row[2]) / float(row[3]))
      else:
        row.append('NA')

    sf.dirs_df = DataFrame(sf.dirs, columns=['path', 'inside_dirs',
      'inside_files', 'total_children', 'files_percent'])

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
    sf.extensions['hist_by_nel'] = \
      sf.generate_sorted_listed_hist_of_key_grouped_by_column('extension', 'nel', int)
    sf.extensions['hist_by_size'] = \
      sf.generate_sorted_listed_hist_of_key_grouped_by_column('extension', 'size', float)

  def generate_sorted_listed_hist_of_key_grouped_by_column(sf, key, column, type):
    result = sf.filter_df_excluding_static_rules(sf.files, key)
    result = result[[key, column]]
    result[[column]] = result[[column]].astype(type)
    result = result.groupby(key).sum()
    result = result.sort([column], ascending=[0])
    return [[result[column].index[idx], result[column][idx]]
      for idx, val in enumerate(result[column])]

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

  def filter_df_excluding_static_rule(sf, df, column, type):
    if sf.static['excluded'][column][type]:
        compared_set = set(sf.static['excluded'][column][type])
        for item in compared_set:
          if len(df[df[type] == item][type]):
            if column not in sf.structure['excluded']: sf.structure['excluded'][column] = dict()
            if type not in sf.structure['excluded'][column]:
              sf.structure['excluded'][column][type] = []
            if item not in sf.structure['excluded'][column][type]:
              sf.structure['excluded'][column][type].append(item)
        df = df[~df[type].isin(compared_set)]
    return df

  def filter_df_excluding_static_rules(sf, df, column):
    filtered_df = df
    if column in sf.static['excluded']:
      filtered_df = sf.filter_df_excluding_static_rule(filtered_df, column, 'extension')
      filtered_df = sf.filter_df_excluding_static_rule(filtered_df, column, 'file')
    return filtered_df

  def convert_df_column_to_hist(sf, df, column):
    filtered_df = sf.filter_df_excluding_static_rules(df, column)
    return filtered_df[column].value_counts().to_dict()

  def get_summary_indicators_from_hist(sf, hist, int_index=False):
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
      index_total = sum([seriesHist[i] * index_list[i] for i in range(len(index_list))])
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
    """
    Finds the paths that match the max values for a given key and
    inserts them into the passed max dict.
    """
    filtered_df = sf.filter_df_excluding_static_rules(df, key)
    max['freq']['paths'] = filtered_df.loc[filtered_df[key] ==
      str(max['freq']['index'])]['path'].tolist()
    if 'index' in max:
      max['index']['paths'] = filtered_df.loc[filtered_df[key] ==
        str(max['index']['index'])]['path'].tolist()

  def find_max_paths_in_files(sf, max, key):
    sf.find_max_paths(sf.files, max, key)
    
  def find_max_paths_in_dirs(sf, max, key):
    sf.find_max_paths(sf.dirs_df, max, key)
