Instalacja pakietow wymaganych dla PERL

apt install -y libjson-perl libwww-perl


W pliku wx.pl należy wpisac
---------------------------

Musisz wygenerowac darmowy API Key na stronie https://openweathermap.org
który należy wpsiać w:

$apikey=


nalezy podac współrzedne geograficzne miejsac dla którego bedzie pobierany info o pogodzie
możesz wspolrzedne pobrac z google map:

$lat= (szerkosc) 
$lon= (długość) 

Skopiowac plik wx-cron do katalogu /etc/cron.d

System pobiera dane po pelnej godzinie 28 min i 58 min z https://openweathermap.org

Jesli chcesz sprawdzac pogode poprzez DTMF kod: 60# 



