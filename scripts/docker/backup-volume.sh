#/bin/sh

volumeName=$1
fileName=$2

[[ -z $1 ]] && echo "Missing docker compose volume name (with project name prefix!)" && exit 1
[[ -z $2 ]] && echo "Missing backup filename (without file extensions!)" && exit 1

sourceVolumeName="${volumeName}"
exportFileName="${fileName}.tar.gz"

echo "Exporting volume '$sourceVolumeName' into backup file '$(pwd)/$exportFileName' ..."

docker run --rm \
	--mount source=${sourceVolumeName},target=/volume \
	-v $(pwd):/backup \
	alpine \
	tar -czvf /backup/${exportFileName} /volume

ls -alh "$(pwd)/${exportFileName}" | awk '{print $5, $9}'

echo "Done"

exit 0
