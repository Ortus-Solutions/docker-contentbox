FROM ortussolutions/contentbox:latest as workbench

LABEL version="@version@"
LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL maintainer "Luis Majano <lmajano@ortussolutions.com>"
LABEL repository "https://github.com/Ortus-Solutions/docker-contentbox"

# Hard Code our engine environment
ENV CFENGINE lucee@5

# WARM UP THE SERVER
RUN ${BUILD_DIR}/util/warmup-server.sh

# Generate the startup script only
ENV FINALIZE_STARTUP true
RUN $BUILD_DIR/run.sh

# Debian Slim is the smallest OpenJDK image on that kernel. For most apps, this should work to run your applications
FROM adoptopenjdk/openjdk8:debianslim-jre as app

# COPY our generated files
COPY --from=workbench /app /app
COPY --from=workbench /usr/local/lib/serverHome /usr/local/lib/serverHome
RUN mkdir -p /usr/local/lib/CommandBox/lib
# We have to copy this file over because otherwise an error on the tray options is thrown - will be unnecessary when v5.0.1 is released
COPY --from=workbench /usr/local/lib/build/resources /usr/local/lib/build/resources
COPY --from=workbench /usr/local/lib/CommandBox/server /usr/local/lib/CommandBox/server
COPY --from=workbench /usr/local/lib/CommandBox/lib/runwar-4.0.5.jar /usr/local/lib/CommandBox/lib/runwar-4.0.5.jar
COPY --from=workbench /usr/local/bin/startup-final.sh /usr/local/bin/run.sh

CMD /usr/local/bin/run.sh