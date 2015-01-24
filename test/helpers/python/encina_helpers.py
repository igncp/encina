import utils.modules as m
import driver.base as driver
import os
import shutil
import subprocess


def generate_report():
  os.system('cd .tmp; ../bin/encina.js examine .. > /dev/null')


def spawn_server():
  os.system('fuser -k -n tcp 9993 -s > /dev/null')
  os.chdir('.tmp')
  subprocess.Popen(['../bin/encina.js', 'server'], stdout=open(os.devnull, 'wb')) # Spawn process
  os.chdir('..')


def tear_up():
  create_tmp_directory()
  spawn_server()
  generate_report()

    
def tear_down():
  remove_tmp_directory()


def create_tmp_directory():
  if not os.path.isdir('.tmp'):
    os.makedirs('.tmp')


def remove_tmp_directory():
  shutil.rmtree('.tmp')


class FrontendTestcase(m.unittest.TestCase):
  @classmethod
  def setUpClass(cls):
    tear_up()
  
  @classmethod
  def tearDownClass(cls):
    tear_down()

  def setUp(self):
    self.s = driver.Base()

  def tearDown(self):
    self.s.close_browser()


class FrontendVisualTestcase(FrontendTestcase):
  mode = 'visual'


class FrontendHeadlessTestcase(FrontendTestcase):
  mode = 'headless'
