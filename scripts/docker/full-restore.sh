#/bin/sh

projectName=$1

[[ -z $1 ]] && echo "Missing docker compose project name (actually only a prefix is required)" && exit 1

echo "Restoring project '$projectName'..."
echo

volumeNames=$(docker volume ls -q)

echo "About to try restoring all these volumes with these backup files (<gc_node_root_dir>/<volume_name_without_project_name.tar.gz>):"

for volumeName in $volumeNames; do
    if [[ $volumeName == "$projectName"* ]]; then   # True if $volumeName starts with $projectName.
        fileName=$(echo $volumeName | sed "s/^${projectName}//")
	echo "${volumeName}: ${fileName}.tar.gz"
	ls -alh "${fileName}.tar.gz" | awk '{print $5, $9}'
    fi
done
echo

echo "Warning: all containers will be turned off AND ALL VOLUME DATA WILL BE REPLACED !"

read -p "Press key to continue.. (Ctrl + C to abort)" -n1 -s
echo
read -p "Last chance: Press key to CONFIRM.. (Ctrl + C to abort)" -n1 -s
echo
docker compose down

for volumeName in $volumeNames; do
    if [[ $volumeName == "$projectName"* ]]; then   # True if $volumeName starts with $projectName.
	fileName=$(echo $volumeName | sed "s/^${projectName}//")
	echo $fileName
    	./scripts/docker/restore-volume.sh "${volumeName}" "${fileName}" > full-restore.log 2>&1
	ls -alh "${fileName}.tar.gz" | awk '{print $5, $9}'
    fi
done

exit 0

