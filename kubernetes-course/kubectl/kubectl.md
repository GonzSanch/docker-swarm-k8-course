### Kubectl get

- Get cluster nodes

```shell
kubectl get no
kubectl get node
kubectl get nodes
```

- Get changing ouput as JSON, YAML, verbose..

```shell
kubectl get no -o wide
kubectl get no -o yaml
```

- Get specific information using jq or grep

```shell
kubectl get no -o json | jq ".items[] | {name:.metadata.name} + .status.capacity"`
```

### kubectl describe

- Describe nodes

```shell
  kubectl describe node/<node>
  kubectl describe node <node>
```

### kubectl exploring types and resources

- List all available resources types

```shell
kubectl api-resources
```

- View definition for a resource type

```shell
kubectl explain types
```

- view definition of a field in resource

```shell
kubectl explain node.specific
```

- List all fields and subfields

```shell
kubectl explain node --recursive
```

Types names have three forms: singular (node, service, deployment), plural (nodes, services, deployments) and short (no, svc, deploy), but some types do not have short forms or are only in plural form.

### kubectl GET command

- List services

```shell
kubectl get services
kubectl get svc
```

- List pods

```shell
kubectl get pods
```

### kubectl namespaces

- List namespaces

```shell
kubectl get namespaces
kubectl get namespace
kubectl get ns
```

- List resources in all namespaces

```shell
kubectl get pods --all-namespaces
kubectl get pods -A
```

- List only resources in specific namespace

```shell
kubectl get pods --namespace=kube-system
kubectl get pods -n kube-system
```

- Kube-public

```shell
kubectl get pods -n kube-public
kubectl get configmaps -n kube-public
kubectl -n kube-public get configmap cluster-info -o yaml
```

- kube-node-lease is a namespace that contains a kind of heartbeat to ensure all it's working properly

### Kubernetes deployment

- kubectl run creates a pod in 1.18^

```shell
kubectl run pingpong --image alpine ping 1.1.1.1
```

- kubectl create deployment

```shell
kubectl create deployment pingpong --image alpine -- ping 1.1.1.1
```

- kubectl check logs in deployments

```shell
kubectl logs deploy/pingpong
kubectl logs deploy/pingpong --tail 1 --follow
```

- Scaling replicas in deployment

```shell
kubectl scale deploy/pingpong --replicas 3
kubectl scale deployment pingpong --replicas 3
```

- Delete pods

```shell
kubectl delete pod/<resource>
```

### Cron jobs and reource creation

- Create cronjob

```shell
kubectl create cronjob sleep --image=alpine --schedule="*/3 * * * *" --restart=OnFailure -- sleep 10
```

- Create resources with files

```shell
kubectl create -f foo.yaml
kubectl apply -f foo.yaml
```

- Streaming logs of multiple pods

```shell
kubectl logs -l app=pingpong --tail 1 -f
```

### Kubernetes services and visualizing deployments

- Create service using expose

```shell
kubectl create deployment httpenv --image=bretfisher/httpenv
kubectl scale deployment httpenv --replicas=10
kubectl expose deployment httpenv --port=8888
```

### Testing and visualize service traffic

- Testing expose ClusterIP with shpod inside cluster

```shell
# Create shpod
kubectl apply -f https://bret.run/shpod.yml
# Attach a shell inside shpod pod
kubectl attach --namespace=shpod -ti shpod
# Inside shpod run:
IP=$(kubectl get svc httpenv -o go-template --template '{{ .spec.clusterIP }}')
curl http://$IP:8888/
curl -s http://$IP:8888/ | jq .HOSTNAME
kubectl delete -f https://bret.run/shpod.yml
```

### Deploy with yaml files

```shell
# Apply use a .yaml to create/update resources
kubectl apply -f https://k8smastery.com/dockercoins.yaml
# Delete resources using yaml
kubectl delete -f https://k8smastery.com/dockercoins.yaml
```

### K8s dashboard

For dev purpose only use insecure-dashboard or if you are using minikube just run:

```shell
minikube dashboard
```

### DaemonSets and label basics

DaemonSets are resource that use the same image and deploy it in every nodes.

Selectors find the resource that match with the setted label.

```shell
#Get the list of pods matching selector app=rng
kubectl get pods -l app=rng
kubectl get pods --selector app=rng
```

When you create resources with kubectl create by convenience create app label.

### Resources Selectors

Resource as Deployment or DaemonSets are expecting to the number of pods is the correct. So If we delete one pod or change its label, a new pod that match requirements for deployment or DaemonSets will be created.

```shell
#Add a new label to all pods that have app=rng label match
kubectl label pods -l app=rng enabled=yes
#Edit service selector
kubectl edit service rng
#Remove label
kubectl label pods -l app=rng enabled-
#In order to deployment or daemonSets add the new label into new pods you have to edit it's manifest and add the desired label
kubectl edit deployment rng
```

### Generating YAML without creating resources

```shell
#Generate the YAML for a deployment without creating it:
kubectl create deployment web --image nginx -o yaml --dry-run
#Generate the YAML for a Namespace without craeting it:
kubectl create namespace awesome-app -o yaml --dry-run
```

### api-resources

```shell
#List all resources type that we can create
kubectl api-resources
#List all version api available
kubectl api-versions
```

### YAML config diff

```shell
#You can use diff to check changes on yaml
kubectl diff -f file.yaml
```

### Rolling updates

During a rolling updates are progressively for example if a deployment is updated all replicas/pods will be updated.

Updates will follow a strategy to persist availability of resources. Specifying maxSurge and maxUnavailable.

Rolling updates is only available in Deployments, StatefullSet and DaemonSets

```shell
#To get update strategy of all deployments you can launch
kubectl get deploy -o json | jq ".items[] | {name:.metadata.name} + .spec.strategy.rollingUpdate"
#Update image on deploy
kubectl set image deploy worker worker=dockercoins/worker:v0.2
#Check roll update status
kubectl rollout status deploy worker
#Undo roll update
kubectl rollout undo deploy worker
kubectl rollout status deploy worker
```

### Rollout history and patching

```shell
#List rollout history
kubectl rollout history deployment worker
#Check revisions
kubectl describe replicasets -l app=worker | grep -A3 Annotations
#Then go back to first revision with undo
kubectl rollout undo deployment worker --to-revision=1
#Other way to change/update deployments is patch using a YAML file
kubectl patch -f file.yaml
```

### Health checks

In order to verify if a container in a pod is healthy and ready to serve traffic, Kubernetes provides for a range of health checking mechanisms that are call healt checks or probes. Defined as YAML level

### Creates a config map

ConfigMaps allow us to get a configuration file and stored it as a key/value. We also later can attach this configuration to a pod as a file with a volume.

```shell
# Create a ConfigMap with a single key, "app.conf"
kubectl create configmap my-app-config --from-file=app.conf
# Create a ConfigMap with a single key, "app.conf" but another file
kubectl create configmap my-app-config --from-file=app.conf=app-prod.conf
# Create a ConfigMap with multiple keys (one per file in the config.d directory)
kubectl create configmap my-app-config --from-file=config.d/
# Create a ConfigMap with two keys
kubectl create cm my-app-config --from-literal=foreground=red --from-literal=background=blue
# Create a ConfigMap from a file containing key=val pairs
kubectl create cm my-app-config --from-env-file=app.conf
```

### Creating and using ConfigMaps and Secrets

Using a haproxy image that expect a configuration file. We will launch and create this HaProxy pod and create and bind his configuration using a ConfigMap.

```shell
# Download our simple HAProxy config:
curl -O https://k8smastery.com/haproxy.cfg
# Create a ConfigMap name haproxy and holding the configuration file:
kubectl create configmap haproxy --from-file=haproxy.cfg
# Check what our ConfigMap looks like:
kubectl get configmap haproxy -o yaml
# Download haproxy yaml
curl -O https://k8smastery.com/haproxy.yaml
# Apply yaml file into our cluster
kubectl apply -f haproxy.yaml
# Use shpod to check that haproxy is working properly with the configmap.
kubectl attach --namespace=shpod -ti shpod
# Once inside shpod run the following commands:
IP=$(kubectl get pod haproxy -o json | jq -r .status.podIP)
echo $IP
# Then make a curl to our loadbalancer haproxy
curl $IP
# First request will redirect into google.com
curl $IP
# And second one will redirect to ibm.com
```

In the next example we will mix downward API and configmap to configure a docker registry env variable with a ConfigMap.

```shell
# ConfigMap will have a single key, http.addr
kubectl create configmap registry --from-literal=http.addr=0.0.0.0:80
# Check ConfigMap
kubectl get configmap registry -o wide
# Donwload the registry yaml
curl -O https://k8smastery.com/registry.yaml
# Apply yaml file into our cluster
kubectl apply -f registry.yaml
# check the IP address allocated to the pod
kubectl attatch --namespace -ti shpod
kubectl get pod registry -o wide
IP=$(kubectl get pod registry -o json | jq -r .status.podIP)
# Confirm that the registry is available on port 80
curl $IP/v2/_catalog
```

To avoid manage 'secret' data in ConfigMaps we will use secrets, that applies the same functionality but are more secure using a base64 encrypt. They are uses the same way as ConfigMaps substuting kind resource configmap to secret will work all the way.
