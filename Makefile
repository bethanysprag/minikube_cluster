#SHELL := /bin/bash
include .env

help:
	@echo "Makefile arguments:"
	@echo ""
	@echo "start -- start minikube server"
	@echo "stop -- shutdown minikube server properly"
	@echo "shell -- interactive shell for minikube server"
	@echo "clean -- remove minikube container and image from machine"
	@echo "pods -- get list of pods"
	@echo "dashboard -- get dashboard link"
	@echo "verify -- verify proper functioning of minikube by deploying a test service then removing it"

start:
# Start minikube
	docker compose -f docker-compose.minimal.yml build
	docker compose -f docker-compose.minimal.yml up -d
	docker exec $(CONTAINER_NAME) /bin/sh -c 'minikube delete'
	docker exec $(CONTAINER_NAME) /bin/sh -c "minikube start --force"

shell:
# Interactive shell on minikube server
	docker exec -it $(CONTAINER_NAME) /bin/bash

stop:
# Proper way to shut down minikube
	docker exec $(CONTAINER_NAME) /bin/sh -c "minikube delete"
	docker stop $(CONTAINER_NAME)

clean:
# Completely clean container and image off your machine
	docker compose -f docker-compose.minimal.yml down
	docker rm -f $(CONTAINER_NAME)
	docker rmi -f minikube:latest

pods:
# Get list of pods
	docker exec $(CONTAINER_NAME) /bin/sh -c "minikube kubectl -- get pods -A"

dashboard:
# Get minikube dashboard link
	docker exec -d $(CONTAINER_NAME) /bin/sh -c "minikube dashboard"

verify:
# Package and deploy a test service using helm and verifying external ip access
	@docker exec -w /work/test $(CONTAINER_NAME) /bin/sh -c " \
	./test_script.sh \
	"
