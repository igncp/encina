import encina_test_helpers.imports.common_modules as modules
from encina_test_helpers.utils.common_helpers import Common_Helpers

h = Common_Helpers()


class BackendTestcase(modules.unittest.TestCase):
  @classmethod
  def setUpClass(cls):
    h.create_tmp_directory()

  @classmethod
  def tearDown(cls):
    h.remove_tmp_directory()
