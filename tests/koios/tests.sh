#!/usr/bin/env bash
set -uo pipefail
source "../../.env"

OFFICIAL_KOIOS_URL="https://preprod.koios.rest/"
TESTING_KOIOS_URL="https://127.0.0.1:${HAPROXY_PORT}/koios/"
COOLDOWN_SECS=1
DEFAULT_HEADERS="-H accept:application/json"

TEST_CASES=(
  #"Network Tip|curl -skX GET %%API_URL%%api/v1/tip %%DEFAULT_HEADERS%%"
  # "Genesis|curl -skX GET %%API_URL%%api/v1/genesis %%DEFAULT_HEADERS%%"
  # "Tokenomics|curl -skX GET %%API_URL%%api/v1/totals?_epoch_no=166 %%DEFAULT_HEADERS%%"
  #"Address Info|curl -skX POST %%API_URL%%api/v1/address_info %%DEFAULT_HEADERS%% -H content-type:application/json -d '{\"_addresses\":[\"addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw\",\"addr_test1vpfwv0ezc5g8a4mkku8hhy3y3vp92t7s3ul8g778g5yegsgalc6gc\"]}'"

  # -------------------------
  # Network
  # -------------------------
  "Query Chain Tip|curl -skX GET \"%%API_URL%%api/v1/tip\" %%DEFAULT_HEADERS%%"
  "Get Genesis info|curl -skX GET \"%%API_URL%%api/v1/genesis\" %%DEFAULT_HEADERS%%"
  "Get historical tokenomic stats|curl -skX GET \"%%API_URL%%api/v1/totals?_epoch_no=166\" %%DEFAULT_HEADERS%%"
  "Param Update Proposals|curl -skX GET \"%%API_URL%%api/v1/param_updates\" %%DEFAULT_HEADERS%%"
  "CLI Protocol Parameters|curl -skX GET \"%%API_URL%%api/v1/cli_protocol_params\" %%DEFAULT_HEADERS%%"
  "Reserve Withdrawals|curl -skX GET \"%%API_URL%%api/v1/reserve_withdrawals\" %%DEFAULT_HEADERS%%"
  "Treasury Withdrawals|curl -skX GET \"%%API_URL%%api/v1/treasury_withdrawals\" %%DEFAULT_HEADERS%%"

  # -------------------------
  # Epoch
  # -------------------------
  "Epoch Information|curl -skX GET \"%%API_URL%%api/v1/epoch_info?_epoch_no=166\" %%DEFAULT_HEADERS%%"
  "Epoch's Protocol Parameters|curl -skX GET \"%%API_URL%%api/v1/epoch_params?_epoch_no=166\" %%DEFAULT_HEADERS%%"
  "Epoch's Block Protocols|curl -skX GET \"%%API_URL%%api/v1/epoch_block_protocols?_epoch_no=166\" %%DEFAULT_HEADERS%%"

  # -------------------------
  # Block
  # -------------------------
  "Block List|curl -skX GET \"%%API_URL%%api/v1/blocks\" %%DEFAULT_HEADERS%%"
  "Block Information|curl -skX POST \"%%API_URL%%api/v1/block_info\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_block_hashes\":[\"2abeb8d1c1227139763be30ddb7a2fd79abd7d44195fca87a7c836a510b2802d\",\"4e790b758c495953bb33c4aad4a4b4c1b98f7c2ec135ebd3db21f32059481718\",\"389da613316d2aec61edc34d51f1b3d004891ab38c9419771e5e0a3b12de3ef6\"]}'"
  "Block Transactions|curl -skX POST \"%%API_URL%%api/v1/block_txs\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_block_hashes\":[\"2abeb8d1c1227139763be30ddb7a2fd79abd7d44195fca87a7c836a510b2802d\",\"4e790b758c495953bb33c4aad4a4b4c1b98f7c2ec135ebd3db21f32059481718\",\"389da613316d2aec61edc34d51f1b3d004891ab38c9419771e5e0a3b12de3ef6\"]}'"
  "Block Transactions (Raw CBOR)|curl -skX POST \"%%API_URL%%api/v1/block_tx_cbor\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_block_hashes\":[\"2abeb8d1c1227139763be30ddb7a2fd79abd7d44195fca87a7c836a510b2802d\",\"4e790b758c495953bb33c4aad4a4b4c1b98f7c2ec135ebd3db21f32059481718\",\"389da613316d2aec61edc34d51f1b3d004891ab38c9419771e5e0a3b12de3ef6\"]}'"
  "UTxO Info|curl -skX POST \"%%API_URL%%api/v1/utxo_info\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_utxo_refs\":[\"d10133964da9e443b303917fd0b7644ae3d01c133deff85b4f59416c2d00f530#0\",\"145688d3619e7524510ea64c0ec6363b77a9b8da179ef9bb0273a0940d57d576#0\"],\"_extended\":false}'"
  "Raw Transaction (CBOR)|curl -skX POST \"%%API_URL%%api/v1/tx_cbor\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_tx_hashes\":[\"d10133964da9e443b303917fd0b7644ae3d01c133deff85b4f59416c2d00f530\",\"145688d3619e7524510ea64c0ec6363b77a9b8da179ef9bb0273a0940d57d576\"]}'"
  "Transaction Information|curl -skX POST \"%%API_URL%%api/v1/tx_info\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_tx_hashes\":[\"d10133964da9e443b303917fd0b7644ae3d01c133deff85b4f59416c2d00f530\",\"145688d3619e7524510ea64c0ec6363b77a9b8da179ef9bb0273a0940d57d576\"],\"_inputs\":false,\"_metadata\":false,\"_assets\":false,\"_withdrawals\":false,\"_certs\":false,\"_scripts\":false,\"_bytecode\":false}'"
  "Transaction Metadata|curl -skX POST \"%%API_URL%%api/v1/tx_metadata\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_tx_hashes\":[\"d10133964da9e443b303917fd0b7644ae3d01c133deff85b4f59416c2d00f530\",\"145688d3619e7524510ea64c0ec6363b77a9b8da179ef9bb0273a0940d57d576\"]}'"
  "Transaction Metadata Labels|curl -skX GET \"%%API_URL%%api/v1/tx_metalabels\" %%DEFAULT_HEADERS%%"
  "Submit Transaction|curl -skX POST \"%%API_URL%%api/v1/submittx\" %%DEFAULT_HEADERS%% -H 'content-type: application/cbor' --data-binary @\${data} https://api.koios.rest/api/v1/submittx"
  "Transaction Status|curl -skX POST \"%%API_URL%%api/v1/tx_status\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_tx_hashes\":[\"d10133964da9e443b303917fd0b7644ae3d01c133deff85b4f59416c2d00f530\",\"145688d3619e7524510ea64c0ec6363b77a9b8da179ef9bb0273a0940d57d576\"]}'"

  # -------------------------
  # Stake Account
  # -------------------------
  "Account List|curl -skX GET \"%%API_URL%%api/v1/account_list\" %%DEFAULT_HEADERS%%"
  "Account Information|curl -skX POST \"%%API_URL%%api/v1/account_info\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_stake_addresses\":[\"stake_test1urq4rcynzj4uxqc74c852zky7wa6epgmn9r6k3j3gv7502q8jks0l\",\"stake_test1ur4t5nhceyn2amfuj7z74uxmmj8jf9fmgd2egqw8c98ve3cp2g4wx\"]}'"
  "Account Information (Cached)|curl -skX POST \"%%API_URL%%api/v1/account_info_cached\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_stake_addresses\":[\"stake_test1urq4rcynzj4uxqc74c852zky7wa6epgmn9r6k3j3gv7502q8jks0l\",\"stake_test1ur4t5nhceyn2amfuj7z74uxmmj8jf9fmgd2egqw8c98ve3cp2g4wx\"]}'"
  "UTxOs for stake addresses (accounts)|curl -skX POST \"%%API_URL%%api/v1/account_utxos\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_stake_addresses\":[\"stake_test1urq4rcynzj4uxqc74c852zky7wa6epgmn9r6k3j3gv7502q8jks0l\",\"stake_test1ur4t5nhceyn2amfuj7z74uxmmj8jf9fmgd2egqw8c98ve3cp2g4wx\"],\"_extended\":true}'"
  "Account Txs|curl -skX GET \"%%API_URL%%api/v1/account_txs?_stake_address=stake_test1urkzeud48zxwnjc54emzmmc3gkg2r6d6tm2sd799jxjnqxqlfzmvk&_after_block_height=50000\" %%DEFAULT_HEADERS%%"
  "Account Reward History|curl -skX POST \"%%API_URL%%api/v1/account_reward_history\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_stake_addresses\":[\"stake_test1urq4rcynzj4uxqc74c852zky7wa6epgmn9r6k3j3gv7502q8jks0l\",\"stake_test1ur4t5nhceyn2amfuj7z74uxmmj8jf9fmgd2egqw8c98ve3cp2g4wx\"],\"_epoch_no\":30}'"
  "Account Updates|curl -skX POST \"%%API_URL%%api/v1/account_updates\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_stake_addresses\":[\"stake_test1urq4rcynzj4uxqc74c852zky7wa6epgmn9r6k3j3gv7502q8jks0l\",\"stake_test1ur4t5nhceyn2amfuj7z74uxmmj8jf9fmgd2egqw8c98ve3cp2g4wx\"]}'"
  "Account Update History|curl -skX POST \"%%API_URL%%api/v1/account_update_history\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_stake_addresses\":[\"stake_test1urq4rcynzj4uxqc74c852zky7wa6epgmn9r6k3j3gv7502q8jks0l\",\"stake_test1ur4t5nhceyn2amfuj7z74uxmmj8jf9fmgd2egqw8c98ve3cp2g4wx\"]}'"
  "Account Addresses|curl -skX POST \"%%API_URL%%api/v1/account_addresses\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_stake_addresses\":[\"stake_test1urq4rcynzj4uxqc74c852zky7wa6epgmn9r6k3j3gv7502q8jks0l\",\"stake_test1ur4t5nhceyn2amfuj7z74uxmmj8jf9fmgd2egqw8c98ve3cp2g4wx\"],\"_first_only\":false,\"_empty\":false}'"
  "Account Assets|curl -skX POST \"%%API_URL%%api/v1/account_assets\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_stake_addresses\":[\"stake_test1urq4rcynzj4uxqc74c852zky7wa6epgmn9r6k3j3gv7502q8jks0l\",\"stake_test1ur4t5nhceyn2amfuj7z74uxmmj8jf9fmgd2egqw8c98ve3cp2g4wx\"]}'"
  "Account Stake History|curl -skX POST \"%%API_URL%%api/v1/account_stake_history\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_stake_addresses\":[\"stake_test1urq4rcynzj4uxqc74c852zky7wa6epgmn9r6k3j3gv7502q8jks0l\",\"stake_test1ur4t5nhceyn2amfuj7z74uxmmj8jf9fmgd2egqw8c98ve3cp2g4wx\"]}'"

  # -------------------------
  # Address
  # -------------------------
  "Address Information|curl -skX POST \"%%API_URL%%api/v1/address_info\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_addresses\":[\"addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw\",\"addr_test1vpfwv0ezc5g8a4mkku8hhy3y3vp92t7s3ul8g778g5yegsgalc6gc\"]}'"
  "Address UTXOs|curl -skX POST \"%%API_URL%%api/v1/address_utxos\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_addresses\":[\"addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw\",\"addr_test1vpfwv0ezc5g8a4mkku8hhy3y3vp92t7s3ul8g778g5yegsgalc6gc\"],\"_extended\":true}'"
  "Address Outputs|curl -skX POST \"%%API_URL%%api/v1/address_outputs\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_addresses\":[\"addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw\",\"addr_test1vpfwv0ezc5g8a4mkku8hhy3y3vp92t7s3ul8g778g5yegsgalc6gc\"],\"_after_block_height\":9417}'"
  "UTxOs from payment credentials|curl -skX POST \"%%API_URL%%api/v1/credential_utxos\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_payment_credentials\":[\"b429738bd6cc58b5c7932d001aa2bd05cfea47020a556c8c753d4436\",\"82e016828989cd9d809b50d6976d9efa9bc5b2c1a78d4b3bfa1bb83b\"],\"_extended\":true}'"
  "Address Transactions|curl -skX POST \"%%API_URL%%api/v1/address_txs\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_addresses\":[\"addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw\",\"addr_test1vpfwv0ezc5g8a4mkku8hhy3y3vp92t7s3ul8g778g5yegsgalc6gc\"],\"_after_block_height\":9417}'"
  "Transactions from payment credentials|curl -skX POST \"%%API_URL%%api/v1/credential_txs\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_payment_credentials\":[\"b429738bd6cc58b5c7932d001aa2bd05cfea47020a556c8c753d4436\",\"82e016828989cd9d809b50d6976d9efa9bc5b2c1a78d4b3bfa1bb83b\"]}'"
  "Address Assets|curl -skX POST \"%%API_URL%%api/v1/address_assets\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_addresses\":[\"addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw\",\"addr_test1vpfwv0ezc5g8a4mkku8hhy3y3vp92t7s3ul8g778g5yegsgalc6gc\"]}'"
  #"Address Stake History|curl -skX POST \"%%API_URL%%api/v1/address_stake_history\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_addresses\":[\"addr_test1vzpwq95z3xyum8vqndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw\",\"addr_test1vpfwv0ezc5g8a4mkku8hhy3y3vp92t7s3ul8g778g5yegsgalc6gc\"]}'"

  # -------------------------
  # Asset
  # -------------------------
  "Asset List|curl -skX GET \"%%API_URL%%api/v1/asset_list\" %%DEFAULT_HEADERS%%"
  "Policy Asset List|curl -skX GET \"%%API_URL%%api/v1/policy_asset_list?_asset_policy=c6e65ba7878b2f8ea0ad39287d3e2fd256dc5c4160fc19bdf4c4d87e\" %%DEFAULT_HEADERS%%"
  "Asset Token Registry|curl -skX GET \"%%API_URL%%api/v1/asset_token_registry\" %%DEFAULT_HEADERS%%"
  "Asset Information (Bulk)|curl -skX POST \"%%API_URL%%api/v1/asset_info\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_asset_list\":[[\"c6e65ba7878b2f8ea0ad39287d3e2fd256dc5c4160fc19bdf4c4d87e\",\"7447454e53\"],[\"777e6b4903dab74963ae581d39875c5dac16c09bb1f511c0af1ddda8\",\"6141414441\"]]}'"
  "Asset UTXOs|curl -skX POST \"%%API_URL%%api/v1/asset_utxos\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_asset_list\":[[\"c6e65ba7878b2f8ea0ad39287d3e2fd256dc5c4160fc19bdf4c4d87e\",\"7447454e53\"],[\"777e6b4903dab74963ae581d39875c5dac16c09bb1f511c0af1ddda8\",\"6141414441\"]],\"_extended\":true}'"
  "Asset History|curl -skX GET \"%%API_URL%%api/v1/asset_history?_asset_policy=c6e65ba7878b2f8ea0ad39287d3e2fd256dc5c4160fc19bdf4c4d87e&_asset_name=7447454e53\" %%DEFAULT_HEADERS%%"
  "Asset Addresses|curl -skX GET \"%%API_URL%%api/v1/asset_addresses?_asset_policy=c6e65ba7878b2f8ea0ad39287d3e2fd256dc5c4160fc19bdf4c4d87e&_asset_name=7447454e53\" %%DEFAULT_HEADERS%%"
  "NFT Address|curl -skX GET \"%%API_URL%%api/v1/asset_nft_address?_asset_policy=002126e5e7cb2f5b6ac52ef2cdb9308ff58bf6e3b62e29df447cec72&_asset_name=74657374\" %%DEFAULT_HEADERS%%"
  "Policy Asset Address List|curl -skX GET \"%%API_URL%%api/v1/policy_asset_addresses?_asset_policy=c6e65ba7878b2f8ea0ad39287d3e2fd256dc5c4160fc19bdf4c4d87e\" %%DEFAULT_HEADERS%%"
  "Policy Asset Information|curl -skX GET \"%%API_URL%%api/v1/policy_asset_info?_asset_policy=c6e65ba7878b2f8ea0ad39287d3e2fd256dc5c4160fc19bdf4c4d87e\" %%DEFAULT_HEADERS%%"
  "Policy Asset Mints|curl -skX GET \"%%API_URL%%api/v1/policy_asset_mints?_asset_policy=c6e65ba7878b2f8ea0ad39287d3e2fd256dc5c4160fc19bdf4c4d87e\" %%DEFAULT_HEADERS%%"
  "Asset Summary|curl -skX GET \"%%API_URL%%api/v1/asset_summary?_asset_policy=c6e65ba7878b2f8ea0ad39287d3e2fd256dc5c4160fc19bdf4c4d87e&_asset_name=7447454e53\" %%DEFAULT_HEADERS%%"
  "Asset Transactions|curl -skX GET \"%%API_URL%%api/v1/asset_txs?_asset_policy=c6e65ba7878b2f8ea0ad39287d3e2fd256dc5c4160fc19bdf4c4d87e&_asset_name=7447454e53&_after_block_height=50000\" %%DEFAULT_HEADERS%%"

  # -------------------------
  # Governance
  # -------------------------
  "DReps Epoch Summary|curl -skX GET \"%%API_URL%%api/v1/drep_epoch_summary?_epoch_no=166\" %%DEFAULT_HEADERS%%"
  "DReps List|curl -skX GET \"%%API_URL%%api/v1/drep_list\" %%DEFAULT_HEADERS%%"
  "DReps Info|curl -skX POST \"%%API_URL%%api/v1/drep_info\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_drep_ids\":[\"drep1ydmraa6kv8cvmry059v608tehl50nfmg0z764lmsqkvwurs40sw2z\",\"drep1y25j98kvqf7t3tj4pvxwrjr2728dsrfekptgg3kxqrr56qqcny8sn\"]}'"
  "DReps Metadata|curl -skX POST \"%%API_URL%%api/v1/drep_metadata\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_drep_ids\":[\"drep1ydmraa6kv8cvmry059v608tehl50nfmg0z764lmsqkvwurs40sw2z\",\"drep1y25j98kvqf7t3tj4pvxwrjr2728dsrfekptgg3kxqrr56qqcny8sn\"]}'"
  "DReps Updates|curl -skX GET \"%%API_URL%%api/v1/drep_updates?_drep_id=drep1ydmraa6kv8cvmry059v608tehl50nfmg0z764lmsqkvwurs40sw2z\" %%DEFAULT_HEADERS%%"
  "DReps Voting Power History|curl -skX GET \"%%API_URL%%api/v1/drep_voting_power_history?_epoch_no=166&_drep_id=drep1ydmraa6kv8cvmry059v608tehl50nfmg0z764lmsqkvwurs40sw2z\" %%DEFAULT_HEADERS%%"
  "DReps Delegators|curl -skX GET \"%%API_URL%%api/v1/drep_delegators?_drep_id=drep1ydmraa6kv8cvmry059v608tehl50nfmg0z764lmsqkvwurs40sw2z\" %%DEFAULT_HEADERS%%"
  "Committee Information|curl -skX GET \"%%API_URL%%api/v1/committee_info\" %%DEFAULT_HEADERS%%"
  "Committee Votes|curl -skX GET \"%%API_URL%%api/v1/committee_votes?_cc_hot_id=cc_hot1qgqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqvcdjk7\" %%DEFAULT_HEADERS%%"
  "Proposals List|curl -skX GET \"%%API_URL%%api/v1/proposal_list\" %%DEFAULT_HEADERS%%"
  "Voter's Proposal List|curl -skX GET \"%%API_URL%%api/v1/voter_proposal_list?_voter_id=drep1ydmraa6kv8cvmry059v608tehl50nfmg0z764lmsqkvwurs40sw2z\" %%DEFAULT_HEADERS%%"
  "Proposal Voting Summary|curl -skX GET \"%%API_URL%%api/v1/proposal_voting_summary?_proposal_id=gov_action14lefp8upwhhq92xph7t075txshf9huxxh9d2ey05ml2n5hqgvlxqqp92kfl\" %%DEFAULT_HEADERS%%"
  "Proposal Votes|curl -skX GET \"%%API_URL%%api/v1/proposal_votes?_proposal_id=gov_action14lefp8upwhhq92xph7t075txshf9huxxh9d2ey05ml2n5hqgvlxqqp92kfl\" %%DEFAULT_HEADERS%%"
  "Vote List|curl -skX GET \"%%API_URL%%api/v1/vote_list\" %%DEFAULT_HEADERS%%"
  "Pool's Voting Power History|curl -skX GET \"%%API_URL%%api/v1/pool_voting_power_history?_epoch_no=166&_pool_bech32=pool1vw6fr9agt58djrp3w0t0lsn6t329t6eusqxz5ugd9w7ecyedsdv\" %%DEFAULT_HEADERS%%"

  # -------------------------
  # Pool
  # -------------------------
  "Pool List|curl -skX GET \"%%API_URL%%api/v1/pool_list\" %%DEFAULT_HEADERS%%"
  "Pool Information|curl -skX POST \"%%API_URL%%api/v1/pool_info\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_pool_bech32_ids\":[\"pool1ext7qrwjzaxcdfhdnkq5mth59ukuu2atcg6tgqpmevpt7ratkta\",\"pool1vw6fr9agt58djrp3w0t0lsn6t329t6eusqxz5ugd9w7ecyedsdv\",\"pool1ws42l6rawqjv58crs5l32v0eem3qnngpnjfd7epwd4lmjccc5cg\"]}'"
  "Pool Stake Snapshot|curl -skX GET \"%%API_URL%%api/v1/pool_stake_snapshot?_pool_bech32=pool1vw6fr9agt58djrp3w0t0lsn6t329t6eusqxz5ugd9w7ecyedsdv\" %%DEFAULT_HEADERS%%"
  "Pool Delegators List|curl -skX GET \"%%API_URL%%api/v1/pool_delegators?_pool_bech32=pool1vw6fr9agt58djrp3w0t0lsn6t329t6eusqxz5ugd9w7ecyedsdv\" %%DEFAULT_HEADERS%%"
  "Pool Delegators History|curl -skX GET \"%%API_URL%%api/v1/pool_delegators_history?_pool_bech32=pool1vw6fr9agt58djrp3w0t0lsn6t329t6eusqxz5ugd9w7ecyedsdv&_epoch_no=166\" %%DEFAULT_HEADERS%%"
  "Pool Blocks|curl -skX GET \"%%API_URL%%api/v1/pool_blocks?_pool_bech32=pool1vw6fr9agt58djrp3w0t0lsn6t329t6eusqxz5ugd9w7ecyedsdv&_epoch_no=166\" %%DEFAULT_HEADERS%%"
  "Pool Owner History|curl -skX POST \"%%API_URL%%api/v1/pool_owner_history\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_pool_bech32_ids\":[\"pool1ext7qrwjzaxcdfhdnkq5mth59ukuu2atcg6tgqpmevpt7ratkta\",\"pool1vw6fr9agt58djrp3w0t0lsn6t329t6eusqxz5ugd9w7ecyedsdv\",\"pool1ws42l6rawqjv58crs5l32v0eem3qnngpnjfd7epwd4lmjccc5cg\"]}'"
  "Pool Stake, Block and Reward History|curl -skX GET \"%%API_URL%%api/v1/pool_history?_pool_bech32=pool1vw6fr9agt58djrp3w0t0lsn6t329t6eusqxz5ugd9w7ecyedsdv&_epoch_no=166\" %%DEFAULT_HEADERS%%"
  "Pool Updates (History)|curl -skX GET \"%%API_URL%%api/v1/pool_updates?_pool_bech32=pool1vw6fr9agt58djrp3w0t0lsn6t329t6eusqxz5ugd9w7ecyedsdv\" %%DEFAULT_HEADERS%%"
  "Pool Registrations|curl -skX GET \"%%API_URL%%api/v1/pool_registrations?_epoch_no=31\" %%DEFAULT_HEADERS%%"
  "Pool Retirements|curl -skX GET \"%%API_URL%%api/v1/pool_retirements?_epoch_no=166\" %%DEFAULT_HEADERS%%"
  "Pool Relays|curl -skX GET \"%%API_URL%%api/v1/pool_relays\" %%DEFAULT_HEADERS%%"
  "Pool Groups|curl -skX GET \"%%API_URL%%api/v1/pool_groups\" %%DEFAULT_HEADERS%%"
  "Pool Metadata|curl -skX POST \"%%API_URL%%api/v1/pool_metadata\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_pool_bech32_ids\":[\"pool1ext7qrwjzaxcdfhdnkq5mth59ukuu2atcg6tgqpmevpt7ratkta\",\"pool1vw6fr9agt58djrp3w0t0lsn6t329t6eusqxz5ugd9w7ecyedsdv\",\"pool1ws42l6rawqjv58crs5l32v0eem3qnngpnjfd7epwd4lmjccc5cg\"]}'"
  "Pool Calidus Keys|curl -skX GET \"%%API_URL%%api/v1/pool_calidus_keys\" %%DEFAULT_HEADERS%%"

  # -------------------------
  # Script
  # -------------------------
  "Script Information|curl -skX POST \"%%API_URL%%api/v1/script_info\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_script_hashes\":[\"a8e9f8f34fd631b1d5b9f41a90f4abc0d3935cea7baba0bb34c96f59\",\"b4fd6dfe4a643aeec5d75dbb1f27198fc2aabf30bf92ed5470253792\"]}'"
  "Native Script List|curl -skX GET \"%%API_URL%%api/v1/native_script_list\" %%DEFAULT_HEADERS%%"
  "Plutus Script List|curl -skX GET \"%%API_URL%%api/v1/plutus_script_list\" %%DEFAULT_HEADERS%%"
  "Script Redeemers|curl -skX GET \"%%API_URL%%api/v1/script_redeemers?_script_hash=14abafb323de75b7266fd0eab29b6ef562305e8a0dfbb64b07ef32c7\" %%DEFAULT_HEADERS%%"
  "Script UTXOs|curl -skX GET \"%%API_URL%%api/v1/script_utxos?_script_hash=14abafb323de75b7266fd0eab29b6ef562305e8a0dfbb64b07ef32c7\" %%DEFAULT_HEADERS%%"
  "Datum Information|curl -skX POST \"%%API_URL%%api/v1/datum_info\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"_datum_hashes\":[\"5571e2c3549f15934a38382d1318707a86751fb70827f4cbd29b104480f1be9b\",\"5f7212f546d7e7308ce99b925f05538db19981f4ea3084559c0b28a363245826\"]}'"

  # -------------------------
  # PostgREST Features
  # -------------------------
  "Check Pagination Header|curl -s \"https://api.koios.rest/api/v1/blocks?select=block_height&offset=1000&limit=500\" -I | grep -i content-range"
  "Blocks by Pool ID Ascending|curl -s \"https://api.koios.rest/api/v1/blocks?pool=eq.pool155efqn9xpcf73pphkk88cmlkdwx4ulkg606tne970qswczg3asc&order=block_height.asc&limit=5\""
  "CSV Response Sample|curl -s \"https://api.koios.rest/api/v1/blocks?select=epoch_no,epoch_slot,block_time&limit=3\" -H \"Accept: text/csv\""

  # -------------------------
  # Ogmios
  # -------------------------
  "Ogmios - Block Height|curl -skX POST \"%%API_URL%%api/v1/ogmios\" %%DEFAULT_HEADERS%% -H 'content-type: application/json' -d '{\"jsonrpc\":\"2.0\",\"method\":\"queryNetwork/blockHeight\"}'"
  "Ogmios - Genesis Configuration|curl -skX POST %%API_URL%%api/v1/ogmios -H \"Content-Type: application/json\" -d '{\"jsonrpc\":\"2.0\",\"method\":\"queryNetwork/genesisConfiguration\",\"params\":{\"era\":\"shelley\"}}'"
  "Ogmios - Network Start Time|curl -skX POST %%API_URL%%api/v1/ogmios -H \"Content-Type: application/json\" -d '{\"jsonrpc\":\"2.0\",\"method\":\"queryNetwork/startTime\"}'"
  "Ogmios - Network Tip|curl -skX POST %%API_URL%%api/v1/ogmios -H \"Content-Type: application/json\" -d '{\"jsonrpc\":\"2.0\",\"method\":\"queryNetwork/tip\"}'"
  "Ogmios - Epoch Info|curl -skX POST %%API_URL%%api/v1/ogmios -H \"Content-Type: application/json\" -d '{\"jsonrpc\":\"2.0\",\"method\":\"queryLedgerState/epoch\"}'"
  "Ogmios - Era Start|curl -skX POST %%API_URL%%api/v1/ogmios -H \"Content-Type: application/json\" -d '{\"jsonrpc\":\"2.0\",\"method\":\"queryLedgerState/eraStart\"}'"
  "Ogmios - Era Summaries|curl -skX POST %%API_URL%%api/v1/ogmios -H \"Content-Type: application/json\" -d '{\"jsonrpc\":\"2.0\",\"method\":\"queryLedgerState/eraSummaries\"}'"
  "Ogmios - Live Stake Distribution|curl -skX POST %%API_URL%%api/v1/ogmios -H \"Content-Type: application/json\" -d '{\"jsonrpc\":\"2.0\",\"method\":\"queryLedgerState/liveStakeDistribution\"}'"
  "Ogmios - Protocol Parameters|curl -skX POST %%API_URL%%api/v1/ogmios -H \"Content-Type: application/json\" -d '{\"jsonrpc\":\"2.0\",\"method\":\"queryLedgerState/protocolParameters\"}'"
  "Ogmios - Proposed Protocol Parameters|curl -skX POST %%API_URL%%api/v1/ogmios -H \"Content-Type: application/json\" -d '{\"jsonrpc\":\"2.0\",\"method\":\"queryLedgerState/proposedProtocolParameters\"}'"
  "Ogmios - Stake Pools|curl -skX POST %%API_URL%%api/v1/ogmios -H \"Content-Type: application/json\" -d '{\"jsonrpc\":\"2.0\",\"method\":\"queryLedgerState/stakePools\"}'"
  "Ogmios - Submit Transaction|curl -skX POST %%API_URL%%api/v1/ogmios -H \"Content-Type: application/json\" -d '{\"jsonrpc\":\"2.0\",\"method\":\"submitTransaction\",\"params\":{\"transaction\":{\"cbor\":\"<CBOR-serialized signed transaction (base16)>\"}}}'"
  "Ogmios - Evaluate Transaction|curl -skX POST %%API_URL%%api/v1/ogmios -H \"Content-Type: application/json\" -d '{\"jsonrpc\":\"2.0\",\"method\":\"evaluateTransaction\",\"params\":{\"transaction\":{\"cbor\":\"<CBOR-serialized signed transaction (base16)>\"},\"additionalUtxo\":[{…}]}}'"

)

run_test() {
  local do_run="$1"
  local tmpl="$2"
  local api_url="$3"

  local cmd="${tmpl//%%API_URL%%/$api_url}"
  cmd="${cmd//%%DEFAULT_HEADERS%%/$DEFAULT_HEADERS}"

  if [[ "$do_run" == "showCmd" ]]; then
    echo "$cmd"
  else
    eval "$cmd"
  fi
}
run_tests() {
  local idx=0
  local failures=0

  for entry in "${TEST_CASES[@]}"; do
    ((idx++))
    IFS='|' read -r name tmpl <<<"$entry"

    echo -e "\n=== Test #$idx: $name ==="
    echo "CMD for Received: $(run_test showCmd "$tmpl" "$TESTING_KOIOS_URL")"
    echo "CMD for Expected: $(run_test showCmd "$tmpl" "$OFFICIAL_KOIOS_URL")"

    local received
    received=$(run_test run "$tmpl" "$TESTING_KOIOS_URL" | jq -S .)
    sleep "$COOLDOWN_SECS"
    local expected
    expected=$(run_test run "$tmpl" "$OFFICIAL_KOIOS_URL" | jq -S .)

    if diff <(echo "$received") <(echo "$expected") >/dev/null; then
      echo "✅ PASSED"
    else
      echo "❌ FAILED: $name"
      echo "--- RECEIVED ---"
      echo "$received"
      echo
      echo "--- EXPECTED ---"
      echo "$expected"
      ((failures++))
    fi

    sleep "$COOLDOWN_SECS"
  done

  echo -e "\n=== Summary ==="
  if [[ $failures -eq 0 ]]; then
    echo "All tests passed 🎉"
  else
    echo "$failures test(s) failed ❌"
  fi
  echo -e "\nAll done."
}

run_tests
