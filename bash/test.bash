echo "[Flatnode] Installatie is gestard!"
sleep 5s
apt install docker 
systemctl enable --now docker
mkdir -p /etc/pterodactyl
curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_$([[ "$(uname -m)" == "x86_64" ]] && echo "amd64" || echo "arm64")"
chmod u+x /usr/local/bin/wings
curl -o /etc/systemd/system/wings.service https://raw.githubusercontent.com/ZelixNode/wings/main/wings.service


echo "ssl domein"

read ssldomein

apt install nginx -y
sudo apt update
sudo apt install -y certbot
sudo apt install -y python3-certbot-nginx

certbot certonly --nginx -d $ssldomein