#!/bin/bash

# Create a new project
oc new-project quarkus-knative

# Create a new Quarkus application
mvn quarkus:create -DprojectGroupId=com.mycompany -DprojectArtifactId=myapp -DclassName="com.mycompany.myapp.MyResource" -Dpath="/myapp"

# Build the Quarkus application
cd myapp
mvn package

# Create a new Kubernetes deployment for the Quarkus application
oc create -f deployment.yaml

# Create a new Knative service for the Quarkus application
oc create -f knative-service.yaml

# Deploy the application
oc apply -f deployment.yaml
oc apply -f knative-service.yaml

# Test the application
SERVICE_URL=$(oc get ksvc myapp -o jsonpath='{.status.url}')
echo "Application is running at $SERVICE_URL"

# Monitor the application
oc get pods
oc get ksvc
oc get routes
