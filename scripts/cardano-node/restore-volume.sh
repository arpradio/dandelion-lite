#/bin/sh

echo "to be implemented!"

exit 1

source .env

targetVolumeName="${PROJ_NAME}_db-sync-data"
backupFileName="${sourceVolumeName}.tar.gz"

echo "Restoring $sourceVolumeName from $(pwd) ..."

#docker run --rm \
#	--mount source=${sourceVolumeName},target=/data/db \
#	-v $(pwd):/backup \
#	busybox \
#	tar -cvf /backup/${exportFileName} /data/db

docker run --rm \ 
  --volume [DOCKER_COMPOSE_PREFIX]_[VOLUME_NAME]:/[TEMPORARY_DIRECTORY_STORING_EXTRACTED_BACKUP] \
  --volume $(pwd):/[TEMPORARY_DIRECTORY_TO_STORE_BACKUP_FILE] \
  ubuntu \
  tar xvf /[TEMPORARY_DIRECTORY_TO_STORE_BACKUP_FILE]/[BACKUP_FILENAME].tar -C /[TEMPORARY_DIRECTORY_STORING_EXTRACTED_BACKUP] --strip 1
