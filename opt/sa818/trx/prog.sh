#!/bin/sh -e

# Set TRX Config for Hotspot 
# 
#   OZPI UART1 ttyS1 (board ROLINK), 
#   OZPI UART2 ttyS2 (board SPOTNIK)

stty 9600 -F /dev/ttyS2

cat /opt/sa818/trx/trx.conf >> /dev/ttyS2; sleep 0.1
cat /opt/sa818/trx/vol.conf >> /dev/ttyS2; sleep 0.1
cat /opt/sa818htrx/flt.conf >> /dev/ttyS2; sleep 0.1

