#!/bin/bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 522569276716.dkr.ecr.us-east-1.amazonaws.com || { echo "ECR login failed"; exit 1; }
for service in web proxy barista kitchen counter product; do
  echo "Processing $service..."
  docker pull cuongopswat/go-coffeeshop-$service || { echo "Pull failed for $service"; exit 1; }
  docker tag cuongopswat/go-coffeeshop-$service:latest 522569276716.dkr.ecr.us-east-1.amazonaws.com/coffeeshop-$service:latest || { echo "Tag failed for $service"; exit 1; }
  docker push 522569276716.dkr.ecr.us-east-1.amazonaws.com/coffeeshop-$service:latest || { echo "Push failed for $service"; exit 1; }
done
