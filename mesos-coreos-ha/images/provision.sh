#!/bin/bash

# Load containers to make them available and up to date inside the instance.
echo "Loading docker containers"
for container in *.tar; do
	docker load -i $container
done
