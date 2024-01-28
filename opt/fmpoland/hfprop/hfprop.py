#!/usr/bin/python3
# coding=utf-8
# Simple script in Python3 to generate tcl file for svxlink
# with HF propagation conditions from https://www.hamqsl.com
#

from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError
import ssl, os
import xml.dom.minidom


req = Request("https://www.hamqsl.com/solarxml.php")

try:
 r = urlopen(req) 

except HTTPError as e:
   print("HTTP error, page not available")
   if os.path.exists("/var/spool/svxlink/bulletins/hfprop.tcl"):
      os.remove("/var/spool/svxlink/bulletins/hfprop.tcl")   
   #file.write("playMsg \"HFProp\" \"nodata\";\n")

except URLError as e:
   print("URL error, page not available")
   if os.path.exists("/var/spool/svxlink/bulletins/hfprop.tcl"):
      os.remove("/var/spool/svxlink/bulletins/hfprop.tcl")   
   #file.write("playMsg \"HFProp\" \"nodata\";\n")

else:
   file = open("/var/spool/svxlink/bulletins/hfprop.tcl", "w", encoding="UTF-8", errors="ignore")
   file.write("playMsg \"HFProp\" \"hfprop\";\n")
   rString = r.read().decode("utf-8")
   xmldoc = xml.dom.minidom.parseString(rString)  
   #prettyxml = xmldoc.toprettyxml()                            
   #print(prettyxml)
   r.close()                                              
   sfi = xmldoc.getElementsByTagName('solarflux')[0].firstChild.nodeValue
   sfiv = int(sfi)

   file.write("playMsg \"HFProp\" \"sfi\";\n")
   file.write("playNumber "+sfi+";\n")

   if sfiv <= 70:
     file.write("playMsg \"HFProp\" \"sfi64-70\";\n")
   if sfiv > 70 and sfiv <= 90:
     file.write("playMsg \"HFProp\" \"sfi70-90\";\n")
   if sfiv > 90 and sfiv <= 120:
     file.write("playMsg \"HFProp\" \"sfi90-120\";\n")
   if sfiv > 120 and sfiv <= 150:
     file.write("playMsg \"HFProp\" \"sfi120-150\";\n")
   if sfiv > 150 and sfiv <= 200:
     file.write("playMsg \"HFProp\" \"sfi150-200\";\n")
   if sfiv > 200:
     file.write("playMsg \"HFProp\" \"sfi200-300\";\n")

   calcs = xmldoc.getElementsByTagName('calculatedconditions')
   ttime = 1
   for calc in calcs:
       bands = xmldoc.getElementsByTagName('band')
       for band in bands:
         name = band.getAttribute('name')
         time = band.getAttribute('time')
         condition = band.firstChild.nodeValue
         #print(band.tagName + ': ' + name + '\t Time: ' + time + '\t Cond:' +condition)
         if time == "day" and ttime == 1:
            file.write("playSilence 200;\n")
            file.write("playMsg \"HFProp\" \""+time+"\";\n")
            ttime = 2
         if time == "night" and ttime == 2:
            file.write("playSilence 200;\n")            
            file.write("playMsg \"HFProp\" \""+time+"\";\n")
            ttime = 3
         file.write("playSilence 200;\n")            
         file.write("playMsg \"HFProp\" \""+name+"\";\n")
         file.write("playMsg \"HFProp\" \""+condition+"\";\n")
  
   file.write("playSilence 200;\n")            
   file.write("playMsg \"HFProp\" \"vhfprop\";\n")
   calcvs = xmldoc.getElementsByTagName('calculatedvhfconditions')
   for calcv in calcvs:
       phenoms = xmldoc.getElementsByTagName('phenomenon')
       for phenom in phenoms:
         location = phenom.getAttribute('location')
         timev = phenom.getAttribute('name')
         convhf = phenom.firstChild.nodeValue
         if location == "northern_hemi":
            file.write("playSilence 200;\n")
            file.write("playMsg \"HFProp\" \"aurora\";\n")
            if convhf == "Band Closed": 
               auro = "noaurora"
            if convhf == "High LAT AUR": 
               auro = "high_aur"
            if convhf == "MID LAT AUR ": 
               auro = "mid_aur"
            file.write("playMsg \"HFProp\" \""+auro+"\";\n")
         # Band Closed, High MUF
         if location == "europe":
            file.write("playSilence 200;\n")
            file.write("playMsg \"HFProp\" \"2m\";\n")
            if convhf == "Band Closed": 
               con2m = "closed"
            if convhf == "High MUF": 
               con2m = "high_muf"
            if convhf == "144MHz ES": 
               con2m = "open"
            file.write("playMsg \"HFProp\" \""+con2m+"\";\n")
         # Band Closed, 50Mhz ES
         if location == "europe_6m":
            file.write("playSilence 200;\n")
            file.write("playMsg \"HFProp\" \"6m\";\n")
            if convhf == "Band Closed": 
               con6m = "closed"
            if convhf == "50MHz ES": 
               con6m = "open"
            file.write("playMsg \"HFProp\" \""+con6m+"\";\n")
         # Band Closed, 70MHZ ES
         if location == "europe_4m":
            file.write("playSilence 200;\n")
            file.write("playMsg \"HFProp\" \"4m\";\n")
            if convhf == "Band Closed": 
               con4m = "closed"
            if convhf == "70MHz ES": 
               con4m = "open"
            file.write("playMsg \"HFProp\" \""+con4m+"\";\n")


   file.write("playSilence 200;\n")
   #file.write("playMsg \"HFProp\" \"source\";\n")
   file.close()
