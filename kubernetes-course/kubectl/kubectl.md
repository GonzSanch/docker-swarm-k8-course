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


