#!/usr/bin/env python2
import socket
import sys
import os
import json
import datetime
import argparse

def recv_data(the_socket):
    total_data=[]
    while True:
        data = the_socket.recv(8192)
        if not data: break
        total_data.append(data)
    return ''.join(total_data)

parser = argparse.ArgumentParser()
parser.add_argument('-s', '--socket', help='Fastd socket file', required=True)
args = vars(parser.parse_args())

client = socket.socket( socket.AF_UNIX, socket.SOCK_STREAM )
try:
    client.connect(args['socket'])
    message = recv_data(client)
    connected_peers = 0
    try:
        fastd_data = json.loads(message.decode('utf-8'))
        for peer in fastd_data["peers"]:
                if fastd_data["peers"][peer]["connection"]:
                    connected_peers +=1
        # print(str(len(fastd_data["peers"])) + " " + str(connected_peers))
        print(str(connected_peers))
    except (ValueError, KeyError, TypeError):
        print("-1")
        # print "JSON format error"
except:
    pass
