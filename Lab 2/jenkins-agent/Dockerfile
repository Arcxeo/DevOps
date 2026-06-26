FROM node:20-bookworm-slim AS node

FROM jenkins/agent:latest-jdk21

USER root

COPY --from=node /usr/local/ /usr/local/

RUN apt-get update \
    && apt-get install -y ca-certificates curl gnupg git openssh-client \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg \
       -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo \
       "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
       $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
       > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y docker-ce-cli docker-buildx-plugin \
    && mkdir -p /tmp/jenkins-agent \
    && chown -R jenkins:jenkins /tmp/jenkins-agent \
    && rm -rf /var/lib/apt/lists/*

USER jenkins

WORKDIR /tmp/jenkins-agent