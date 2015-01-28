import sys
import os

helpers_path = os.path.realpath(os.path.dirname(__file__) + '../../../helpers/python/')
sys.path.insert(0, helpers_path)

import encina_test_helpers.driver.base as driver
import encina_test_helpers.imports.common_modules as modules
from encina_test_helpers.utils.common_helpers import Common_Helpers

h = Common_Helpers()


class FrontendTestcase(modules.unittest.TestCase):
  @classmethod
  def setUpClass(cls):
    h.tear_up()
  
  @classmethod
  def tearDownClass(cls):
    h.tear_down()

  def setUp(self):
    self.s = driver.Base()

  def tearDown(self):
    self.s.close_browser()

  def assert_page_contains_elements_by_css_selector(self, selector, required_count=None):
    self.s.wait_until_presence_of_element_located_by_css_selector(selector)
    elements = self.s.d.find_elements_by_css_selector(selector)
    elements_count = len(elements)
    self.assertTrue(elements_count > 0)
    if required_count is not None:
      self.assertEquals(elements_count, required_count)
