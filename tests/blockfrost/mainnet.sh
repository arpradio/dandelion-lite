

  # Generated test cases for OpenAPI 'https://docs.blockfrost.io/blockfrost-openapi.yaml'  
  
  source "../../../.env"

  OFFICIAL_URL='https://cardano-mainnet.blockfrost.io/api/v0'
  PROJECT_ID=$BLOCKFROST_TEST_PROJECT_ID

  DEFAULT_GET_ARGS="-sk -X GET -H 'accept:application/json' -H 'Project_id: $PROJECT_ID'"
  DEFAULT_POST_ARGS="-sk -X POST -H 'accept:application/json' -H 'content-type: application/json' -H 'Project_id: $PROJECT_ID'"

  EXAMPLE_ORDER=desc    #example_order
  EXAMPLE_PAGE=1        #example_page
  EXAMPLE_COUNT=3       #example_count
  EXAMPLE_ADDRESS="addr1q8a7qshf0skll7kg7lycuqgpjexdmf3vnf9kzmkzjjz936ht39sj7vwe4f34hntdj8r0mvnw8fqlk6xh3yrqd85jy4tsezrkvg" #addr1qxqs59lphg8g6qndelq8xwqn60ag3aeyfcp33c2kdp46a09re5df3pzwwmyq946axfcejy5n4x0y99wqpgtp2gd0k09qsgy6pz
  EXAMPLE_STAKE_ADDRESS="stake1u84cjcf0x8v65c6me4ker3hakfhr5s0mdrtcjpsxn6fz24cve9ksk" #stake1u9ylzsgxaa6xctf4juup682ar3juj85n8tx3hthnljg47zctvm3rc
  EXAMPLE_DREP="drep15cfxz9exyn5rx0807zvxfrvslrjqfchrd4d47kv9e0f46uedqtc" #drep15cfxz9exyn5rx0807zvxfrvslrjqfchrd4d47kv9e0f46uedqtc
  EXAMPLE_TX_HASH="6e5f825c82c1c6d6b77f2a14092f3b78c8f1b66db6f4cf8caec1555b6f967b3b" #6e5f825c82c1c6d6b77f2a14092f3b78c8f1b66db6f4cf8caec1555b6f967b3b
  EXAMPLE_POOL_ID="pool1pu5jlj4q9w9jlxeu370a3c9myx47md5j5m2str0naunn2q3lkdy" #pool1pu5jlj4q9w9jlxeu370a3c9myx47md5j5m2str0naunn2q3lkdy
  EXAMPLE_ASSET="b0d07d45fe9514f80213f4020e5a61241458be626841cde717cb38a76e7574636f696e" #b0d07d45fe9514f80213f4020e5a61241458be626841cde717cb38a76e7574636f696e
  EXAMPLE_POLICY_ID="476039a0949cf0b22f6a800f56780184c44533887ca6e821007840c3" #476039a0949cf0b22f6a800f56780184c44533887ca6e821007840c3
  EXAMPLE_SCRIPT_HASH="e1457a0c47dfb7a2f6b8fbb059bdceab163c05d34f195b87b9f2b30e" #e1457a0c47dfb7a2f6b8fbb059bdceab163c05d34f195b87b9f2b30e
  EXAMPLE_DATUM_HASH="db583ad85881a96c73fbb26ab9e24d1120bb38f45385664bb9c797a2ea8d9a2d" #db583ad85881a96c73fbb26ab9e24d1120bb38f45385664bb9c797a2ea8d9a2d
  EXAMPLE_BLOCK_HASH="4ea1ba291e8eef538635a53e59fddba7810d1679631cc3aed7c8e6c4091a516a" #4ea1ba291e8eef538635a53e59fddba7810d1679631cc3aed7c8e6c4091a516a
  EXAMPLE_PROPOSAL_ID="2dd15e0ef6e6a17841cb9541c27724072ce4d4b79b91e58432fbaa32d9572531"
  EXAMPLE_METADATA_LABEL="1990"
  EXAMPLE_EPOCH_NO="219"
  EXAMPLE_SLOT_NO="30895909"
  EXAMPLE_BLOCK_NO="4873401"

  TEST_CASES=(
  # -------------------------
  # Health
  # -------------------------
"Root endpoint [ generated ] | curl \"%%API_URL%%/\" %%DEFAULT_GET_ARGS%%"
"Backend health status [ generated ] | curl \"%%API_URL%%/health\" %%DEFAULT_GET_ARGS%%"
"Current backend time [ generated ] | curl \"%%API_URL%%/health/clock\" %%DEFAULT_GET_ARGS%%"

  # -------------------------
  # Cardano » Blocks
  # -------------------------
"Latest block [ generated ] | curl \"%%API_URL%%/blocks/latest\" %%DEFAULT_GET_ARGS%%"
"Latest block transactions [ generated ] | curl \"%%API_URL%%/blocks/latest/txs?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Specific block [ generated ] | curl \"%%API_URL%%/blocks/$EXAMPLE_BLOCK_HASH\" %%DEFAULT_GET_ARGS%%"
"Listing of next blocks [ generated ] | curl \"%%API_URL%%/blocks/$EXAMPLE_BLOCK_HASH/next?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE\" %%DEFAULT_GET_ARGS%%"
"Listing of previous blocks [ generated ] | curl \"%%API_URL%%/blocks/$EXAMPLE_BLOCK_NO/previous?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE\" %%DEFAULT_GET_ARGS%%"
"Specific block in a slot [ generated ] | curl \"%%API_URL%%/blocks/slot/$EXAMPLE_SLOT_NO\" %%DEFAULT_GET_ARGS%%"
"Specific block in a slot in an epoch [ generated ] | curl \"%%API_URL%%/blocks/epoch/${EXAMPLE_EPOCH_NO}/slot/$EXAMPLE_SLOT_NO\" %%DEFAULT_GET_ARGS%%"
"Block transactions [ generated ] | curl \"%%API_URL%%/blocks/$EXAMPLE_BLOCK_NO/txs?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Addresses affected in a specific block [ generated ] | curl \"%%API_URL%%/blocks/$EXAMPLE_BLOCK_NO/addresses?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE\" %%DEFAULT_GET_ARGS%%"

  # -------------------------
  # Cardano » Ledger
  # -------------------------
"Blockchain genesis [ generated ] | curl \"%%API_URL%%/genesis\" %%DEFAULT_GET_ARGS%%"

  # -------------------------
  # Cardano » Governance
  # -------------------------
"Delegate Representatives [ DReps ] [ generated ] | curl \"%%API_URL%%/governance/dreps?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Specific DRep [ generated ] | curl \"%%API_URL%%/governance/dreps/$EXAMPLE_DREP\" %%DEFAULT_GET_ARGS%%"
"DRep delegators [ generated ] | curl \"%%API_URL%%/governance/dreps/$EXAMPLE_DREP/delegators?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"DRep metadata [ generated ] | curl \"%%API_URL%%/governance/dreps/$EXAMPLE_DREP/metadata\" %%DEFAULT_GET_ARGS%%"
"DRep updates [ generated ] | curl \"%%API_URL%%/governance/dreps/$EXAMPLE_DREP/updates?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"DRep votes [ generated ] | curl \"%%API_URL%%/governance/dreps/$EXAMPLE_DREP/votes?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Proposals [ generated ] | curl \"%%API_URL%%/governance/proposals?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Specific proposal [ generated ] | curl \"%%API_URL%%/governance/proposals/$EXAMPLE_PROPOSAL_ID/1\" %%DEFAULT_GET_ARGS%%"
"Specific parameters proposal [ generated ] | curl \"%%API_URL%%/governance/proposals/$EXAMPLE_PROPOSAL_ID/1/parameters\" %%DEFAULT_GET_ARGS%%"
"Specific withdrawals proposal [ generated ] | curl \"%%API_URL%%/governance/proposals/$EXAMPLE_PROPOSAL_ID/1/withdrawals\" %%DEFAULT_GET_ARGS%%"
"Proposal votes [ generated ] | curl \"%%API_URL%%/governance/proposals/$EXAMPLE_PROPOSAL_ID/1/votes?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Specific proposal metadata [ generated ] | curl \"%%API_URL%%/governance/proposals/$EXAMPLE_PROPOSAL_ID/0/metadata\" %%DEFAULT_GET_ARGS%%"

  # -------------------------
  # Cardano » Epochs
  # -------------------------
"Latest epoch [ generated ] | curl \"%%API_URL%%/epochs/latest\" %%DEFAULT_GET_ARGS%%"
"Latest epoch protocol parameters [ generated ] | curl \"%%API_URL%%/epochs/latest/parameters\" %%DEFAULT_GET_ARGS%%"
"Specific epoch [ generated ] | curl \"%%API_URL%%/epochs/$EXAMPLE_EPOCH_NO\" %%DEFAULT_GET_ARGS%%"
"Listing of next epochs [ generated ] | curl \"%%API_URL%%/epochs/$EXAMPLE_EPOCH_NO/next?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE\" %%DEFAULT_GET_ARGS%%"
"Listing of previous epochs [ generated ] | curl \"%%API_URL%%/epochs/$EXAMPLE_EPOCH_NO/previous?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE\" %%DEFAULT_GET_ARGS%%"
"Stake distribution [ generated ] | curl \"%%API_URL%%/epochs/$EXAMPLE_EPOCH_NO/stakes?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE\" %%DEFAULT_GET_ARGS%%"
"Stake distribution by pool [ generated ] | curl \"%%API_URL%%/epochs/$EXAMPLE_EPOCH_NO/stakes/$EXAMPLE_POOL_ID?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE\" %%DEFAULT_GET_ARGS%%"
"Block distribution [ generated ] | curl \"%%API_URL%%/epochs/$EXAMPLE_EPOCH_NO/blocks?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Block distribution by pool [ generated ] | curl \"%%API_URL%%/epochs/$EXAMPLE_EPOCH_NO/blocks/$EXAMPLE_POOL_ID?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Protocol parameters [ generated ] | curl \"%%API_URL%%/epochs/$EXAMPLE_EPOCH_NO/parameters\" %%DEFAULT_GET_ARGS%%"

  # -------------------------
  # Cardano » Transactions
  # -------------------------
"Specific transaction [ generated ] | curl \"%%API_URL%%/txs/$EXAMPLE_TX_HASH\" %%DEFAULT_GET_ARGS%%"
"Transaction UTXOs [ generated ] | curl \"%%API_URL%%/txs/$EXAMPLE_TX_HASH/utxos\" %%DEFAULT_GET_ARGS%%"
"Transaction stake addresses certificates [ generated ] | curl \"%%API_URL%%/txs/$EXAMPLE_TX_HASH/stakes\" %%DEFAULT_GET_ARGS%%"
"Transaction delegation certificates [ generated ] | curl \"%%API_URL%%/txs/$EXAMPLE_TX_HASH/delegations\" %%DEFAULT_GET_ARGS%%"
"Transaction withdrawal [ generated ] | curl \"%%API_URL%%/txs/$EXAMPLE_TX_HASH/withdrawals\" %%DEFAULT_GET_ARGS%%"
"Transaction MIRs [ generated ] | curl \"%%API_URL%%/txs/$EXAMPLE_TX_HASH/mirs\" %%DEFAULT_GET_ARGS%%"
"Transaction stake pool registration and update certificates [ generated ] | curl \"%%API_URL%%/txs/$EXAMPLE_TX_HASH/pool_updates\" %%DEFAULT_GET_ARGS%%"
"Transaction stake pool retirement certificates [ generated ] | curl \"%%API_URL%%/txs/$EXAMPLE_TX_HASH/pool_retires\" %%DEFAULT_GET_ARGS%%"
"Transaction metadata [ generated ] | curl \"%%API_URL%%/txs/$EXAMPLE_TX_HASH/metadata\" %%DEFAULT_GET_ARGS%%"
"Transaction metadata in CBOR [ generated ] | curl \"%%API_URL%%/txs/$EXAMPLE_TX_HASH/metadata/cbor\" %%DEFAULT_GET_ARGS%%"
"Transaction redeemers [ generated ] | curl \"%%API_URL%%/txs/$EXAMPLE_TX_HASH/redeemers\" %%DEFAULT_GET_ARGS%%"
"Transaction required signers [ generated ] | curl \"%%API_URL%%/txs/$EXAMPLE_TX_HASH/required_signers\" %%DEFAULT_GET_ARGS%%"
"Transaction CBOR [ generated ] | curl \"%%API_URL%%/txs/$EXAMPLE_TX_HASH/cbor\" %%DEFAULT_GET_ARGS%%"
"Submit a transaction [  from docs  ] | curl \"# Assuming `data` is a serialized transaction on the file-system. curl "%%API_URL%%/tx/submit"            --data-binary @./data \" %%DEFAULT_POST_ARGS%%"
"Submit a transaction [  from docs  ] | curl \"# Assuming `tx.signed` is signed transaction constructed by cardano-cli xxd -r -p <<< $(jq .cborHex tx.signed) > tx.submit-api.raw curl "%%API_URL%%/tx/submit"            --data-binary @./tx.submit-api.raw \" %%DEFAULT_POST_ARGS%%"
"Submit a transaction [ generated ] | curl \"%%API_URL%%/tx/submit\" %%DEFAULT_POST_ARGS%%"

  # -------------------------
  # Cardano » Accounts
  # -------------------------
"Specific account address [ generated ] | curl \"%%API_URL%%/accounts/$EXAMPLE_STAKE_ADDRESS\" %%DEFAULT_GET_ARGS%%"
"Account reward history [ generated ] | curl \"%%API_URL%%/accounts/$EXAMPLE_STAKE_ADDRESS/rewards?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Account history [ generated ] | curl \"%%API_URL%%/accounts/$EXAMPLE_STAKE_ADDRESS/history?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Account delegation history [ generated ] | curl \"%%API_URL%%/accounts/$EXAMPLE_STAKE_ADDRESS/delegations?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Account registration history [ generated ] | curl \"%%API_URL%%/accounts/$EXAMPLE_STAKE_ADDRESS/registrations?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Account withdrawal history [ generated ] | curl \"%%API_URL%%/accounts/$EXAMPLE_STAKE_ADDRESS/withdrawals?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Account MIR history [ generated ] | curl \"%%API_URL%%/accounts/$EXAMPLE_STAKE_ADDRESS/mirs?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Account associated addresses [ generated ] | curl \"%%API_URL%%/accounts/$EXAMPLE_STAKE_ADDRESS/addresses?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Assets associated with the account addresses [ generated ] | curl \"%%API_URL%%/accounts/$EXAMPLE_STAKE_ADDRESS/addresses/assets?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Detailed information about account associated addresses [ generated ] | curl \"%%API_URL%%/accounts/$EXAMPLE_ADDRESS/addresses/total\" %%DEFAULT_GET_ARGS%%"
"Account UTXOs [ generated ] | curl \"%%API_URL%%/accounts/$EXAMPLE_STAKE_ADDRESS/utxos?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"

  # -------------------------
  # Cardano » Mempool
  # -------------------------
"Mempool [ generated ] | curl \"%%API_URL%%/mempool?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Specific transaction in the mempool [ generated ] | curl \"%%API_URL%%/mempool/6e5f825c42c1c6d6b77f2a14092f3b78c8f1b66db6f4cf8caec1555b6f967b3b\" %%DEFAULT_GET_ARGS%%"
"Mempool by address [ generated ] | curl \"%%API_URL%%/mempool/addresses/$EXAMPLE_ADDRESS?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"

  # -------------------------
  # Cardano » Metadata
  # -------------------------
"Transaction metadata labels [ generated ] | curl \"%%API_URL%%/metadata/txs/labels?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Transaction metadata content in JSON [ generated ] | curl \"%%API_URL%%/metadata/txs/labels/$EXAMPLE_METADATA_LABEL?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Transaction metadata content in CBOR [ generated ] | curl \"%%API_URL%%/metadata/txs/labels/$EXAMPLE_METADATA_LABEL/cbor?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"

  # -------------------------
  # Cardano » Addresses
  # -------------------------
"Specific address [ generated ] | curl \"%%API_URL%%/addresses/$EXAMPLE_ADDRESS\" %%DEFAULT_GET_ARGS%%"
"Extended information of a specific address [ generated ] | curl \"%%API_URL%%/addresses/$EXAMPLE_ADDRESS/extended\" %%DEFAULT_GET_ARGS%%"
"Address details [ generated ] | curl \"%%API_URL%%/addresses/$EXAMPLE_ADDRESS/total\" %%DEFAULT_GET_ARGS%%"
"Address UTXOs [ generated ] | curl \"%%API_URL%%/addresses/$EXAMPLE_ADDRESS/utxos?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Address UTXOs of a given asset [ generated ] | curl \"%%API_URL%%/addresses/$EXAMPLE_ADDRESS/utxos/$EXAMPLE_ASSET?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Address txs [ generated ] | curl \"%%API_URL%%/addresses/$EXAMPLE_ADDRESS/txs?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Address transactions [ generated ] | curl \"%%API_URL%%/addresses/$EXAMPLE_ADDRESS/transactions?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER&from=8929261&to=9999269:10\" %%DEFAULT_GET_ARGS%%"

  # -------------------------
  # Cardano » Pools
  # -------------------------
"List of stake pools [ generated ] | curl \"%%API_URL%%/pools?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"List of stake pools with additional information [ generated ] | curl \"%%API_URL%%/pools/extended?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"List of retired stake pools [ generated ] | curl \"%%API_URL%%/pools/retired?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"List of retiring stake pools [ generated ] | curl \"%%API_URL%%/pools/retiring?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Specific stake pool [ generated ] | curl \"%%API_URL%%/pools/$EXAMPLE_POOL_ID\" %%DEFAULT_GET_ARGS%%"
"Stake pool history [ generated ] | curl \"%%API_URL%%/pools/$EXAMPLE_POOL_ID/history?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Stake pool metadata [ generated ] | curl \"%%API_URL%%/pools/$EXAMPLE_POOL_ID/metadata\" %%DEFAULT_GET_ARGS%%"
"Stake pool relays [ generated ] | curl \"%%API_URL%%/pools/$EXAMPLE_POOL_ID/relays\" %%DEFAULT_GET_ARGS%%"
"Stake pool delegators [ generated ] | curl \"%%API_URL%%/pools/$EXAMPLE_POOL_ID/delegators?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Stake pool blocks [ generated ] | curl \"%%API_URL%%/pools/$EXAMPLE_POOL_ID/blocks?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Stake pool updates [ generated ] | curl \"%%API_URL%%/pools/$EXAMPLE_POOL_ID/updates?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Stake pool votes [ generated ] | curl \"%%API_URL%%/pools/$EXAMPLE_POOL_ID/votes?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"

  # -------------------------
  # Cardano » Assets
  # -------------------------
"Assets [ generated ] | curl \"%%API_URL%%/assets?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Specific asset [ generated ] | curl \"%%API_URL%%/assets/$EXAMPLE_ASSET\" %%DEFAULT_GET_ARGS%%"
"Asset history [ generated ] | curl \"%%API_URL%%/assets/$EXAMPLE_ASSET/history?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Asset txs [ generated ] | curl \"%%API_URL%%/assets/$EXAMPLE_ASSET/txs?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Asset transactions [ generated ] | curl \"%%API_URL%%/assets/$EXAMPLE_ASSET/transactions?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Asset addresses [ generated ] | curl \"%%API_URL%%/assets/$EXAMPLE_ASSET/addresses?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Assets of a specific policy [ generated ] | curl \"%%API_URL%%/assets/policy/$EXAMPLE_POLICY_ID?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"

  # -------------------------
  # Cardano » Scripts
  # -------------------------
"Scripts [ generated ] | curl \"%%API_URL%%/scripts?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Specific script [ generated ] | curl \"%%API_URL%%/scripts/$EXAMPLE_SCRIPT_HASH\" %%DEFAULT_GET_ARGS%%"
"Script JSON [ generated ] | curl \"%%API_URL%%/scripts/$EXAMPLE_SCRIPT_HASH/json\" %%DEFAULT_GET_ARGS%%"
"Script CBOR [ generated ] | curl \"%%API_URL%%/scripts/$EXAMPLE_SCRIPT_HASH/cbor\" %%DEFAULT_GET_ARGS%%"
"Redeemers of a specific script [ generated ] | curl \"%%API_URL%%/scripts/$EXAMPLE_SCRIPT_HASH/redeemers?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
"Datum value [ generated ] | curl \"%%API_URL%%/scripts/datum/$EXAMPLE_DATUM_HASH\" %%DEFAULT_GET_ARGS%%"
"Datum CBOR value [ generated ] | curl \"%%API_URL%%/scripts/datum/$EXAMPLE_DATUM_HASH/cbor\" %%DEFAULT_GET_ARGS%%"

#   # -------------------------
#   # Cardano » Utilities
#   # -------------------------
# "Derive an address [ generated ] | curl \"%%API_URL%%/utils/addresses/xpub/d507c8f866691bd96e131334c355188b1a1d0b2fa0ab11545075aab332d77d9eb19657ad13ee581b56b0f8d744d66ca356b93d42fe176b3de007d53e9c4c4e7a/0/2\" %%DEFAULT_GET_ARGS%%"
# "Submit a transaction for execution units evaluation [  from docs  ] | curl \"%%API_URL%%/utils/txs/evaluate\"           --data @./tx.data  %%DEFAULT_POST_ARGS%%"
# "Submit a transaction for execution units evaluation [ generated ] | curl \"%%API_URL%%/utils/txs/evaluate?version=example_version\" %%DEFAULT_POST_ARGS%%"
# "Submit a transaction for execution units evaluation [ additional UTXO set ] [  from docs  ] | curl \"%%API_URL%%/utils/txs/evaluate/utxos\" -d '{"cbor":"<TxCbor>","additionalUtxoSet":[[<TxIn>, <TxOut>]]}' %%DEFAULT_POST_ARGS%%"
# "Submit a transaction for execution units evaluation [ additional UTXO set ] [ generated ] | curl \"%%API_URL%%/utils/txs/evaluate/utxos?version=example_version\" %%DEFAULT_POST_ARGS%%"

#   # -------------------------
#   # 
#   # -------------------------
# "/ipfs/add [ generated ] | curl \"%%API_URL%%/ipfs/add\" %%DEFAULT_SERVERS_HEADERS%%"
# "/ipfs/gateway/{IPFS_path} [ generated ] | curl \"%%API_URL%%/ipfs/gateway/{IPFS_path}\" %%DEFAULT_SERVERS_HEADERS%%"
# "/ipfs/pin/add/{IPFS_path} [ generated ] | curl \"%%API_URL%%/ipfs/pin/add/{IPFS_path}\" %%DEFAULT_SERVERS_HEADERS%%"
# "/ipfs/pin/list [ generated ] | curl \"%%API_URL%%/ipfs/pin/list\" %%DEFAULT_SERVERS_HEADERS%%"
# "/ipfs/pin/list/{IPFS_path} [ generated ] | curl \"%%API_URL%%/ipfs/pin/list/{IPFS_path}\" %%DEFAULT_SERVERS_HEADERS%%"
# "/ipfs/pin/remove/{IPFS_path} [ generated ] | curl \"%%API_URL%%/ipfs/pin/remove/{IPFS_path}\" %%DEFAULT_SERVERS_HEADERS%%"

#   # -------------------------
#   # IPFS » Add
#   # -------------------------
# "Add a file to IPFS [  from docs  ] | curl \"curl "https://ipfs.blockfrost.io/api/v0/ipfs/add"         -F "file=@./README.md" \" %%DEFAULT_POST_ARGS%%"
# "Add a file to IPFS [ generated ] | curl \"%%API_URL%%/ipfs/add\" %%DEFAULT_POST_ARGS%%"

#   # -------------------------
#   # IPFS » Gateway
#   # -------------------------
# "Relay to an IPFS gateway [  from docs  ] | curl \"curl "https://ipfs.blockfrost.io/api/v0/ipfs/gateway/{IPFS_path}"    \" %%DEFAULT_GET_ARGS%%"
# "Relay to an IPFS gateway [ generated ] | curl \"%%API_URL%%/ipfs/gateway/example_IPFS_path\" %%DEFAULT_GET_ARGS%%"

#   # -------------------------
#   # IPFS » Pins
#   # -------------------------
# "Pin an object [  from docs  ] | curl \"curl "https://ipfs.blockfrost.io/api/v0/ipfs/pin/add/{IPFS_path}"    \" %%DEFAULT_POST_ARGS%%"
# "Pin an object [ generated ] | curl \"%%API_URL%%/ipfs/pin/add/example_IPFS_path?filecoin=example_filecoin\" %%DEFAULT_POST_ARGS%%"
# "List pinned objects [  from docs  ] | curl \"curl "https://ipfs.blockfrost.io/api/v0/ipfs/pin/list/"    \" %%DEFAULT_GET_ARGS%%"
# "List pinned objects [ generated ] | curl \"%%API_URL%%/ipfs/pin/list?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
# "Get details about pinned object [  from docs  ] | curl \"curl "https://ipfs.blockfrost.io/api/v0/ipfs/pin/list/{IPFS_PATH}"    \" %%DEFAULT_GET_ARGS%%"
# "Get details about pinned object [ generated ] | curl \"%%API_URL%%/ipfs/pin/list/example_IPFS_path\" %%DEFAULT_GET_ARGS%%"
# "Remove a IPFS pin [  from docs  ] | curl \"curl "https://ipfs.blockfrost.io/api/v0/ipfs/pin/remove/{IPFS_PATH}"       \" %%DEFAULT_POST_ARGS%%"
# "Remove a IPFS pin [ generated ] | curl \"%%API_URL%%/ipfs/pin/remove/example_IPFS_path\" %%DEFAULT_POST_ARGS%%"

  # -------------------------
  # Metrics
  # -------------------------
"Blockfrost usage metrics [ generated ] | curl \"%%API_URL%%/metrics\" %%DEFAULT_GET_ARGS%%"
"Blockfrost endpoint usage metrics [ generated ] | curl \"%%API_URL%%/metrics/endpoints\" %%DEFAULT_GET_ARGS%%"

  # -------------------------
  # Cardano » Network
  # -------------------------
"Network information [ generated ] | curl \"%%API_URL%%/network\" %%DEFAULT_GET_ARGS%%"
"Query summary of blockchain eras [ generated ] | curl \"%%API_URL%%/network/eras\" %%DEFAULT_GET_ARGS%%"

#   # -------------------------
#   # Nut.link
#   # -------------------------
# "Specific nut.link address [ generated ] | curl \"%%API_URL%%/nutlink/example_address\" %%DEFAULT_GET_ARGS%%"
# "List of tickers of an oracle [ generated ] | curl \"%%API_URL%%/nutlink/example_address/tickers?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
# "Specific ticker for an address [ generated ] | curl \"%%API_URL%%/nutlink/example_address/tickers/example_ticker?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"
# "Specific ticker [ generated ] | curl \"%%API_URL%%/nutlink/tickers/example_ticker?count=$EXAMPLE_COUNT&page=$EXAMPLE_PAGE&order=$EXAMPLE_ORDER\" %%DEFAULT_GET_ARGS%%"

)

