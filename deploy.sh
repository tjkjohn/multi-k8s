#! /bin/sh
docker build -t tjkjohn/multi-client:latest -t tjkjohn/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t tjkjohn/multi-server:latest -t tjkjohn/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t tjkjohn/multi-worker:latest -t tjkjohn/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push tjkjohn/multi-client:latest
docker push tjkjohn/multi-server:latest
docker push tjkjohn/multi-worker:latest
docker push tjkjohn/multi-client:$SHA
docker push tjkjohn/multi-server:$SHA
docker push tjkjohn/multi-worker:$SHA

kubectl apply -f k8s

kubectl set image deployments/server-deployment server=tjkjohn/multi-server:$SHA
kubectl set image deployments/client-deployment client=tjkjohn/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=tjkjohn/multi-worker:$SHA