
Instalacje pakietu 

sudo apt install -y libjson-perl libwww-perl

Musisz wybrac strefy jedna lub dwie dla których chcesz miec
informacje o stopniu zagrozenia pozarowego

Wykaz stref
https://www.traxelektronik.pl/pogoda/las/zbiorcza.php

Mapa stref

https://bazapozarow.ibles.pl/zagrozenie/

Wpisz nazwe strey w pliku zplas.pl w wierszu

my @zone=("12_D");

lub jesli chcesz miec więcej niz jedną strefe to zrob to jak w przykładzie poniżej

my @zone=("12_A","12_B");

Pamietaj aby litera w nazwie strefy była pisana duża litera

Kod DTMF 62#  odtwarza na żądanie treść komunikatu

Wersja skryptu zplas2.pl zawiera dodatkowo informacje o prognozie zagrozenia pozarowego
ale ponieważ moje obserwacje tych danych pokazją ze sa duze rozbieznosci miedzy prognoza
a pozniejszymi pomiarami w podstawowej wersji zplas.pl nie podawalem prognozy
Jesli chcesz uzywac wersji z prognoza w pliku zplas-cron zmien nazwe skryptu z zplas.pl
na zplas2.pl

Jesli chcesz w komunkatach godzinnych miec informacje o telefonie 112 i jak raportowac
usun znaki # przed liniami w plik zplas.pl lub zplas2.pl:

  #print ZP "playMsg \"ZPLas\" \"info\";\n";
  #print ZP "playSilence 100;\n";

oraz wstaw znak komentarz # w pliku /usr/share/svxlink/events.d/local/MeteoInfo.tcl 
w lini 123:

     # playMsg "ZPLas" "info"

Skopiuj plik zplas-cron do katalogu /etc/cron.d/
Plik ten cyklicznie co 30 min pobiera dane miedzy 5 a 23 godzina

Informacje o stopniu zagrozenia pozarowego lasu sa dostepny w miesiacach Marzec-Wrzesien











