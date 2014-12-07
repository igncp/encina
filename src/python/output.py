import pystache
import os
import json

templatefile = os.path.dirname(os.path.realpath(__file__)) + '/../output/templates/index.html'
templatefile = open(templatefile, 'r')
template = templatefile.read()

datafile = open('encina-report/data.json')
variables = json.load(datafile)

output = pystache.render(template, variables)

f = open('encina-report/index.html','w')
f.write(output)
f.close()