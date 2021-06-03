#!/usr/bin/env bash
git clone  https://gitlab.com/movie-analyst/movie-analyst-vagrant.git
bash movie-analyst-vagrant/provisions/bash/setup-node.sh
bash movie-analyst-vagrant/provisions/bash/setup-pm2.sh
git clone https://gitlab.com/movie-analyst/movie-analyst-ui.git
cd movie-analyst-ui
npm install
BACK_HOST="${host_ip}" pm2 start server.js --name ui
pm2 save