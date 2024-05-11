#/bin/sh

projectName=$1

[[ -z $1 ]] && echo "Missing docker compose project name (actually only a prefix is required)" && exit 1

echo "Making a backup of project '$projectName'..."
echo

volumeNames=$(docker volume ls -q)

echo "About to backup all these volumes:"
echo "$volumeNames"
echo
echo "Warning: all containers will be turned off to proceed with a clean state !"

read -p "Press key to continue.. (Ctrl + C to abort)" -n1 -s

docker compose down

for volumeName in $volumeNames; do
    if [[ $volumeName == "$projectName"* ]]; then   # True if $a starts with a projectName.
	fileName=$(echo $volumeName | sed "s/^${projectName}//")
	#echo $fileName
    	./scripts/docker/backup-volume.sh "${volumeName}" "${fileName}" > full-backup.log 2>&1
	ls -alh "${fileName}.tar.gz" | awk '{print $5, $9}'
    fi
done

exit 0

