import importer
h = importer.common.h # Encina Helpers


class MainTestCase(importer.common.BackendTestcase):
  def creates_self_report_test(self):
    """ Exits from creation of a Encina Report of current project
    with 0 status """
    exit_code = h.generate_report()
    self.assertEquals(exit_code, 0)
