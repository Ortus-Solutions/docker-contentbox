# Seed it on a specific CommandBox Image Version
# https://hub.docker.com/r/ortussolutions/commandbox/tags
ARG BASE_IMAGE=ortussolutions/commandbox
FROM ${BASE_IMAGE}

# Labels
LABEL version="@version@"
LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL maintainer "Luis Majano <lmajano@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-contentbox"

# Incoming Secrets/Vars From Build Process
ARG IMAGE_VERSION=6.0.1
ARG TAGS=ortussolutions/contentbox:test
ARG CFENGINE=lucee@5.4.4+38

# Copy over our app resources which brings lots of goodness like session distribution,
# db env vars, caching, etc.
COPY ./resources/app/ ${BUILD_DIR}/contentbox-app

# Copy over ContentBox build scripts
COPY ./build/*.sh ${BUILD_DIR}/contentbox/

# Make them executable just in case.
RUN chmod +x ${BUILD_DIR}/contentbox/*.sh

# Install ContentBox and Dependencies
RUN ${BUILD_DIR}/contentbox/contentbox-setup.sh

# ContentBox Run
CMD ${BUILD_DIR}/contentbox/contentbox-run.sh

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh

# Healthcheck environment variables
ENV HEALTHCHECK_URI "http://127.0.0.1:${PORT}/index.cfm"

# Our healthcheck interval doesn't allow dynamic intervals - Default is 20s intervals with 15 retries
HEALTHCHECK --interval=30s --timeout=30s --retries=2 --start-period=60s CMD curl --fail ${HEALTHCHECK_URI} || exit 1
