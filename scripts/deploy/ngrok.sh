#/bin/bash

source .env

echo "IMPORTANT: you need to manually install and setup NGROK from https://ngrok.com/download"
echo
echo "Initiallizing tunneling ... "
echo

ngrok http $(expr $HAPROXY_PORT + 0) | cat &
sleep 5

tunnelHost=$(curl http://127.0.0.1:4040/api/tunnels --silent | jq '.tunnels | .[] | .public_url' | sed -e 's/^"//' -e 's/"$//')

[[ -z ${tunnelHost} ]] && echo "command took more time than expected or simply failed. Aborting..." && exit 1

echo "Tunnel URL:		$tunnelHost"
echo
echo "Now you can visit it on browser to monitor node status, or use these APIs:"
echo "   ogmios: 		http://${tunnelHost}/ogmios/"
echo "   cardano-graphql:     http://${tunnelHost}/cardano-graphql/"
echo "   koios-lite:          http://${tunnelHost}/koios/"
echo "   token-registry:      http://${tunnelHost}/token-registry/"
echo "   postgrest:           http://${tunnelHost}/postgrest/"
echo

read -p "Press any key to shutdown ngrok tunneling"

killall -9 ngrok

echo "Tunnel closed."

