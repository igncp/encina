import sys
import os

helpers_path = os.path.realpath(os.path.dirname(__file__) + '../../../helpers/python/')
sys.path.insert(0, helpers_path)
import encina_helpers as h


class MainTestCase(h.FrontendVisualTestcase):
  def testUnity(self):
    """ Main Test """
    self.s.go_to('/')
    self.assertEquals(1, 1)
