#/bin/sh

projectName=$1
projectFile=$2
envFile=$3
composePath=$4

exampleUsage="Example usage: ./scripts/docker/systemdAdd.sh myProject \$PWD/docker-compose.yml \$PWD/.env \$PODMAN_COMPOSE_PROVIDER"

if [ -z "$projectName" ]; then
  echo "Missing docker/podman compose yaml project name"
  echo $exampleUsage
  exit 1
fi

if [ -z "$projectFile" ]; then
  echo "Missing docker/podman compose yaml project file (docker-compose.yml)"
  echo $exampleUsage
  exit 1
fi

if [ -z "$composePath" ]; then
  echo "Missing docker/podman executable path (example: /usr/local/bin/docker-compose) "
  echo $exampleUsage
  exit 1
fi

if [ -z "$envFile" ]; then
  echo "Missing .env file path"
  echo $exampleUsage
  exit 1
fi

projectFile=$(realpath $projectFile)
envFile=$(realpath $envFile)
composePath=$(realpath $composePath)

if [ -f "${projectFile}" ]; then
  echo "Installing project as service on SystemD '$projectFile'..."
else
  echo "Error: project file '${projectFile}' does not exist"
  echo $exampleUsage
  exit 1
fi

if [ -f "${composePath}" ]; then
  echo "Using '${composePath}'..."
else
  echo "Error: compose executable path '${composePath}' does not exist"
  echo $exampleUsage
  exit 1
fi


if [ -f "${envFile}" ]; then
  echo "Applying '$envFile' variables..."
else
  echo "Error: .env file '${envFile}' does not exist"
  echo $exampleUsage
  exit 1
fi


echo
echo "About to install, are you sure you want to continue?"

read -p "Press key to continue.. (Ctrl + C to abort)" -n1 -s
echo


echo "Installing '${projectName}'..."


#serviceName=$(basename ${projectFile} .yml)
serviceName=${projectName}
#serviceFile=/etc/systemd/system/${serviceName}.service
serviceFile=/home/${USER}/.config/systemd/user/${serviceName}.service
#serviceFile=${serviceName}.service

podmanSocket=$(podman info --format '{{.Host.RemoteSocket.Path}}')
podmanSocketMount=$(dirname "$podmanSocket")

preExecCommands=$(cat <<EOF
export DOCKER_HOST=unix://$(podman info --format '{{.Host.RemoteSocket.Path}}') && \
alias docker=podman && \
export PODMAN_COMPOSE_PROVIDER=${composePath}
EOF
)

composePath="docker compose"

echo "Creating systemd service file '${serviceFile}'..."
echo
cat <<EOF | tee ${serviceFile}
[Unit]
Description=Docker Compose Application Service
Wants=network-online.target
After=network-online.target
Requires=podman.service
#RequiresMountsFor=%t/containers
RequiresMountsFor=${podmanSocketMount}
#Requires=docker.service
#After=docker.service

[Service]
#User=$(id -un)
#Group=$(id -gn)
#Type=oneshot
Type=simple
RemainAfterExit=yes
WorkingDirectory=$(dirname ${projectFile})
EnvironmentFile=${envFile}
Environment=PODMAN_USERNS=keep-id
ExecStart=/bin/bash -c '${preExecCommands} && ${composePath} -f "${projectFile}" --env-file "${envFile}" --user $(id -u) up -d'
ExecStop=/bin/bash -c '${preExecCommands} && ${composePath} -f "${projectFile}" --env-file "${envFile}" --user $(id -u) down'

#Environment=DOCKER_HOST="unix://$(podman info --format '{{.Host.RemoteSocket.Path}}')"
#Environment=PODMAN_COMPOSE_PROVIDER=${composePath}
#Environment=XDG_RUNTIME_DIR=/run/user/$(id -u)
#ExecStart=podman compose -f "${projectFile}" --env-file "${envFile}" --user $(id -u) up -d
#ExecStop=podman compose -f "${projectFile}" --env-file "${envFile}" --user $(id -u) down
Restart=always
TimeoutStartSec=0
TimeoutStopSec=0

[Install]
#WantedBy=multi-user.target
WantedBy=default.target
EOF

echo

#exit 0

echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Enabling services for ${USER} on boot"
loginctl enable-linger $USER

echo "Enabling and starting the service..."
systemctl --user enable ${serviceName}.service
systemctl --user start ${serviceName}.service

echo "Service '${serviceName}' has been installed and started."

#journalctl -u ${serviceName}


