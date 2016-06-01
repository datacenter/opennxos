#!/usr/bin/env python
import sys
import nxtoolkit.nxtoolkit as NX

f = open('credentials', 'r')
mgmt_ip = f.readline().rstrip('\n')
user = f.readline().rstrip('\n')
password = f.readline().rstrip('\n')

def main():
    # Login to Switch
    session = NX.Session("http://" + mgmt_ip, user, password)
    resp = session.login()
    if not resp.ok:
        print('%% Could not login to Switch')
        sys.exit(0)

    bgpSession = NX.BGPSession("65000")

    bgpDom = NX.BGPDomain("default")
    bgpDom.set_router_id("192.168.0.1")

    bgpPeer = NX.BGPPeer("192.168.0.2", bgpDom)
    bgpPeer.set_remote_as("65000")
    bgpPeerAf = NX.BGPPeerAF('ipv4-ucast', bgpPeer)
    bgpPeer.add_af(bgpPeerAf)

    bgpDom.add_peer(bgpPeer)
    bgpSession.add_domain(bgpDom)

    # Push the bgpSession to the switch
    resp = session.push_to_apic(bgpSession.get_url(bgpSession),
                                bgpSession.get_json())
    if not resp.ok:
        print('%% Could not push configuration to Switch')
        print(resp.text)

if __name__ == '__main__':
    main()
