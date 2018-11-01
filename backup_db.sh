#!/bin/bash
sudo docker-compose exec database bash -c 'pg_dump -U heat -F t db/development | gzip >/Heat/db-backup-$(date +%Y-%m-%d).tar.gz'
