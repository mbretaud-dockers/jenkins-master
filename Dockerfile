FROM openjdk:8u121-jdk-alpine

RUN apk add --no-cache git openssh-client curl unzip bash ttf-dejavu coreutils

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG http_port=8080
ARG agent_port=50000
ARG JENKINS_VERSION
ARG REF=/usr/share/jenkins/ref

ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}
ENV JENKINS_UC https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals
ENV JENKINS_VERSION ${JENKINS_VERSION:-2.60.3}
ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log
ENV REF $REF

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container, 
# ensure you use the same uid
RUN addgroup -g ${gid} ${group} \
    && adduser -h "$JENKINS_HOME" -u ${uid} -G ${group} -s /bin/bash -D ${user}

# Jenkins home directory is a volume, so configuration and build history 
# can be persisted and survive image upgrades
VOLUME /var/jenkins_home

# File jenkins.war
# Can be downloaded from the URL : https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war (ex: JENKINS_VERSION=2.60.3)
COPY jenkins-war/jenkins-war-${JENKINS_VERSION}.war /usr/share/jenkins/jenkins.war

# `/usr/share/jenkins/ref/` contains all reference configuration we want 
# to set on a fresh new installation. Use it to bundle additional plugins 
# or config file with your custom jenkins Docker image.
RUN mkdir -p ${REF}/init.groovy.d

# Script Tini
# Can be downloaded from the URL : https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 (ex: TINI_VERSION=0.14.0)
COPY tini/tini-static-amd64-v0.19.0 /sbin/tini
COPY tini/tini-static-amd64-v0.19.0.asc /sbin/tini.asc
RUN chmod +x /sbin/tini
COPY init.groovy.d/tcp-slave-agent-port.groovy ${REF}/init.groovy.d/tcp-slave-agent-port.groovy

# User
RUN chown -R ${user} "$JENKINS_HOME" "$REF"

# for main web interface:
EXPOSE ${http_port}

# will be used by attached slave agents:
EXPOSE ${agent_port}

USER ${user}

# Copy scripts
COPY scripts-shell/jenkins-support /usr/local/bin/jenkins-support
COPY scripts-shell/jenkins.sh /usr/local/bin/jenkins.sh
COPY scripts-shell/tini-shim.sh /bin/tini

# Entrypoint
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]

# Copy plugin scripts
COPY scripts-shell/plugins.sh /usr/local/bin/plugins.sh
COPY scripts-shell/install-plugins.sh /usr/local/bin/install-plugins.sh

# Copy plugins list
COPY plugins/plugins.txt /plugins.txt

# Install plugins
RUN /usr/local/bin/install-plugins.sh < /plugins.txt
#RUN JENKINS_UC_DOWNLOAD=http://archives.jenkins-ci.org /usr/local/bin/install-plugins.sh < /plugins.txt
