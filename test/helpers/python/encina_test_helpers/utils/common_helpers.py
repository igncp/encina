import os
import shutil
import subprocess


class Common_Helpers:
  def generate_report(self):
    return os.system('cd .tmp; ../bin/encina.js examine .. > /dev/null')

  def spawn_server(self):
    os.system('fuser -k -n tcp 9993 -s > /dev/null')
    os.chdir('.tmp')
    subprocess.Popen(['../bin/encina.js', 'server'], stdout=open(os.devnull, 'wb')) # Spawn process
    os.chdir('..')

  def tear_up(self):
    self.create_tmp_directory()
    self.spawn_server()
    self.generate_report()
      
  def tear_down(self):
    self.remove_tmp_directory()

  def create_tmp_directory(self):
    if not os.path.isdir('.tmp'):
      os.makedirs('.tmp')

  def remove_tmp_directory(self):
    shutil.rmtree('.tmp')
