#!/bin/bash
BACKUP_PATH=/data/services/postgres/backup/sql/

docker exec -u postgres postgres pg_dumpall -c -U admin | gzip >${BACKUP_PATH}$(date +%Y-%m-%d"_"%H_%M_%S).sql.gz

find ${BACKUP_PATH} -mtime +3 -name "*.sql.gz" -exec rm -f {} \;
