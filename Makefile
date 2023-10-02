#SHELL := /bin/bash

help:
	@echo "Makefile arguments:"
	@echo ""
	@echo "cleanup"
	@echo "nuke"
	@echo "save_as"

start_service:
	docker compose -f docker-compose.minimal.yml build
	docker compose -f docker-compose.minimal.yml up -d
	docker exec test-kuber "minikube start --force"

shell: start_service
	docker exec -it test-kuber /bin/bash

clean:
	docker compose -f docker-compose.minimal.yml down
	docker rm -f test-kuber
	docker rmi -f minikube:latest

dashboard:
	docker exec test-kuber "minikube dashboard"

test:
	docker exec test-kuber \
	"alias kubectl='minikube kubectl --' && \
	kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0 && \
	kubectl expose deployment hello-minikube --type=NodePort --port=8080 && \
	kubectl get services hello-minikube && \
	kubectl port-forward service/hello-minikube 7080:8080" \