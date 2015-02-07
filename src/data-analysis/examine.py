"""
The process of generating the data.
"""

from examine.initialization import Data

data = Data()

data.set_root_data()
data.set_structure()
data.set_tree_and_extras()

data.process_files_data()
data.process_dirs_data()

data.recollect_git_info_if_necessary()
data.process_git_info_if_necessary()

data.save_file()
