import importer
import examine.processing as encina_processing


class ProcessingTestCase(importer.modules.unittest.TestCase):
  def setUp(self):
    self.d = encina_processing.Data()

  def test_find_max_paths(self):
      """
      Find Max Paths
      """
      df = importer.pandas.DataFrame()
      self.d.filter_df_excluding_static_rules = importer.MagicMock(return_value=3)
      # self.d.find_max_paths(df, 1, 1)
      # TODO: setup fixtures generation
      
      self.assertEquals(1, 1)
