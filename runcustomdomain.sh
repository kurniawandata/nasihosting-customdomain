#!/bin/bash
echo "Content-type: text/html"
echo ""
name=`echo "$QUERY_STRING" | awk '{split($0,array,"&")} END{print array[1]}' | awk '{split($0,array,"=")} END{print array[2]}' | tr [:upper:] [:lower:]`
domain=`echo "$QUERY_STRING" | awk '{split($0,array,"&")} END{print array[2]}' | awk '{split($0,array,"=")} END{print array[2]}'`
cek=`echo "$QUERY_STRING" | awk '{split($0,array,"&")} END{print array[3]}' | awk '{split($0,array,"=")} END{print array[2]}'`
if [ -z "$(ls -A /home/$name)" ]; then
echo "Subdomain yang anda masukkan belum terdaftar"
else
line=$(head -n 1 kode2.txt)
tanggal=$(date +%d-%m-%Y)
sub=$name.nasihosting.com
if [[ "${name}" =~ [^a-z0-9] ]]; then
echo "Subdomain hanya boleh huruf kecil dan angka"
else
if [[ "${domain}" =~ [^a-z0-9.] ]]; then
echo "Domain hanya boleh huruf kecil, angka dan titik"
else
if [[ $domain =~ "nasihosting" ]]; then
echo "Tidak bisa menggunakan subdomain nasihosting.com untuk domain"
else
if [[ $domain =~ "www" ]]; then
echo "Tidak boleh pakai www"
else
if [[ $domain =~ "xcode" ]]; then
echo "Tidak bisa menggunakan subdomain xcode.or.id untuk domain"
else
if [[ $domain =~ "nasiwebhost" ]]; then
echo "Tidak bisa menggunakan subdomain nasiwebhost.com untuk domain"
else
if [[ "$cek" != "$line" ]]; then 
echo "Kode keamanan berubah atau salah tulis captcha, silahkan refresh dan daftar kembali"
else
if [ -z "$(ls -A /etc/apache2/sites-available/$domain.conf)" ]; then
acak=$(tr -dc a-z0-9 </dev/urandom | head -c 5 ; echo '')
echo $acak > kode2.txt
convert \
    -size 225x100 \
    xc:lightblue \
    -font Bookman-DemiItalic \
    -pointsize 18 \
    -fill blue \
    -gravity center \
    -draw "text 0,0 $acak" \
    image2.png
convert image2.png -background white -wave 4x55 image2.png
sudo cp /usr/lib/cgi-bin/image2.png /var/www/html
echo $name, $domain, $tanggal. > /home/datadomain/$domain.$tanggal
cp /etc/apache2/sites-available/$name.conf /etc/apache2/sites-available/$domain.conf
sed -i "s/$name.nasihosting.com/$domain/g" /etc/apache2/sites-available/$domain.conf
sudo a2ensite $domain.conf
sudo systemctl reload apache2
sudo cp aktivasi5.sh aktivasi6.sh
sed -i "s/unik/$domain/g" aktivasi6.sh
chmod 777 aktivasi6.sh
./aktivasi6.sh
rm aktivasi6.sh
cat <<EOT
<!DOCTYPE html>
<html>
<head>
<title>Nasihosting</title>
</head>
<body>
<h2>Welcome $name </h1>
<br>
<center>Domain sudah aktif</center>
<br>
<br />
<br>
</body>
</html>
EOT
else
echo "Domain yang anda masukkan sudah terdaftar"
fi
fi
fi
fi
fi
fi
fi
fi
fi
