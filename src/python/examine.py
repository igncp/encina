from examine.initialization import Data

data = Data()

data.get_total_files_and_dirs()
data.set_tree_and_extras()
data.calculate_lines_mean()

data.save_file()