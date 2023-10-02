#SHELL := /bin/bash

help:
	@echo "Makefile arguments:"
	@echo ""
	@echo "cleanup"
	@echo "nuke"
	@echo "save_as"

start:
	docker compose -f docker-compose.minimal.yml build
	docker compose -f docker-compose.minimal.yml up -d
	docker exec test-kuber /bin/sh -c 'minikube delete'
	docker exec test-kuber /bin/sh -c "minikube start --force"

shell:
	docker exec -it test-kuber /bin/bash

stop:
	docker exec test-kuber /bin/sh -c "minikube delete"
	docker stop test-kuber

clean:
	docker compose -f docker-compose.minimal.yml down
	docker rm -f test-kuber
	docker rmi -f minikube:latest

pods:
	docker exec test-kuber /bin/sh -c "minikube kubectl -- get pods -A"

dashboard:
	docker exec test-kuber /bin/sh -c "minikube dashboard"

test:
	docker exec test-kuber /bin/sh -c " \
	minikube kubectl -- create deployment hello-minikube --image=kicbase/echo-server:1.0 && \
	minikube kubectl -- expose deployment hello-minikube --type=NodePort --port=8080 && \
	minikube kubectl -- get services hello-minikube && \
	minikube kubectl -- port-forward service/hello-minikube 7080:8080" 