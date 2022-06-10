
Program SA818 during start system

You must remove char # in /etc/rc/local in line:

#/opt/sa818/trx/prog.sh


Parameters configuration files:
------------------------------

trx.conf:
=========

AT+DMOSETGROUP=BW，TX_F，RX_F，Tx_CTCSS，SQ，Rx_CTCSS

BW: 0 wide FM , 1 narrow FM

SQ: squelch level, 0 open squelch, min 1, max 8

TX_F, RX_F freq. TRX in format: 432.8750  itp

Tx_CTCSS, Rx_CTCSS:

0000  disable

or following code for CTCSS see below


flt.conf
========

AT+SETFILTER=PRE/DE-EMPH, HIGHPASS, LOWPASS

PRE/DE-EMPH:
 1: emphasis bypass
 0: emphasis normal
HIGHPASS:
 1: voice_highpass_filter_bypass
 0: voice_highpass_filter normal
LOWPASS:
 1: voice_lowpass_filter_bypass
 0: voice_lowpass_filter normal


vol.conf
========

AT+DMOSETVOLUME=X

X is the volume level, the range is 1---8.


Please not use CTCSS frequencies below 91.5 Hz with the SA818 module.
------------------------------
CTCSS code:

         FRQ     CODE
	 67.0 :  0001 
	 71.9 :  0002 
	 74.4 :  0003 
	 77.0 :  0004 
	 79.7 :  0005 
	 82.5 :  0006 
	 85.4 :  0007 
	 88.5 :  0008 
	 91.5 :  0009 
	 94.8 :  0010 
	 97.4 :  0011 
	 100.0 :  0012 
	 103.5 :  0013 
	 107.2 :  0014 
	 110.9 :  0015 
	 114.8 :  0016 
	 118.8 :  0017 
	 123.0 :  0018 
	 127.3 :  0019 
	 131.8 :  0020 
	 136.5 :  0021 
	 141.3 :  0022 
	 146.2 :  0023 
	 151.4 :  0024 
	 156.7 :  0025 
	 162.2 :  0026 
	 167.9 :  0027 
	 173.8 :  0028 
	 179.9 :  0029 
	 186.2 :  0030 
	 192.8 :  0031 
	 203.5 :  0032 
	 210.7 :  0033 
	 218.1 :  0034 
	 225.7 :  0035 
	 233.6 :  0036 
	 241.8 :  0037 
	 250.3 :  0038 

