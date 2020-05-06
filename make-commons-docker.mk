#
# You need to define
#   buildArgs
#   containerName
#   containerPublish
#   containerVolumes
#   containerImage
DOCKER_CONTAINER_ID=$(shell docker ps -aqf "name=$(containerName)")

default:

build:
	$(info ############################################### )
	$(info # )
	$(info # Build the image Docker $(containerImage) )
	$(info # )
	$(info ############################################### )
	docker build $(buildArgs) --tag $(containerImage) .
	
ifeq ($(DOCKER_CONTAINER_ID),)
exec:
	$(info ############################################### )
	$(info # )
	$(info # Run a command inside the running Container Docker $(containerName) )
	$(info # )
	$(info ############################################### )
	$(error The Container Docker $(containerName) does not exists !)
else
exec:
	$(info ############################################### )
	$(info # )
	$(info # Run a command inside the running Container Docker $(containerName) )
	$(info # )
	$(info ############################################### )
	docker exec -it $(DOCKER_CONTAINER_ID) bash
endif
	
###############################################
#
# Kill the container Docker
#
###############################################
ifeq ($(DOCKER_CONTAINER_ID),)
kill:
	$(info ############################################### )
	$(info # )
	$(info # Kill the container Docker $(containerName) )
	$(info # )
	$(info ############################################### )
	$(error The Container Docker $(containerName) does not exists !)
else
kill:
	$(info ############################################### )
	$(info # )
	$(info # Kill the container Docker $(containerName) )
	$(info # )
	$(info ############################################### )
	docker kill $(DOCKER_CONTAINER_ID)
endif

###############################################
#
# Get logs the container Docker
#
###############################################
ifeq ($(DOCKER_CONTAINER_ID),)
logs:
	$(info ############################################### )
	$(info # )
	$(info # Get the logs of the container Docker $(containerName) )
	$(info # )
	$(info ############################################### )
	$(error The Container Docker $(containerName) does not exists !)
else
logs:
	$(info ############################################### )
	$(info # )
	$(info # Get the logs of the container Docker $(containerName) )
	$(info # )
	$(info ############################################### )
	docker logs $(DOCKER_CONTAINER_ID)
endif

###############################################
#
# Stop the container Docker
#
###############################################
ifeq ($(DOCKER_CONTAINER_ID),)
stop:
	$(info ############################################### )
	$(info # )
	$(info # Stop the container Docker $(containerName) )
	$(info # )
	$(info ############################################### )
	$(error The Container Docker $(containerName) does not exists !)
else
stop:
	$(info ############################################### )
	$(info # )
	$(info # Stop the container Docker $(containerName) )
	$(info # )
	$(info ############################################### )
	docker stop $(DOCKER_CONTAINER_ID)
endif

###############################################
#
# Remove the container Docker
#
###############################################
ifeq ($(DOCKER_CONTAINER_ID),)
rm:
	$(info ############################################### )
	$(info # )
	$(info # Remove the container Docker $(containerName) )
	$(info # )
	$(info ############################################### )
	$(error The Container Docker $(containerName) does not exists !)
else
rm:
	$(info ############################################### )
	$(info # )
	$(info # Stop the container Docker $(containerName) )
	$(info # )
	$(info ############################################### )
	docker stop $(DOCKER_CONTAINER_ID)
	$(info ############################################### )
	$(info # )
	$(info # Remove the container Docker $(containerName) )
	$(info # )
	$(info ############################################### )
	docker rm --force $(DOCKER_CONTAINER_ID)
endif

###############################################
#
# Run the container Docker
#
###############################################
ifeq ($(DOCKER_CONTAINER_ID),)
run:
	$(info ############################################### )
	$(info # )
	$(info # Run the container Docker $(containerName) )
	$(info # )
	$(info ############################################### )
	docker run --detach --name $(containerName) $(containerPublish) $(containerVolumes) $(containerImage)
else
run:
	$(info ############################################### )
	$(info # )
	$(info # Run the container Docker $(containerName) )
	$(info # )
	$(info ############################################### )
	$(error The Container Docker $(containerName) does already exists: $(DOCKER_CONTAINER_ID))
endif

###############################################
#
# Status of the container Docker
#
###############################################
ifeq ($(DOCKER_CONTAINER_ID),)
status:
	$(info The container Docker $(containerName) does not exist:)
else
status:
	$(info Container ID $(containerName): $(DOCKER_CONTAINER_ID))
endif