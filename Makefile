CURRENT_DIR = $(shell pwd)
DOCKER_CONTAINER_NAME=jenkins-master
DOCKER_CONTAINER_VOLUME_PATH=/c/docker/volume-persistent/docker-jenkins-master
JENKINS_HTTP_PORT=8080
JENKINS_AGENT_PORT=50000
JENKINS_HOME=/var/jenkins_home
JENKINS_VERSION=2.233
JENKINS_FILE_WAR=$(CURRENT_DIR)/jenkins-war/jenkins-war-$(JENKINS_VERSION).war
JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/$(JENKINS_VERSION)/jenkins-war-$(JENKINS_VERSION).war

buildArgs=--build-arg http_port=$(JENKINS_HTTP_PORT) --build-arg agent_port=$(JENKINS_AGENT_PORT) --build-arg JENKINS_VERSION=$(JENKINS_VERSION)
containerName=$(DOCKER_CONTAINER_NAME)
containerPublish=--publish $(JENKINS_HTTP_PORT):$(JENKINS_HTTP_PORT) --publish $(JENKINS_AGENT_PORT):$(JENKINS_AGENT_PORT)
containerVolumes=--volume $(DOCKER_CONTAINER_VOLUME_PATH)/jenkins_home:/var/jenkins_home
containerImage=$(DOCKER_CONTAINER_NAME):$(JENKINS_VERSION)

$(info ############################################### )
$(info # )
$(info # Environment variables )
$(info # )
$(info ############################################### )
$(info CURRENT_DIR: $(CURRENT_DIR))
$(info DOCKER_CONTAINER_NAME: $(DOCKER_CONTAINER_NAME))
$(info DOCKER_CONTAINER_VOLUME_PATH: $(DOCKER_CONTAINER_VOLUME_PATH))
$(info JENKINS_HTTP_PORT: $(JENKINS_HTTP_PORT))
$(info JENKINS_AGENT_PORT: $(JENKINS_AGENT_PORT))
$(info JENKINS_HOME: $(JENKINS_HOME))
$(info JENKINS_VERSION: $(JENKINS_VERSION))
$(info JENKINS_FILE_WAR: $(JENKINS_FILE_WAR))
$(info JENKINS_URL: $(JENKINS_URL))
$(info )
$(info ############################################### )
$(info # )
$(info # Parameters )
$(info # )
$(info ############################################### )
$(info buildArgs: $(buildArgs))
$(info containerName: $(containerName))
$(info containerPublish: $(containerPublish))
$(info containerVolumes: $(containerVolumes))
$(info containerImage: $(containerImage))
$(info )

# Download the Jenkins war from the internet if it does not exists in the directory '$(CURRENT_DIR)/jenkins-war/'
ifeq (,$(wildcard $(JENKINS_FILE_WAR)))
$(info ############################################### )
$(info # )
$(info # Download )
$(info # )
$(info ############################################### )
$(info Download the file $(JENKINS_URL):)
$(shell curl -fsSL $(JENKINS_URL) -o $(JENKINS_FILE_WAR))
endif

include $(CURRENT_DIR)/make-commons-docker.mk
