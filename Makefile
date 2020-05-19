CURRENT_DIR = $(shell pwd)
DOCKER_CONTAINER_NAME=jenkins-master
JENKINS_HTTP_PORT=8080
JENKINS_AGENT_PORT=50000
JENKINS_FILE_WAR=$(CURRENT_DIR)/jenkins-war/jenkins-war-$(JENKINS_VERSION).war
JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/$(JENKINS_VERSION)/jenkins-war-$(JENKINS_VERSION).war
JENKINS_MAVEN_METADATA_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/maven-metadata.xml
JENKINS_MAVEN_METADATA_FILE=$(CURRENT_DIR)/maven-metadata.xml

ifeq ($(JENKINS_VERSION),)
# Download the Jenkins Maven Metadata from the internet if it does not exists in the directory '$(CURRENT_DIR)/'
$(info ############################################### )
$(info # )
$(info # Download )
$(info # )
$(info ############################################### )
$(info Download the file $(JENKINS_MAVEN_METADATA_URL):)
$(shell curl -fsSL $(JENKINS_MAVEN_METADATA_URL) -o $(JENKINS_MAVEN_METADATA_FILE))

# Get the last version from the file maven-metadata.xml
JENKINS_VERSION=$(shell cat $(JENKINS_MAVEN_METADATA_FILE) | grep latest | xargs | sed "s/.*<latest>\([^<]*\)<\/latest>.*/\1/")
$(info Last version of Jenkins: $(JENKINS_VERSION))
endif

buildArgs=--build-arg http_port=$(JENKINS_HTTP_PORT) --build-arg agent_port=$(JENKINS_AGENT_PORT) --build-arg JENKINS_VERSION=$(JENKINS_VERSION)
containerName=$(DOCKER_CONTAINER_NAME)
containerPublish=
containerVolumes=
containerImage=$(DOCKER_CONTAINER_NAME):$(JENKINS_VERSION)

$(info ############################################### )
$(info # )
$(info # Environment variables )
$(info # )
$(info ############################################### )
$(info CURRENT_DIR: $(CURRENT_DIR))
$(info DOCKER_CONTAINER_NAME: $(DOCKER_CONTAINER_NAME))
$(info JENKINS_HTTP_PORT: $(JENKINS_HTTP_PORT))
$(info JENKINS_AGENT_PORT: $(JENKINS_AGENT_PORT))
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
