# Jenkins LTS with the setup wizard disabled, plugins pre-installed, docker CLI + kubectl added.
FROM jenkins/jenkins:lts-jdk17
USER root
COPY --from=docker:29-cli /usr/local/bin/docker /usr/local/bin/docker
COPY --from=docker:29-cli /usr/local/libexec/docker/cli-plugins/docker-buildx /usr/local/libexec/docker/cli-plugins/docker-buildx
RUN curl -fsSLo /usr/local/bin/kubectl "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
 && chmod +x /usr/local/bin/kubectl
USER jenkins
RUN jenkins-plugin-cli --plugins workflow-aggregator git pipeline-stage-view pipeline-graph-view
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/
COPY jobs/ /usr/share/jenkins/ref/jobs/
