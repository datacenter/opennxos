#! /usr/bin/python

import logging
from websocket import create_connection
from pprint import pprint
import sys
import requests
import json
import threading
import datetime
import time
import random
import os
import inspect
from urllib2 import HTTPError
import subprocess
import pyjsonrpc

http = "http"
nxapi_ip = "172.31.217.22"
nxapi_ip_switch = "172.31.217.22"
method = "jsonrpc"
session_id = ""
cookie = "INS-cookie=nocookie333"
url = "{0}://{1}/{2}/".format(http, nxapi_ip, method)
http_client = pyjsonrpc.HttpClient(url = url, cookies = cookie)
session = requests.session() 

ws_thread = None
ws_obj = None
ws_flag = 100
notification_count = 0

sub_id = 0
rf_thread = None

# Web Socket Thread 
class WsThread(threading.Thread):
    def run(self):
        global nxapi_ip_switch
        global cookie
        global ws_obj
        global ws_flag
        global notification_count
        
        # Create a web-socket 
        print "Create a web-socket:"
        ws = create_connection("ws://{0}/socket{1}".format(nxapi_ip_switch, cookie))
        print "The web-socket is successfully created."
        while ws_flag != 0:
            # Blocking call to recieve on socket
            resp =  ws.recv()
            notification_count = notification_count + 1
            print ("\nNew Incoming Notification <notif count:%d>" % (notification_count))
            ws_obj = json.loads(resp)
            print json.dumps(ws_obj, indent=4)
        ws.close()


# The refreshing thread: refresh the subscription to the MO every 30 seconds
# The subscription will expire every 60 seconds 
class RfThread(threading.Thread):
    def run(self):
        global cookie
        global session
        global seb_id
        global http
        global nxapi_ip

        print "The refreshing thread is created."
        # do refresh every 30 seconds:
        while(True):
            time.sleep(30)
            cookies2 = dict(cookies = "INS-cookie={0}".format(cookie))
            url = "{0}://{1}/api/subscriptionRefresh.json?id={2}".format(http, nxapi_ip, sub_id)
            session.get(url, cookies = cookies2)


# Login:
def login():
    global cookie
    global http_client
    global ws_thread
    global session
    global nxapi_ip
    global http

    # Login to the switch:
    print "Login to the switch with ip: {0}".format(nxapi_ip)
    url = "{0}://{1}/api/aaaLogin.json".format(http, nxapi_ip)

    data = json.dumps({"aaaUser" : {"attributes" : {"name" : "admin","pwd" : "my_password"}}})

    r = session.post(url, data)

    # Parse the received contents and extract the cookie 
    resp = json.loads(r.text)
    cookie = resp[u'imdata'][0][u'aaaLogin'][u'attributes'][u'token']

    # Establish the web-socket using the cookie
    http_client = pyjsonrpc.HttpClient(url = url, cookies = "INS-cookie={0}".format(cookie))
    
    # Create the web-socket thread, in order to listen to any
    # notification from MOs that we subscribed to 
    ws_thread = WsThread()
    ws_thread.start()


# Subscribe to the MO
def subscribe():
    global sc_thread
    global http_client
    global cookie
    global session
    global sub_id
    global http
    global nxapi_ip
    
    print "Subscribe to the MOs:"
    url2 = "{0}://{1}/api/node/mo/sys/phys-[eth1/42].json?query-target=subtree&subscription=yes"\
        .format(http, nxapi_ip)
    cookies2 = dict(cookies = "INS-cookie={0}".format(cookie))
    r2 = session.get(url2, cookies = cookies2)
    resp_obj = json.loads(r2.text)
    sub_id = resp_obj["subscriptionId"];


# 1. Login to the switch
login()

# 2. Wait for the web socket to be established
time.sleep(2)

# 3. Subscribe to the MOs
subscribe()

# 4. initiate the subscription refresh thread, and refresh every 30 seconds
rf_thread = RfThread()
rf_thread.start()

print "subscribed to any changes on e1/42"
