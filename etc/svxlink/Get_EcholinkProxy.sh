#!/bin/bash

#
#	Copyright (C) 2017 Michel GACEM, F1TZO - French Open Networks Project
#
#	This program is free software; you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation; version 2 of the License.
#
#	This program is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
#	This script allows you to search for Free Echolink PUBLIC Proxies
#	It test and select the one that will have answered the fastest
#	The selection is made on a single test so as not to take too long
#	The result is given by BPROXY variables (such as BestProxy)
#	With the purely informative BLAT variable (such as Best Latency)

LAT=9999
BLAT=9999

lynx -dump http://www.echolink.org/proxylist.jsp | grep Ready | grep 8100 | gawk -F '[[:space:]][[:space:]]+' '{ print $3 }' | grep -v ":" | grep -v "192." | grep -v "51."|grep -v "44."> /tmp/List-Free.txt
NBP=`wc /tmp/List-Free.txt | gawk '{ print $1 }'`g

while read PROXY
do
	LAT=`ping -q -c 1 -W 1 $PROXY | grep rtt | gawk  -F "/" '{ print $6 }'`
	echo "PROXY="$PROXY" LAT="$LAT
	LAT=${LAT%.*}
	LAT="${LAT:-9999}"
	if [ $LAT -lt $BLAT ]
	then
		BLAT=$LAT
		BPROXY=$PROXY
	fi
done < /tmp/List-Free.txt

echo "Nowy publiczny proxy server: " $BPROXY" srednia wartosc latecy: "$BLAT
echo "Wybrany z najnizszym latency z "$NBP" Proxy serverow"

#
# On genere le nouveau fichier ModuleEchoLink.conf
# We create the new ModuleEchoLink.conf file
#
rm /tmp/new.conf
IFS=''
while read -r LIGNE
do
        if  echo "$LIGNE" | grep -q PROXY_SERVER
        then
                LIGNE="PROXY_SERVER="$BPROXY
        fi
        if  echo "$LIGNE" | grep -q PROXY_PASSWORD
        then
                LIGNE="PROXY_PASSWORD=PUBLIC"
        fi
        echo $LIGNE >> /tmp/new.conf
done < /etc/svxlink/svxlink.d/ModuleEchoLink.conf

#
# We replace the old ModuleEchoLink.conf by the new one
#
cp /tmp/new.conf /etc/svxlink/svxlink.d/ModuleEchoLink.conf
#
# We restart SVXlink in a Screen 
# 
systemctl restart svxlink

