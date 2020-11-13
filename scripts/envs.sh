export ORDERER_CA=${PWD}/orgs/ordererOrgs/tanglizi.one/orderers/orderer.tanglizi.one/msp/tlscacerts/tlsca.tanglizi.one-cert.pem
export PEER0_ORG1_CA=${PWD}/orgs/peerOrgs/org1.tanglizi.one/peers/peer0.org1.tanglizi.one/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/orgs/peerOrgs/org2.tanglizi.one/peers/peer0.org2.tanglizi.one/tls/ca.crt
export CORE_PEER_TLS_ENABLED=true

function orgenv(){
    if [[ $1 -eq 1 ]] ; then 
        export CORE_PEER_LOCALMSPID="Org1MSP"
        export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
        export CORE_PEER_MSPCONFIGPATH=${PWD}/orgs/peerOrgs/org1.tanglizi.one/users/Admin@org1.tanglizi.one/msp
        export CORE_PEER_ADDRESS=localhost:7051
    elif [[ $1 -eq 2 ]] ; then 
        export CORE_PEER_LOCALMSPID="Org2MSP"
        export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
        export CORE_PEER_MSPCONFIGPATH=${PWD}/orgs/peerOrgs/org2.tanglizi.one/users/Admin@org2.tanglizi.one/msp
        export CORE_PEER_ADDRESS=localhost:9051
    fi
}

function peerenv(){
    # to get PEERS and PEER_CONN_PARMS env args.
    # PEERS = "peer0.org1 peer0.org2"
    # PEER_CONN_PARMS = "--peerAddress localhost:7051 --tlsRootCertFiles ..."

    PEER_CONN_PARMS=""
    PEERS=""
    while [ "$#" -gt 0 ]; do
        orgenv $1
        PEER="peer0.org$1"
        ## Set peer addresses
        PEERS="$PEERS $PEER"
        PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
        ## Set path to TLS certificate
        TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_ORG$1_CA")
        PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
        # shift by one to get to the next organization
        shift
    done
    # remove leading space for output
    PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

function poll(){
    res=1
    while [ $res -ne 0 ]; do
        sleep 0.5
        echo "-> $1"
        eval "$1"
        res=$?
    done
}
