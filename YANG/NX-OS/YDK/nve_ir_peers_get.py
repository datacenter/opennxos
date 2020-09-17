#! /usr/bin/python

import logging
from ydk.providers import NetconfServiceProvider
from ydk.services import CRUDService
from ydk.models.cisco_nx_os import Cisco_NX_OS_device
from ydk.filters import YFilter

def dump(obj):
   for attr in dir(obj):
       if hasattr( obj, attr ):
           print("obj.%s = %s" % (attr, getattr(obj, attr)))

def setup_logger():
   logger = logging.getLogger("ydk")
   logger.setLevel(logging.DEBUG)
   handler = logging.StreamHandler()
   formatter = logging.Formatter(("%(asctime)s - %(name)s - " \
                                  "%(levelname)s - %(message)s"))
   handler.setFormatter(formatter)
   logger.addHandler(handler)

def crud_read(obj):
   crud = CRUDService()
   ncc = NetconfServiceProvider(address='93180-EX-1',
                                username='admin', password='cisco')
   return crud.read(ncc, obj)

def get_dy_ir_peers():
   s = Cisco_NX_OS_device.System()
   l = s.eps_items.epid_items.EpList()
   l.peers_items.dyn_ir_peer_items.yfilter = YFilter.read
   s.eps_items.epid_items.ep_list.append(l)

   result = crud_read(s)
   peer_list = result.eps_items.epid_items.ep_list[0].peers_items.dyn_ir_peer_items.dyirpeer_list
   for peer in peer_list:
      # dump(peer)
      print("---> Peer-IP = %s, State = %s, Created = %s" % \
            (peer.ip, peer.state, peer.createts))

setup_logger()
get_dy_ir_peers()



