#! /usr/bin/python

import os
import json

f = os.popen("dohost \"sh int status | json\"")
s = f.read()
int_status = json.loads(s)

for int in int_status["TABLE_interface"]["ROW_interface"]:
    print "%s\t" % (int["interface"]),
    if "name" in int:
print "%s\t" % (int["name"]),
    else:
 
print "--\t",
    print int["state"]
