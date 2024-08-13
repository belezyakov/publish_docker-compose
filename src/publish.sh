VERSION="$1"
DOCKER_COMPOSE="$2"
REPO_TOKEN="$3"
REPO_CONNECT="$4"
GITHUB_REPOSITORY=$(echo "$GITHUB_REPOSITORY" | awk '{print tolower($0)}')

echo "VERSION=$VERSION"
echo "DOCKER_COMPOSE=$DOCKER_COMPOSE"

# get repo name
REPO_NAME=$GITHUB_REPOSITORY
REPO_NAME=${REPO_NAME//"$GITHUB_REPOSITORY_OWNER/"/}

if [[ "$REPO_CONNECT" == 'true' ]]; then
    # put gh repo label to dockerfiles
    dockerfiles=$(find . -name Dockerfile*)
    for dockerfile in $dockerfiles
    do
            sed -i '2i\\nLABEL org.opencontainers.image.source=https://github.com/'$GITHUB_REPOSITORY'\n' $dockerfile
    done
fi

# login to github
docker login ghcr.io -u ${GITHUB_REF} -p ${REPO_TOKEN}

# build and run the docker images
docker compose -f $DOCKER_COMPOSE up --no-start

# get all built IDs
IMAGE_IDs=$(docker compose -f $DOCKER_COMPOSE images -q)

echo "IMAGE_IDs: $IMAGE_IDs"

while read -r IMAGE_ID; do

    echo "IMAGE_ID: $IMAGE_ID"
    # get the name label
    IMAGE_NAME=$(docker inspect --format '{{(index (split (index .RepoTags 0) ":") 0)}}' $IMAGE_ID)
    # cutoff repository name
    NAME=${IMAGE_NAME//"${REPO_NAME}-"/}
    echo "NEW_NAME: $NAME"
    echo ${GITHUB_REPOSITORY}
    GH_SHA="ghcr.io/${GITHUB_REPOSITORY}/$NAME:${GITHUB_SHA}"
    LATEST="ghcr.io/${GITHUB_REPOSITORY}/$NAME:latest"

    # tag and push
    docker tag $IMAGE_ID $GH_SHA
    docker tag $IMAGE_ID $LATEST
    docker push $GH_SHA
    docker push $LATEST

    if [[ "$VERSION" != "${GITHUB_SHA}" ]]; then
        VERTAG="ghcr.io/${GITHUB_REPOSITORY}/$NAME:$VERSION"
        docker tag $IMAGE_ID $VERTAG
        docker push $VERTAG
    fi

done <<< "$IMAGE_IDs"