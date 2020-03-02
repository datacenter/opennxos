
import requests
import base64
import yaml

import os
from jinja2 import Environment, FileSystemLoader, select_autoescape

auth = base64.b64encode('admin:password')
headers = {
    'authorization': 'Basic %s' % auth,
    'content-type': "application/yang.data+xml"
    }

def enable_features(device,role):
    payload = load_models(device, 'models/{0}/'.format(role),'features.txt')
    send_payload(device,payload)

def configure_interfaces(device,role):
    payload = load_models(device, 'models/{0}/'.format(role),'interfaces.txt')
    send_payload(device,payload)

def configure_underlay(device,role):
    payload = load_models(device, 'models/{0}/'.format(role),'underlay.txt')
    send_payload(device,payload)


def configure_overlay(device,role):
    payload = load_models(device, 'models/{0}/'.format(role),'overlay.txt')
    send_payload(device,payload)



def load_models(device,path,model):
    with open('host_vars/{0}.yml'.format(device), 'r') as f:
        config = yaml.load(f)
    env = Environment(loader=FileSystemLoader('models/leaf'),trim_blocks=True)
    template = env.get_template(model)
    return template.render(config)

def send_payload(device, payload):
    url = "http://{0}/restconf/data/Cisco-NX-OS-device:System".format(device)
    try:
        response = requests.request("PUT", url,data=payload,headers=headers)
    except requests.exceptions.RequestException as e:
        print e
        sys.exit(1)
    print response.status_code
    print response.content
    if response.status_code/100 != 2:
        print payload
        print response.content

def main():

    spines = ['n9kv-spine-1', 'n9kv-spine-2']
    leafs = ['n9kv-leaf-1', 'n9kv-leaf-2']

    for spine in spines:
        enable_features(spine,'spine')
        configure_interfaces(spine,'spine')
        configure_underlay(spine,'spine')
        configure_overlay(spine,'spine')

    for leaf in leafs:
        enable_features(leaf,'leaf')
        configure_interfaces(leaf,'leaf')
        configure_underlay(leaf,'leaf')
        configure_overlay(leaf,'leaf')


# Standard boilerplate to call the main() function to begin
# the program.
if __name__ == '__main__':
  main()
