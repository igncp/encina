import sys
import os

helpers_path = os.path.realpath(os.path.dirname(__file__) + '../../../helpers/python/')
fixtures_path = os.path.realpath(os.path.dirname(__file__) + '../../../fixtures/python/')
src_path = os.path.realpath(os.path.dirname(__file__) + '../../../../src/data-analysis/')

sys.path.insert(0, helpers_path)
sys.path.insert(0, fixtures_path)
sys.path.insert(0, src_path)

import encina_test_helpers.imports.common_modules as modules
from mock import MagicMock
import pandas