#!/bin/sh
# Linux
curl -L https://github.com/kubernetes/kompose/releases/download/v1.31.0/kompose-linux-amd64 -o kompose
chmod +x kompose
mv ./kompose /usr/local/bin/kompose