from psas_packet import io, messages
from contextlib import closing
import socket
import time

# Data type we're going to use
CMGS = messages.MESSAGES['CMGS']
ADIS = messages.MESSAGES['ADIS']

# Data to pack
data = {
    'Temp': 42.0, 
    'Hum': 78.3,
    'Soil': 23.8,
    'Light': 34.8,
    'CO2': 560.8,
    'R1_Power': 12.5,
    'R1_Current': 2.4
}

# Open a UDP socket
with closing(socket.socket(socket.AF_INET, socket.SOCK_DGRAM)) as sock:
    sock.bind(('', 0))
    sock.connect(('127.0.0.1', 35001))

    packed = CMGS.encode({'Temp':5})
    seq = messages.MESSAGES['SEQN'].encode({'Sequence': 0})
    head = messages.HEADER.encode(CMGS, int(time.time()))
    sock.send(seq + head + packed)
    packed = ADIS.encode({'VCC':6})
    seq = messages.MESSAGES['SEQN'].encode({'Sequence': 0})
    head = messages.HEADER.encode(ADIS, int(time.time()))
    sock.send(seq + head + packed)
    # Network IO class, with our socket as connection
    #net = io.Network(sock, "./packetLog")
  
    # send just data (no header)
    #             type, sequence no, data
    #net.send_data(ADIS,           0, data)
