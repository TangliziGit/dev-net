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
ALL_INVOKE_PARMS="-o localhost:7050 --ordererTLSHostnameOverride orderer.tanglizi.one --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} $PEER_CONN_PARMS"

# you can write cli command below.

# peer chaincode invoke $ALL_INVOKE_PARMS \
#     -c '{"function":"InitLedger", "Args": []}'

peer chaincode invoke $ALL_INVOKE_PARMS \
    -c '{"function":"ReadAsset", "Args": ["asset2"]}'

