#!/bin/bash
set -e
echo "Verifying ability to deploy test service, and ping externally"
# Check if service is already installed, in which case uninstall
if [[ $(minikube kubectl -- describe service -n default hello) ]];then helm uninstall helloworld;fi
helm package helloworld > /dev/null
helm install helloworld helloworld-0.0.2.tgz > /dev/null
sleep 20 #This is a delay built in because it takes a few seconds to spin up
curl "$(minikube ip service/hello):5000" -s | grep "Hello, World!" > /dev/null
echo "Test service successfully deployed and accessible externally"
helm uninstall helloworld
echo "Test service uninstalled"
