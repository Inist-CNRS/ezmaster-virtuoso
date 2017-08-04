#!/usr/bin/python
# -*- coding: utf-8 -*-
"""Converts a config JSON file to a bash script, changing virtuoso.ini

The config.json file is in /tmp, and can be empty.
The first-level keys are section in virtuoso.ini
All the sub-keys are written in virtuoso.ini

Ex:

/tmp/config.json:

{
  "env": {
    "DBA_PASSWORD": "secret"
  },
  "Parameters": {
    "NumberOfBuffers": "170000",
    "MaxDirtyBuffers": "130000"
  }
}

will be outputted as:

export DBA_PASSWORD='secret'
crudini --set virtuoso.ini "Parameters" "NumberOfBuffers" "170000"
crudini --set virtuoso.ini "Parameters" "MaxDirtyBuffers" "130000"

"""
import json

FILE = open("/tmp/config.json", "r")
CONFIG = json.loads(FILE.read())

for section in CONFIG:
    for key in CONFIG[section]:
        value = CONFIG[section][key]
        if section == 'env':
            print "export " + key + "='" + value + "'"
        else:
            print 'crudini --set virtuoso.ini "' + section +'" "' +  key + '" "' + value + '"'
