#!/usr/bin/env python
from __future__ import print_function
from ydk.types import Empty, DELETE, Decimal64
from ydk.services import CRUDService
import logging

from session_mgr import establish_session, init_logging
from ydk.models.openconfig.openconfig_interfaces import Interfaces
from ydk.errors import YPYError

def print_interface(interface):
    print('Interface %s' % interface.name)
    print('Interface IP %s' %
          interface.subinterfaces.subinterface[0].ipv4.addresses.address[0].ip)

def read_interface(crud_service, provider):
    interfaces_filter = Interfaces.Interface()
    interfaces_filter.name = "eth1/1"
    try:
        interface = crud_service.read(provider, interfaces_filter)
        print_interface(interface)
    except YPYError:
        print('An error occurred reading interfaces.')

if __name__ == "__main__":
    init_logging()
    provider = establish_session()
    crud_service = CRUDService()
    read_interface(crud_service, provider)
