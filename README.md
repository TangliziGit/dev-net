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

# Write your command in `test.sh`, it provides env parameters.
./test.sh
```

## Reference

- <https://hyperledger-fabric.readthedocs.io/en/release-2.2/>
- <https://github.com/hyperledger/fabric-samples>
- <https://tanglizi.one/post.sh?name=2020-11-04_区块链学习记录_Hyperledger_实践.md>
- <https://wiki.hyperledger.org/display/fabric/>
