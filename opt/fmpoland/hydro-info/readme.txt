
Instalacje pakietu 

sudo apt install -y libjson-perl libwww-perl

Jesli w Twojej okolicy jest dostepna informacja o pomiarach wodowskazu
na rzece możesz sprawdzic to na mapie

https://hydro.imgw.pl

Wodowskazy sa zaznaczone jako trójkąty

Otwierajac informacje na mapie o wodowskazie obok nazwy w nawiasie bedzie informacje o ID 
wodowkazu np 

 SOBIANOWICE (151220100)

Musisz spisac ten ID  w pliku hydro.pl dla jednego wodowskazu:

my @idstn=(153180090);

kiedy więcej niż jeden wodowskaz użyj takiego zapisu:

my @idstn=(153180090,153180080);


Zrob kopie pliku hydro-cron do katalogu /etc/cron.d/

Plik ten bedzie cyklicznie pobieral dane co 1 godzine miedzy 5 a 23

Uzyj kodu DTMF 64#  aby odtworzyc tresc komunikatu
