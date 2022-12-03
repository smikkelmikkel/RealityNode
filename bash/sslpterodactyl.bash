echo "Typ je domein (panel.domein.nl): "

read domein

echo "Typ je domein (node.domein.nl): "

read node

# Variables

FQDN=`hostname --ip-address`

# Certificatie paneel aanmaken

sudo apt update
sudo apt install -y certbot
sudo apt install -y python3-certbot-nginx

certbot certonly --nginx -d $domein
certbot certonly --nginx -d $node
certbot renew
systemctl stop nginx
certbot renew
systemctl start nginx

# pterodactyl.conf goed zetten
curl -o /etc/nginx/sites-available/pterodactyl.conf https://raw.githubusercontent.com/smikkelmikkel/pterodactyl.bash/main/pterodactyl.conf
sed -i -e "s/<domain>/$domein/g" /etc/nginx/sites-available/pterodactyl.conf

## Zet config.yml goed
wget https://raw.githubusercontent.com/Thomascap/ptero/main/config.yml
sed -i -e "s/<fqdn>/${domein}/g" /etc/pterodactyl/config.yml

cd /var/www/pterodactyl 
php artisan command:node --fqdn=$node
php artisan command:node --scheme="https"

# Herstart de services
systemctl restart nginx
systemctl disable --now wings
systemctl enable --now wings