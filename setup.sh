#!/bin/bash
#install dependencies and update os
sudo apt update
apt install curl -y
curl -fsSL https://test.docker.com -o test-docker.sh
sudo sh test-docker.sh
systemctl start docker
docker version
apt install git -y

#clone app from git
cd ~
git clone https://github.com/laravel/laravel.git myapp/
cd myapp/

#run docker compose for installing app dependencies
docker run --rm -v $(pwd):/app composer install

#grant permission
sudo chown -R $USER:$USER ~/myapp

#Dockerizing the Laravel Project
cd myapp/
docker-compose build
docker-compose up -d
docker-compose ps
docker-compose images

#config php fpm
docker-compose exec app php artisan key:generate
docker-compose exec app php artisan config:cache
docker-compose exec app php artisan migrate

#echo result
echo "Run http://localhost:80"

