# deploy chaincode
export PATH="${PWD}/bin":$PATH
export FABRIC_CFG_PATH=${PWD}/
CHANNEL_NAME="mychannel"
CC_NAME=${1:-"basic"}
CC_SRC_PATH="./chaincode/${CC_NAME}/"
CC_VERSION="1.0"
CC_SEQUENCE="1"
CC_RUNTIME_LANGUAGE="golang"

. ./scripts/envs.sh

C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_BLUE='\033[0;34m'
C_YELLOW='\033[1;33m'

function succ(){
    echo -e "${C_GREEN}${1}${C_RESET}"
}

echo "deploying" $CC_NAME $CC_SRC_PATH

## package the chaincode
orgenv 1
peer lifecycle chaincode package ./generated/${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CC_NAME}_${CC_VERSION} 
succ "successfully package the chaincode"

## Install chaincode on peer0.org1 and peer0.org2
peer lifecycle chaincode install ./generated/${CC_NAME}.tar.gz
succ "successfully install the chaincode"

## query whether the chaincode is installed
peer lifecycle chaincode queryinstalled > ./generated/log.txt
PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" ./tmp/log.txt)
succ "query package id: ${PACKAGE_ID}"
 
## approve the definition for org1
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.tanglizi.one --tls --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE} --package-id ${PACKAGE_ID} 
succ "successfully approve the chaincode def for org1"

## check whether the chaincode definition is ready to be committed
## expect org1 to have approved and org2 not to
# "Org1MSP": true" "Org2MSP": false"
# "Org1MSP": true" "Org2MSP": false"
peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} \
    --sequence ${CC_SEQUENCE} --output json
succ "checked whether the chaincode definition is ready to be committed for org1"

## now that we know for sure both orgs have approved, commit the definition
succ "now that we know for sure both orgs have approved, commit the definition"
peerenv 1 
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.tanglizi.one --tls --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME --name ${CC_NAME} $PEER_CONN_PARMS --version ${CC_VERSION} \
    --sequence ${CC_SEQUENCE} 
succ "successfully committed"

## query on both orgs to see that the definition committed successfully
poll "peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}"
succ "query org1 to see if the def committed"

## Invoke the chaincode - this does require that the chaincode have the 'initLedger'
## method defined
# peerenv 1 2
# peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA \
#     -C $CHANNEL_NAME -n ${CC_NAME} $PEER_CONN_PARMS --isInit -c ${fcn_call}

