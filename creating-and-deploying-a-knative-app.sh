#!/bin/bash

set -e

echo "Creating main.go file..."
cat <<EOF >main.go
package main

import (
    "fmt"
    "net/http"
)

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprint(w, "Hello, World!")
    })

    http.ListenAndServe(":8080", nil)
}
EOF

echo "Building Go binary..."
GOOS=linux go build -o app

echo "Creating Dockerfile..."
cat <<EOF >Dockerfile
FROM alpine
COPY app /
CMD ["/app"]
EOF

echo "Building Docker image..."
docker build -t my-image .

echo "Creating service.yaml file..."
cat <<EOF >service.yaml
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: my-service
spec:
  template:
    spec:
      containers:
        - image: my-image
EOF

echo "Deploying Knative app to the cluster..."
kubectl apply -f service.yaml

echo "Verifying that the Knative app is running..."
kubectl get ksvc
