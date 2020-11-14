# dev-net
Provides a simple network based on Hyperledger Fabric 2.2, to illustrate the network and chaincode deployment process and test smart contracts in development.

## Deploy
```shell
# Copy your chaincode dev directory to here, and deploy it later.
cp -r /your/chaincode/dir/XXX chaincode/

# Start up a simple network including one orderer, one peer and two CAs,
# and create a channel named `mychannel`.
./up.sh
# You will see the continuous `docker-compose` log, for testing purpose.

# Deploy your chaincode.
./deploy.sh XXX
```

## Test
```shell
# Introduce CLI params you will need.
# So you can use exported params to run cli commands.
. ./env.sh
```

## Example

```shell
$ . ./env.sh

$ peer chaincode invoke $ALL_INVOKE_PARMS -c '{"function":"InitLedger", "Args": []}'
  # if you are using zsh, the env params need to be ${=ALL_INVOKE_PARMS}

$ peer lifecycle chaincode queryapproved -C mychannel -n basic --output json | jq .
  {
    "sequence": 1,
    "version": "1.0",
    "endorsement_plugin": "escc",
    "validation_plugin": "vscc",
    "validation_parameter": "EiAvQ2hhbm5lbC9BcHBsaWNhdGlvbi9FbmRvcnNlbWVudA==",
    "collections": {},
    "source": {
      "Type": {
        "LocalPackage": {
          "package_id": "basic_1.0:4ec191e793b27e953ff2ede5a8bcc63152cecb1e4c3f301a26e22692c61967ad"
        }
      }
    }
  }

$ peer channel getinfo -c mychannel | awk -F ' ' '{print $3}' | jq .                   -- INSERT --
  {
    "height": 6,
    "currentBlockHash": "IXxJ2uooO5V+m3om0il2CaLOdrKd2jF1n7VDyV0ZgmM=",
    "previousBlockHash": "n2yoE1rXuao71PR+jFwd7z+xy5gA6BH3MwgFOPLNnvM="
  }

$ peer chaincode instantiate -n basic2 -v 1 -P "AND ('Org1MSP.peer')" ${=ALL_INVOKE_PARMS} -c '{"function": "InitLedger", "Args":[]}'
  # dev-mode is using V2.0 channel, please use new lifecycle cli commands.
  Error: could not assemble transaction, err proposal response was not successful, error code 500, msg Channel 'mychannel' has been migrated to the new lifecycle, LSCC is now read-only

```


## Reference

- <https://hyperledger-fabric.readthedocs.io/en/release-2.2/>
- <https://github.com/hyperledger/fabric-samples>
- <http://zsh.sourceforge.net/Doc/Release/Expansion.html>
- <https://tanglizi.one/post.sh?name=2020-11-04_区块链学习记录_Hyperledger_实践.md>
- <https://wiki.hyperledger.org/display/fabric/>
