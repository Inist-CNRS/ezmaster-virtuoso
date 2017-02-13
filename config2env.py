#!/usr/bin/python
# -*- coding: utf-8 -*-
"""Converts a config JSON file to an environment bash script.

The config.json file is in /tmp, and has an optional "env" key.
All these env sub-keys will be translated.

Ex:

/tmp/config.json:

{
  "env": {
    "PASS": "WORD",
    "another": "one"
  }
}

will be outputted as:

export PASS='WORD'
export another='one'

"""
import json

FILE = open("/tmp/config.json", "r")
CONFIG = json.loads(FILE.read())

if 'env' in CONFIG:
    for key in CONFIG['env']:
        value = CONFIG['env'][key]
        print "export " + key + "='" + value + "'"
