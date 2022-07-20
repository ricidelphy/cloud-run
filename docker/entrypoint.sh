#!/usr/bin/env bash

set -e

cd /var/www/app

touch storage/logs/laravel.log
touch storage/logs/schedule.log
touch storage/logs/worker.log

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
