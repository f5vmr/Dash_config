#!/usr/bin/perl
#
# SP2ONG Hydro Info script - poziom rzek
#  
#  Wykaz punktow pomiaru: https://hydro.imgw.pl/
#
# Potrzebny numer wodowskazu oraz plik wav z numerem wodowskazu
# gdzie nagranie zawiera nazwę wodowskazu np 154180150.wav
# Plik numer_wodowskazu.wav umiescic w /usr/share/svxlink/sounds/pl_PL/HydroInfo/
# 

########## Configuration 

# Lista ID wodowskazów

# dla jednego wodowskazu:
my @idstn=(153180090);

# kiedy więcej niż jeden wodowskaz użyj takiego zapisu:
#my @idstn=(151170030,150170040);

######################

use strict;
use warnings;
use JSON qw(decode_json);
use LWP::Simple qw(get);
use Data::Dumper;              

my $Htime;
my $time="";
my $h1=0;
my $m1=0;
my $ids;
my $alarm;
my $current;
my $warning;
my $trend;
my $data=0;

if (-e "/var/spool/svxlink/bulletins/hydro.tcl") { unlink "/var/spool/svxlink/bulletins/hydro.tcl" }; 

open(WX,">/var/spool/svxlink/bulletins/hydro.tcl");
print WX "playMsg \"HydroInfo\" \"hydro\";\n";
print WX "playSilence 200;\n";

for my $i (@idstn) {

my $url="https://hydro.imgw.pl/api/station/hydro/?id=$i";

my $decode = eval {decode_json(get($url))} ;

#print Dumper ($decode);


if(!$@){

if (length($decode)) {

$data = 1;

$alarm = $decode->{'status'}{'alarmValue'};
$warning = $decode->{'status'}{'warningValue'};
$current = $decode->{'status'}{'currentState'}{'value'};
$time = $decode->{'status'}{'currentState'}{'date'};
$trend = $decode->{'trend'};
$ids = $i;

 $Htime = substr $time,11,1;
 if ($Htime==0) {
  $h1=substr $time,12,1;
  } else { $h1 = substr $time,11,2;}
 $m1=substr $time,14,2;

  print WX "playMsg \"HydroInfo\" \"$ids\";\n";
  print WX "playMsg \"HydroInfo\" \"godzina_pomiaru\";\n";
  print WX "playTime $h1 $m1;\n";
  print WX "playSilence 100;\n";
  print WX "playMsg \"HydroInfo\" \"stan_aktualny\";\n";
  print WX "playSilence 100;\n";
  print WX "playNumber $current;\n";
  print WX "playMsg \"HydroInfo\" \"unit_cm\";\n";
  print WX "playSilence 100;\n";
  print WX "playMsg \"HydroInfo\" \"trend\";\n";
  print WX "playMsg \"HydroInfo\" \"$trend\";\n";

if ($current>$warning && $current < $alarm) {
  print WX "playSilence 100;\n";
  print WX "playMsg \"HydroInfo\" \"przekroczony_ostrz\";\n";
 }
if ($current>=$alarm) {
  print WX "playSilence 100;\n";
  print WX "playMsg \"HydroInfo\" \"przekroczony_alarm\";\n";
 }
  print WX "playSilence 300;\n";
  #print WX "playMsg \"HydroInfo\" \"hydro_source\";\n";

  }
 }
}
close(WX);

 if ( $data == 0) {
   if (-e "/var/spool/svxlink/bulletins/hydro.tcl") { unlink "/var/spool/svxlink/bulletins/hydro.tcl" }; 
}

