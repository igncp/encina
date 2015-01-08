from examine.initialization import Data

data = Data()

data.set_root_data()
data.set_structure()
data.set_tree_and_extras()

data.process_files_data()
data.process_dirs_data()

data.save_file()
