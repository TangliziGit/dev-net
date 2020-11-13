C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_BLUE='\033[0;34m'
C_YELLOW='\033[1;33m'

function succ(){
    echo -e "${C_GREEN}${1}${C_RESET}"
}

function createOrg1() {
  # register and enroll org1
  # set fabric-ca-client-home for fabric-ca-client-config.yaml
  export FABRIC_CA_CLIENT_HOME=${PWD}/orgs/peerOrgs/org1.tanglizi.one/
  
  # enroll as admin
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-org1 --tls.certfiles ${PWD}/orgs/ca/org1/tls-cert.pem
  
  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/orgs/peerOrgs/org1.tanglizi.one/msp/config.yaml
  
  # register peer0, user1, org1admin
  fabric-ca-client register --caname ca-org1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/orgs/ca/org1/tls-cert.pem
  fabric-ca-client register --caname ca-org1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/orgs/ca/org1/tls-cert.pem
  fabric-ca-client register --caname ca-org1 --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles ${PWD}/orgs/ca/org1/tls-cert.pem
  
  # enroll as peer0 to create msp
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-org1 -M ${PWD}/orgs/peerOrgs/org1.tanglizi.one/peers/peer0.org1.tanglizi.one/msp --csr.hosts peer0.org1.tanglizi.one --tls.certfiles ${PWD}/orgs/ca/org1/tls-cert.pem
  cp ${PWD}/orgs/peerOrgs/org1.tanglizi.one/msp/config.yaml \
     ${PWD}/orgs/peerOrgs/org1.tanglizi.one/peers/peer0.org1.tanglizi.one/msp/config.yaml
  
  # enroll as peer0 to create tls
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-org1 -M ${PWD}/orgs/peerOrgs/org1.tanglizi.one/peers/peer0.org1.tanglizi.one/tls --enrollment.profile tls --csr.hosts peer0.org1.tanglizi.one --csr.hosts localhost --tls.certfiles ${PWD}/orgs/ca/org1/tls-cert.pem
  mkdir -p orgs/peerOrgs/org1.tanglizi.one/msp/tlscacerts/
  mkdir -p orgs/peerOrgs/org1.tanglizi.one/tlsca/
  mkdir -p orgs/peerOrgs/org1.tanglizi.one/ca/
  
  cp ${PWD}/orgs/peerOrgs/org1.tanglizi.one/peers/peer0.org1.tanglizi.one/tls/tlscacerts/* \
     ${PWD}/orgs/peerOrgs/org1.tanglizi.one/peers/peer0.org1.tanglizi.one/tls/ca.crt
  cp ${PWD}/orgs/peerOrgs/org1.tanglizi.one/peers/peer0.org1.tanglizi.one/tls/signcerts/* \
     ${PWD}/orgs/peerOrgs/org1.tanglizi.one/peers/peer0.org1.tanglizi.one/tls/server.crt
  cp ${PWD}/orgs/peerOrgs/org1.tanglizi.one/peers/peer0.org1.tanglizi.one/tls/keystore/*  \
     ${PWD}/orgs/peerOrgs/org1.tanglizi.one/peers/peer0.org1.tanglizi.one/tls/server.key
  
  cp ${PWD}/orgs/peerOrgs/org1.tanglizi.one/peers/peer0.org1.tanglizi.one/tls/tlscacerts/* \
     ${PWD}/orgs/peerOrgs/org1.tanglizi.one/msp/tlscacerts/ca.crt
  cp ${PWD}/orgs/peerOrgs/org1.tanglizi.one/peers/peer0.org1.tanglizi.one/tls/tlscacerts/* \
     ${PWD}/orgs/peerOrgs/org1.tanglizi.one/tlsca/tlsca.org1.tanglizi.one-cert.pem
  cp ${PWD}/orgs/peerOrgs/org1.tanglizi.one/peers/peer0.org1.tanglizi.one/msp/cacerts/* \
     ${PWD}/orgs/peerOrgs/org1.tanglizi.one/ca/ca.org1.tanglizi.one-cert.pem
  
  # enroll as user1 to create msp
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-org1 -M ${PWD}/orgs/peerOrgs/org1.tanglizi.one/users/User1@org1.tanglizi.one/msp --tls.certfiles ${PWD}/orgs/ca/org1/tls-cert.pem
  cp ${PWD}/orgs/peerOrgs/org1.tanglizi.one/msp/config.yaml \
     ${PWD}/orgs/peerOrgs/org1.tanglizi.one/users/User1@org1.tanglizi.one/msp/config.yaml
  
  # enroll as org1admin to create msp
  fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7054 --caname ca-org1 -M ${PWD}/orgs/peerOrgs/org1.tanglizi.one/users/Admin@org1.tanglizi.one/msp --tls.certfiles ${PWD}/orgs/ca/org1/tls-cert.pem
  cp ${PWD}/orgs/peerOrgs/org1.tanglizi.one/msp/config.yaml \
     ${PWD}/orgs/peerOrgs/org1.tanglizi.one/users/Admin@org1.tanglizi.one/msp/config.yaml
}

function createOrderer() {
  # register and enroll orderer
  # set fabric-ca-client-home for fabric-ca-client-config.yaml
  export FABRIC_CA_CLIENT_HOME=${PWD}/orgs/ordererOrgs/tanglizi.one/
  
  # enroll as admin
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/orgs/ca/ordererOrg/tls-cert.pem
  
  # ???
  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/orgs/ordererOrgs/tanglizi.one/msp/config.yaml
  
  # register orderer, ordererAdmin
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/orgs/ca/ordererOrg/tls-cert.pem
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/orgs/ca/ordererOrg/tls-cert.pem
  
  # enroll as orderer to create msp
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/orgs/ordererOrgs/tanglizi.one/orderers/orderer.tanglizi.one/msp --csr.hosts orderer.tanglizi.one --tls.certfiles ${PWD}/orgs/ca/ordererOrg/tls-cert.pem
  cp ${PWD}/orgs/ordererOrgs/tanglizi.one/msp/config.yaml ${PWD}/orgs/ordererOrgs/tanglizi.one/orderers/orderer.tanglizi.one/msp/config.yaml
  
  # ??? why tls directory? why enrollment.profile?
  # enroll as orderer to create tls
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/orgs/ordererOrgs/tanglizi.one/orderers/orderer.tanglizi.one/tls --enrollment.profile tls --csr.hosts orderer.tanglizi.one --csr.hosts localhost --tls.certfiles ${PWD}/orgs/ca/ordererOrg/tls-cert.pem
  mkdir -p orgs/ordererOrgs/tanglizi.one/orderers/orderer.tanglizi.one/msp/tlscacerts/
  mkdir -p orgs/ordererOrgs/tanglizi.one/orderers/orderer.tanglizi.one/tlsca/
  mkdir -p orgs/ordererOrgs/tanglizi.one/orderers/orderer.tanglizi.one/ca/
  mkdir -p orgs/ordererOrgs/tanglizi.one/msp/tlscacerts/
  
  cp ${PWD}/orgs/ordererOrgs/tanglizi.one/orderers/orderer.tanglizi.one/tls/tlscacerts/* ${PWD}/orgs/ordererOrgs/tanglizi.one/orderers/orderer.tanglizi.one/tls/ca.crt
  cp ${PWD}/orgs/ordererOrgs/tanglizi.one/orderers/orderer.tanglizi.one/tls/signcerts/*  ${PWD}/orgs/ordererOrgs/tanglizi.one/orderers/orderer.tanglizi.one/tls/server.crt
  cp ${PWD}/orgs/ordererOrgs/tanglizi.one/orderers/orderer.tanglizi.one/tls/keystore/*   ${PWD}/orgs/ordererOrgs/tanglizi.one/orderers/orderer.tanglizi.one/tls/server.key

  cp ${PWD}/orgs/ordererOrgs/tanglizi.one/orderers/orderer.tanglizi.one/tls/tlscacerts/* ${PWD}/orgs/ordererOrgs/tanglizi.one/orderers/orderer.tanglizi.one/msp/tlscacerts/tlsca.tanglizi.one-cert.pem
  cp ${PWD}/orgs/ordererOrgs/tanglizi.one/orderers/orderer.tanglizi.one/tls/tlscacerts/* ${PWD}/orgs/ordererOrgs/tanglizi.one/msp/tlscacerts/tlsca.tanlizi.one-cert.pem
  
  # enroll as ordererAdmin to create msp
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/orgs/ordererOrgs/tanglizi.one/users/Admin@tanglizi.one/msp --tls.certfiles ${PWD}/orgs/ca/ordererOrg/tls-cert.pem
  cp ${PWD}/orgs/ordererOrgs/tanglizi.one/msp/config.yaml ${PWD}/orgs/ordererOrgs/tanglizi.one/users/Admin@tanglizi.one/msp/config.yaml
}

. ./scripts/envs.sh

export PATH=${PWD}/bin:$PATH
export FABRIC_CFG_PATH=${PWD}/configtx

# create fabric-ca for peer org and orderer org
# the dockerfile
IMAGE_TAG="latest" docker-compose -f docker-compose-fabric-ca.yaml up -d

# wait for creating dirs
sleep 4

# register and enroll orgs to create msp and tls-cert
createOrg1
createOrderer
succ "successfully create org1, org2 and orderer org"

# generate connection configs
# it is not necessary
# ./scripts/ccp-generate.sh

# generate orderer system and genesis block
configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock ${PWD}/system-genesis-block/genesis.block

# start up the two org and one orderer network
COMPOSE_PROJECT_NAME="dev-net" IMAGE_TAG="latest" docker-compose -f docker-compose-test-net.yaml up -d
docker ps -a

# create channel
CHANNEL_NAME="mychannel"
FABRIC_CFG_PATH=${PWD}/configtx
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
succ "successfully generate channel tx and two org anchor tx"

# introduce core.yaml config
FABRIC_CFG_PATH=$PWD/def-config/
export ORDERER_CA=${PWD}/orgs/ordererOrgs/tanglizi.one/orderers/orderer.tanglizi.one/msp/tlscacerts/tlsca.tanglizi.one-cert.pem
export PEER0_ORG1_CA=${PWD}/orgs/peerOrgs/org1.tanglizi.one/peers/peer0.org1.tanglizi.one/tls/ca.crt
export CORE_PEER_TLS_ENABLED=true

orgenv 1
poll "peer channel create -o localhost:7050 -c $CHANNEL_NAME --ordererTLSHostnameOverride orderer.tanglizi.one -f ./channel-artifacts/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block --tls --cafile $ORDERER_CA"
succ "successfully create channel"

## Join all the peers to the channel
poll "peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block"
succ "successfully joined"

## Set the anchor peers for each org in the channel
poll "peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.tanglizi.one -c $CHANNEL_NAME -f ./channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx --tls --cafile $ORDERER_CA"
succ "successfully set anchor peers"

docker-compose -f docker-compose-test-net.yaml logs -f
