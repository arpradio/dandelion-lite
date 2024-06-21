
echo "NETWORK=$NETWORK"

if [[ "$NETWORK" == "mainnet" ]]
then
    STATUS=`cardano-cli query tip --mainnet --socket-path /ipc/node.socket | jq '.syncProgress' | tr -d '"'`
  
else
    STATUS=`cardano-cli query tip --testnet-magic 1 --socket-path /ipc/node.socket | jq '.syncProgress' | tr -d '"'`
fi

re='^[0-9]+([.][0-9]+)?$'
if ! [[ $STATUS =~ $re ]] ; then
   echo "Socket not yet available" >&2; 
   exit 1
fi

echo $STATUS
STATUS_INTEGER=${STATUS%.*}

if [ "$STATUS_INTEGER" -ge "4" ] ; then
    echo "OK - Node sync progress: $STATUS_INTEGER %";
    exit 0;
else 
    echo "Initializing - Sync progress: $STATUS_INTEGER % < 4%";
    exit 1;
fi

