sudo rm -rf orgs/*
COMPOSE_PROJECT_NAME="dev-net" IMAGE_TAG="latest" docker-compose -f docker-compose-test-net.yaml down --volumes --remove-orphans
COMPOSE_PROJECT_NAME="dev-net" IMAGE_TAG="latest" docker-compose -f docker-compose-fabric-ca.yaml down --volumes --remove-orphans
 
