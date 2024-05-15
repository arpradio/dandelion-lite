#/bin/sh

volumeName=$1
fileName=$2
backupDir=$3

[[ -z $volumeName ]] && echo "Missing docker compose volume name (with project name prefix!)" && exit 1
[[ -z $fileName ]] && echo "Missing backup filename (without file extensions!)" && exit 1
[[ -z $backupDir ]] && echo "Missing backup directory path (with last slash)" && exit 1

sourceVolumeName="${volumeName}"
exportFileName="${fileName}.tar.gz"

echo "Exporting volume '$sourceVolumeName' into backup file '${backupDir}$exportFileName' ..."

docker run --rm \
	--mount source=${sourceVolumeName},target=/volume \
	-v ${backupDir}:/backup \
	alpine \
	bin/sh -c "apk update && apk add pigz && tar cvf - /volume | pigz > /backup/${exportFileName}"

#tar -czvf /backup/${exportFileName} /volume

ls -alh "${backupDir}${exportFileName}" | awk '{print $5, $9}'

echo "Done"

exit 0
