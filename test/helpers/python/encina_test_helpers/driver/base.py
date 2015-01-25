import time
import os

from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By

from pyvirtualdisplay import Display


class Base:
  def __init__(self):
    self.start_driver()

  def start_driver(self):
    if os.getenv('ENCINA_TEST_MODE', 'visual') == 'visual':
      chrome_options = Options()
      chrome_options.add_argument('--test-type') # Remove the yellow flag
      self.d = webdriver.Chrome(chrome_options=chrome_options)
      self.d.set_window_position(1400, 0)
      self.d.maximize_window()
    elif os.getenv('ENCINA_TEST_MODE', 'visual') == 'headless':
      display = Display(visible=0, size=(800, 600))
      display.start()
      self.d = webdriver.Chrome()
    self.base_url = 'http://localhost:9993'

  def go_to(self, relative_url):
    self.d.get(self.base_url + relative_url)

  def wait_until_presence_of_element_located(self, condition):
    self.wait().until(EC.presence_of_element_located(condition))

  def wait_until_element_to_be_clickable_by_css_selector_and_click(self, selector, number=1):
    self.wait_until_element_to_be_clickable_by_css_selector(selector)
    self.click_element_by_css_selector(selector, number)

  def wait_until_element_to_be_clickable_by_css_selector(self, selector):
    self.wait().until(EC.element_to_be_clickable((By.CSS_SELECTOR, selector)))

  def wait_until_element_to_be_clickable_by_id(self, id):
    self.wait().until(EC.element_to_be_clickable((By.ID, id)))

  def wait_until_element_to_be_clickable_by_id_and_click(self, id, wait=0):
    self.wait_until_element_to_be_clickable_by_id(id)
    time.sleep(wait)
    self.click_element_by_id(id)

  def wait_until_presence_of_input_located_by_name(self, name):
    self.wait_until_presence_of_element_located((By.NAME, name))

  def wait_until_presence_of_element_located_by_css_selector(self, selector):
    self.wait_until_presence_of_element_located((By.CSS_SELECTOR, selector))

  def click_element_by_id(self, id):
    self.d.find_element_by_id(id).click()

  def click_element_by_css_selector(self, selector, number=1):
    self.d.find_elements_by_css_selector(selector)[number - 1].click()

  def close_browser(self):
    self.d.close()

  def wait(self, time=10):
    return WebDriverWait(self.d, time)

  def script(self, script_string):
    self.d.execute_script(script_string)
