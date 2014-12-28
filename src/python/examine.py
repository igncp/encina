from examine.initialization import Data

data = Data()

data.set_root_data()
data.set_structure()
data.set_tree_and_extras()
data.calculate_lines_mean()

data.save_file()