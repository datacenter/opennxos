#! /usr/bin/python

import requests, json, sys

switch_IPs_file = sys.argv[1]
version_expected = sys.argv[2]
switchuser = 'admin'
f = open('credentials', 'r')
switchpassword = f.readline()

myheaders={'content-type':'application/json-rpc'}
payload=[
  {
    "jsonrpc": "2.0",
    "method": "cli",
    "params": {
      "cmd": "show version",
      "version": 1
    },
    "id": 1
  }
]

f = open(switch_IPs_file, 'r')
for IP in f:
    IP = IP.strip("\n")
    url = "http://%s/ins" % (IP)
    response = requests.post(url, data = json.dumps(payload), headers = myheaders,
                             auth = (switchuser, switchpassword)).json()
    version = response['result']['body']['rr_sys_ver']
    if (version == version_expected):
        print "Switch %s: right version" % (IP)
    else:
        print "Switch %s: incorrect version - %s" % (IP, version)
