FROM ortussolutions/commandbox:4.2.0

# Labels
LABEL version="@version@"
LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL maintainer "Luis Majano <lmajano@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-contentbox"

# Copy over our app resources and build scripts
COPY ./resources/app/ ${BUILD_DIR}/contentbox-app
COPY ./build/contentbox-dependencies.sh ${BUILD_DIR}/
COPY ./build/contentbox-setup.sh ${BUILD_DIR}/
COPY ./build/contentbox-cleanup.sh ${BUILD_DIR}/
COPY ./build/apt-cleanup.sh ${BUILD_DIR}/

# Make them executable just in case.
RUN chmod +x ${BUILD_DIR}/contentbox-dependencies.sh
RUN chmod +x ${BUILD_DIR}/contentbox-setup.sh

# debug
#RUN ls -la ${BUILD_DIR}

# Install ContentBox deps
RUN ${BUILD_DIR}/contentbox-dependencies.sh

# Run The build
CMD ${BUILD_DIR}/contentbox-setup.sh

# Cleanup
RUN ${BUILD_DIR}/contentbox-cleanup.sh

# Healthcheck environment variables
ENV HEALTHCHECK_URI "http://127.0.0.1:${PORT}/index.cfm"

# Our healthcheck interval doesn't allow dynamic intervals - Default is 20s intervals with 15 retries
HEALTHCHECK --interval=20s --timeout=30s --retries=15 CMD curl --fail ${HEALTHCHECK_URI} || exit 1

# Apt Cleanup
#RUN ${BUILD_DIR}/apt-cleanup.sh

# Warmup the Server
RUN ${BUILD_DIR}/util/warmup-server.sh