. ./scripts/envs.sh

export PATH="${PWD}/bin":$PATH
export FABRIC_CFG_PATH=${PWD}/

CHANNEL_NAME="mychannel"
CC_NAME="basic"
CC_SRC_PATH="./chaincode/${CC_NAME}/"
CC_VERSION="1.0"
CC_SEQUENCE="1"
CC_RUNTIME_LANGUAGE="golang"

export ORDERER_CA=${PWD}/orgs/ordererOrgs/tanglizi.one/orderers/orderer.tanglizi.one/msp/tlscacerts/tlsca.tanglizi.one-cert.pem
export PEER0_ORG1_CA=${PWD}/orgs/peerOrgs/org1.tanglizi.one/peers/peer0.org1.tanglizi.one/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/orgs/peerOrgs/org2.tanglizi.one/peers/peer0.org2.tanglizi.one/tls/ca.crt
export CORE_PEER_TLS_ENABLED=true

orgenv 1
peerenv 1
export ALL_INVOKE_PARMS="-o localhost:7050 --ordererTLSHostnameOverride orderer.tanglizi.one --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} $PEER_CONN_PARMS"

# You can use exported params to run cli commands.
# 
# Example:
# 
# > . ./env.sh
# 
# > peer chaincode invoke $ALL_INVOKE_PARMS -c '{"function":"InitLedger", "Args": []}'
#   # if you are using zsh, the env params need to be ${=ALL_INVOKE_PARMS}
# 
# > peer lifecycle chaincode queryapproved -C mychannel -n basic --output json | jq .
#   {
#     "sequence": 1,
#     "version": "1.0",
#     "endorsement_plugin": "escc",
#     "validation_plugin": "vscc",
#     "validation_parameter": "EiAvQ2hhbm5lbC9BcHBsaWNhdGlvbi9FbmRvcnNlbWVudA==",
#     "collections": {},
#     "source": {
#       "Type": {
#         "LocalPackage": {
#           "package_id": "basic_1.0:4ec191e793b27e953ff2ede5a8bcc63152cecb1e4c3f301a26e22692c61967ad"
#         }
#       }
#     }
#   }
# 
# > peer channel getinfo -c mychannel | awk -F ' ' '{print $3}' | jq .                   -- INSERT --
#   {
#     "height": 6,
#     "currentBlockHash": "IXxJ2uooO5V+m3om0il2CaLOdrKd2jF1n7VDyV0ZgmM=",
#     "previousBlockHash": "n2yoE1rXuao71PR+jFwd7z+xy5gA6BH3MwgFOPLNnvM="
#   }
# 
# > peer chaincode instantiate -n basic2 -v 1 -P "AND ('Org1MSP.peer')" ${=ALL_INVOKE_PARMS} -c '{"function": "InitLedger", "Args":[]}'
#   # dev-mode is using V2.0 channel, please use new lifecycle cli commands.
#   Error: could not assemble transaction, err proposal response was not successful, error code 500, msg Channel 'mychannel' has been migrated to the new lifecycle, LSCC is now read-only
