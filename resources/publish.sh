#!/bin/bash
set -e

cd $TRAVIS_BUILD_DIR

echo "CWD: $PWD"
echo "Dockerfile: $TRAVIS_BUILD_DIR/${BUILD_IMAGE_DOCKERFILE}"

# Push Version into Images: $IMAGE_VERSION IS SET IN TRAVIS
sed -i -e "s/@version@/$IMAGE_VERSION/g" $TRAVIS_BUILD_DIR/${BUILD_IMAGE_DOCKERFILE}

# Build Base Image
docker build --no-cache -t ${TRAVIS_COMMIT}:${TRAVIS_JOB_ID} -f $TRAVIS_BUILD_DIR/${BUILD_IMAGE_DOCKERFILE} $TRAVIS_BUILD_DIR/
echo "INFO: Docker image successfully built"

# Log in to Docker Hub
docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD
echo "INFO: Successfully logged in to Docker Hub!"

if [[ $BUILD_IMAGE_TAG == 'ortussolutions/contentbox' && $TRAVIS_BRANCH == 'master' ]]; then
	docker tag ${TRAVIS_COMMIT}:${TRAVIS_JOB_ID} ${BUILD_IMAGE_TAG}:${CONTENTBOX_VERSION}
    docker tag ${TRAVIS_COMMIT}:${TRAVIS_JOB_ID} ${BUILD_IMAGE_TAG}:latest
elif [[ $BUILD_IMAGE_TAG == 'ortussolutions/contentbox' && $TRAVIS_BRANCH == 'development' ]]; then
	BUILD_IMAGE_TAG="${BUILD_IMAGE_TAG}:snapshot"
elif [[ $TRAVIS_BRANCH == 'development' ]]; then
	BUILD_IMAGE_TAG="${BUILD_IMAGE_TAG}-snapshot"
fi

docker tag ${TRAVIS_COMMIT}:${TRAVIS_JOB_ID} ${BUILD_IMAGE_TAG}

# Push our new image and tags to the registry
echo "INFO: Pushing new image to registry ${BUILD_IMAGE_TAG}"
docker push ${BUILD_IMAGE_TAG}


if [[ $BUILD_IMAGE_TAG == 'ortussolutions/contentbox' && $TRAVIS_BRANCH == 'master' ]]; then
    docker push ${BUILD_IMAGE_TAG}:latest
    docker push ${BUILD_IMAGE_TAG}:${CONTENTBOX_VERSION}
fi

echo "INFO: Image ${BUILD_IMAGE_TAG} successfully published"