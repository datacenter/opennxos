#! /usr/bin/python
import logging
from ydk.providers import NetconfServiceProvider
from ydk.services import CRUDService
from ydk.models.cisco_nx_os import Cisco_NX_OS_device
from ydk.filters import YFilter

def setup_logger():
   logger = logging.getLogger("ydk")
   logger.setLevel(logging.DEBUG)
   handler = logging.StreamHandler()
   formatter = logging.Formatter(("%(asctime)s - %(name)s - " \
                                  "%(levelname)s - %(message)s"))
   handler.setFormatter(formatter)
   logger.addHandler(handler)

setup_logger()

crud = CRUDService()
ncc = NetconfServiceProvider(address='93180-EX-1',
                             username='admin', password='cisco')

s = Cisco_NX_OS_device.System()
l = s.bd_items.bd_items.BDList()
l.fabencap = 'vlan-123'
l.name = 'ydk-vlan'
l.accencap = 'vxlan-90001'
s.bd_items.bd_items.bd_list.append(l)

crud.create(ncc, s)
