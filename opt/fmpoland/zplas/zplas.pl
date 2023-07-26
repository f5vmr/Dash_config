#!/usr/bin/perl
#
# SP2ONG  Zagrozenie pozarowe lasow v20230608
# zrodlo https://www.traxelektronik.pl/pogoda/las/zbiorcza.php
#        https://bazapozarow.ibles.pl/zagrozenie/

########## Configuration 

# Lista strefy zagrozen:
# 
#my @zone=("12_D");
#

my @zone=("12_D","12_E");

#
######################

use strict;
use warnings;
use JSON qw(decode_json);
use LWP::Simple qw(get);
use POSIX qw(strftime);
use Time::Piece;

my $hour=localtime->strftime('%H')*1;

#use Data::Dumper;              

# Zagrozenia pozarowe dla lasow API JSON dane
my $url="https://radioklub.pl/pi.wx/api/v1/lasy";

my $decode = eval {decode_json(get($url))};

#print Dumper ($decode);

if (-e "/var/spool/svxlink/bulletins/zplas.tcl") { unlink "/var/spool/svxlink/bulletins/zplas.tcl" };


if(!$@){

 open(ZP,">/var/spool/svxlink/bulletins/zplas.tcl");

 my $time = $decode->{'date'}{'report'}{'measurement'};
 my $timec = $decode->{'date'}{'report'}{'condition'};
 my $timef = $decode->{'date'}{'report'}{'forecast'};
 my $get = $decode->{'date'}{'report'}{'get'};

 my $Htime="";
 my $h="";
 my $m="";

 for my $i (@zone) {

  my $con="";
  my $zone = $decode->{'content'}{$i}{'zone'};
  my $condition = $decode->{'content'}{$i}{'condition'};

  print ZP "playMsg \"ZPLas\" \"biezace\";\n";
  print ZP "playSilence 100;\n";
  print ZP "playMsg \"ZPLas\" \"$zone\";\n";
  print ZP "playSilence 100;\n";

  $Htime = substr $time,11,1;
  if ($Htime==0) {
    $h=substr $time,12,1;
    } else { $h = substr $time,11,2;}
  $m=substr $time,14,2;

  print ZP "playMsg \"ZPLas\" \"godzina_pomiaru\";\n";
  if ($hour<$h && $h != 9) {
  print ZP "playMsg \"ZPLas\" \"wczoraj\";\n";}
  print ZP "playTime $h $m;\n";

  if ($condition == 0) { $con = "brak";}
  if ($condition == 1) { $con = "male";}
  if ($condition == 2) { $con = "srednie";}
  if ($condition == 3) { $con = "duze";}
  if ($condition == 9) { $con = "bdanych";}

  print ZP "playMsg \"ZPLas\" \"$con\";\n";
  print ZP "playSilence 100;\n";
  if ($condition == 2) { 
    print ZP "playMsg \"ZPLas\" \"badz_ostrozny\";\n";
    print ZP "playSilence 100;\n";
    }
  if ($condition == 3) { 
    print ZP "playMsg \"ZPLas\" \"zalecenia\";\n";
    print ZP "playSilence 100;\n";
   }

 }
#
# inforormacja o telefonie 112 i jak raportowac
#
  #print ZP "playMsg \"ZPLas\" \"info\";\n";
  #print ZP "playSilence 100;\n";

 close(ZP);
} 


