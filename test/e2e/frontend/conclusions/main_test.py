import importer


class MainTestCase(importer.common.FrontendTestcase):
  def test_gets_to_conclusions_site(self):
    """ The conclusions page is loaded """
    self.s.go_to('/conclusions')
    relative_url = self.s.get_current_relative_url()
    self.assertEquals(relative_url, '/#conclusions')
