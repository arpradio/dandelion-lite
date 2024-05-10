#/bin/sh

source .env

sourceVolumeName="${PROJ_NAME}_node-db"
exportFileName="${sourceVolumeName}.tar.gz"

echo "Exporting $sourceVolumeName into $(pwd) ..."

#touch "$(pwd)/${exportFileName}"

docker run --rm \
	--mount source=${sourceVolumeName},target=/data/db \
	-v $(pwd):/backup \
	busybox \
	tar -cvf /backup/${exportFileName} /data/db
