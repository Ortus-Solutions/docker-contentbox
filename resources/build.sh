#!/bin/bash
set -ex

cd $TRAVIS_BUILD_DIR

echo "CWD: $PWD"
echo "Dockerfile: ${TRAVIS_BUILD_DIR}/${BUILD_IMAGE_DOCKERFILE}"

# Push Version into Images: $IMAGE_VERSION IS SET IN TRAVIS
sed -i -e "s/@version@/$IMAGE_VERSION/g" $TRAVIS_BUILD_DIR/${BUILD_IMAGE_DOCKERFILE}

# Build Base Image
docker build --no-cache \
    -t ${TRAVIS_COMMIT}:${TRAVIS_JOB_ID} \
    --build-arg CI_BUILD_NUMBER="${TRAVIS_BUILD_NUMBER}" \
    --build-arg CI_BUILD_URL="${TRAVIS_BUILD_WEB_URL}" \
    -f $TRAVIS_BUILD_DIR/${BUILD_IMAGE_DOCKERFILE} $TRAVIS_BUILD_DIR/
echo "INFO: Docker image successfully built"

# Log in to Docker Hub
docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}
echo "INFO: Successfully logged in to Docker Hub!"

# Do Appropriate Tagging
if [[ $TRAVIS_BRANCH == 'master' ]]; then

    if [[ $BUILD_IMAGE_TAG == 'ortussolutions/contentbox' ]]; then
        # Tag with `latest` as well and push it
        docker tag ${TRAVIS_COMMIT}:${TRAVIS_JOB_ID} ${BUILD_IMAGE_TAG}:latest
        docker push ${BUILD_IMAGE_TAG}:latest
        BUILD_IMAGE_TAG="${BUILD_IMAGE_TAG}:${CONTENTBOX_VERSION}"
    else
        # Tag with -version
        BUILD_IMAGE_TAG="${BUILD_IMAGE_TAG}-${CONTENTBOX_VERSION}"
    fi

elif [[ $TRAVIS_BRANCH == 'development' ]]; then
    
    if [[ $BUILD_IMAGE_TAG == 'ortussolutions/contentbox' ]]; then
        # Tag with :snapshot
        BUILD_IMAGE_TAG="${BUILD_IMAGE_TAG}:snapshot"
    else
        # Tag with -snapshot
        BUILD_IMAGE_TAG="${BUILD_IMAGE_TAG}-snapshot"
    fi

fi

# Tag it in docker
docker tag ${TRAVIS_COMMIT}:${TRAVIS_JOB_ID} ${BUILD_IMAGE_TAG}
# Push our new image and tags to the registry
docker push ${BUILD_IMAGE_TAG}

echo "Voila! ContentBox Dockerized!"