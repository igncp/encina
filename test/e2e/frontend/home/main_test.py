import importer


class MainTestCase(importer.common.FrontendTestcase):
  def test_chart_pies_present(self):
      """ Pie charts are present in the report """
      self.s.go_to('/')
      self.assert_page_contains_elements_by_css_selector('.chart-pie')
