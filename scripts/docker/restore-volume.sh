#/bin/sh

volumeName=$1
fileName=$2

[[ -z $1 ]] && echo "Missing docker compose volume name (with project name prefix!)" && exit 1
[[ -z $2 ]] && echo "Missing backup filename (without file extensions!)" && exit 1

targetVolumeName="${volumeName}"
backupFileName="${fileName}.tar.gz"

echo "Restoring volume '$targetVolumeName' from backup file '$(pwd)/$backupFileName' ..."

ls -alh "$(pwd)/${backupFileName}" | awk '{print $5, $9}'

docker run --rm \
  -v $(pwd):/backup \
  -v "$targetVolumeName":/volume \
  alpine \
  bin/sh -c "rm -rfv /volume/* && tar xzvf /backup/${backupFileName} -C /volume --strip 1"


#bin/sh -c "ls /volume && rm -rfv /volume/* && tar xzvf /backup/${backupFileName} -C /volume --strip 1 && ls /volume"
