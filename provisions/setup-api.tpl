#!/usr/bin/env bash
git clone https://gitlab.com/movie-analyst/movie-analyst-vagrant.git
bash movie-analyst-vagrant/provisions/bash/setup-node.sh
bash movie-analyst-vagrant/provisions/bash/setup-pm2.sh
git clone -b main https://gitlab.com/movie-analyst/movie-analyst-api.git
cd movie-analyst-api
npm install
pm2 start server.js --name api
pm2 save
