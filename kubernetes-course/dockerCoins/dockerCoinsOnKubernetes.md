# Running DockerCoins on Kubernetes


```shell
# Deploy redis container
kubectl create deployment redis --image=redis

# Deploy everything else
kubectl create deployment hasher --image=dockercoins/hasher:v0.1
kubectl create deployment rng --image=dockercoins/rng:v0.1
kubectl create deployment webui --image=dockercoins/webui:v0.1
kubectl create deployment worker --image=dockercoins/worker:v0.1

# Connect containers between each other with services
kubectl expose deployment redis --port 6379
kubectl expose deployment rng --port 80
kubectl expose deployment hasher --port 80

# Exposing webui service for external access
kubectl expose deployment webui --type=NodePort --port 80
# If you are using minikube NodePort expose needs to be managed by minikube
minikube service webui --url

# Scaling DockerCoins deployments
kubectl scale deployment worker --replicas=2
kubectl scale deployment worker --replicas=3
# bottleNeck detected in application when scale up to 10
kubectl scale deployment worker --replicas=10

# Solve stuck 10 hashes per second
# Obtain ClusterIP address and save in env variable
HASHER=$(kubectl get svc hasher -o go-template={{.spec.clusterIP}})
RNG=$(kubectl get svc rng -o go-template={{.spec.clusterIP}})
# then user shpod to test http comunications
kubectl apply -f https://k8smastery.com/shpod.yaml
kubectl attach --namespace=shpod -ti shpod
# run inside shpod
httping -c 3 $HASHER
httping -c 3 $RNG
# Notice that rng has a huge time to response almost 1s, this problem of scaling services will introduce DaemonSets type
```
