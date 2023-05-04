# Домашнее задание к занятию «Запуск приложений в K8S»

------

### Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod

1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.
2. После запуска увеличить количество реплик работающего приложения до 2.
3. Продемонстрировать количество подов до и после масштабирования.
4. Создать Service, который обеспечит доступ до реплик приложений из п.1.
5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.

### Ответ

```
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml$ kubectl get svc -o wide
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE    SELECTOR
kubernetes   ClusterIP   10.152.183.1   <none>        443/TCP   113m   <none>
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml$ kubectl get pods -o wide
No resources found in default namespace.
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml$ ls
deployment.yaml  service.yaml
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml$ nano deployment.yaml 
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml$ kubectl apply -f deployment.yaml
deployment.apps/nginx-multitool created
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml$ kubectl get pods -o wide
NAME                               READY   STATUS              RESTARTS   AGE   IP       NODE                   NOMINATED NODE   READINESS GATES
nginx-multitool-7956d896d7-lxn7z   0/2     ContainerCreating   0          6s    <none>   mentukov-minipc-pn50   <none>           <none>
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml$ kubectl get pods -o wide
NAME                               READY   STATUS    RESTARTS   AGE   IP           NODE                   NOMINATED NODE   READINESS GATES
nginx-multitool-7956d896d7-lxn7z   2/2     Running   0          20s   10.1.8.206   mentukov-minipc-pn50   <none>           <none>
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml$ kubectl scale deployment nginx-multitool --replicas=2
deployment.apps/nginx-multitool scaled
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml$ kubectl get pods -o wide
NAME                               READY   STATUS              RESTARTS   AGE   IP           NODE                   NOMINATED NODE   READINESS GATES
nginx-multitool-7956d896d7-lxn7z   2/2     Running             0          48s   10.1.8.206   mentukov-minipc-pn50   <none>           <none>
nginx-multitool-7956d896d7-k7g7m   0/2     ContainerCreating   0          3s    <none>       mentukov-minipc-pn50   <none>           <none>
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml$ kubectl get pods -o wide
NAME                               READY   STATUS    RESTARTS   AGE   IP           NODE                   NOMINATED NODE   READINESS GATES
nginx-multitool-7956d896d7-lxn7z   2/2     Running   0          53s   10.1.8.206   mentukov-minipc-pn50   <none>           <none>
nginx-multitool-7956d896d7-k7g7m   2/2     Running   0          8s    10.1.8.207   mentukov-minipc-pn50   <none>           <none>

mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml$ nano service.yaml 
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml$ kubectl apply -f service.yaml 
service/nginx-multitool-service created
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml$ nano pod.yaml
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml$ kubectl apply -f pod.yaml 
pod/multitool-pod created
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml$ kubectl get pods -o wide
NAME                               READY   STATUS    RESTARTS   AGE     IP           NODE                   NOMINATED NODE   READINESS GATES
nginx-multitool-7956d896d7-lxn7z   2/2     Running   0          3m15s   10.1.8.206   mentukov-minipc-pn50   <none>           <none>
nginx-multitool-7956d896d7-k7g7m   2/2     Running   0          2m30s   10.1.8.207   mentukov-minipc-pn50   <none>           <none>
multitool-pod                      1/1     Running   0          11s     10.1.8.208   mentukov-minipc-pn50   <none>           <none>

mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml$ kubectl exec multitool-pod -- curl 10.1.8.206
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   615  100   615    0     0   717k      0 --:--:-- --:--:-- --:--:--  600k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

```

------

### Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.
2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.
3. Создать и запустить Service. Убедиться, что Init запустился.
4. Продемонстрировать состояние пода до и после запуска сервиса.

### Ответ

```
До старта init сервиса

mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml2$ kubectl apply -f deployment.yaml 
deployment.apps/nginx-deployment created
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml2$ kubectl get pods -o wide
NAME                               READY   STATUS     RESTARTS   AGE   IP           NODE                   NOMINATED NODE   READINESS GATES
nginx-multitool-7956d896d7-lxn7z   2/2     Running    0          80m   10.1.8.206   mentukov-minipc-pn50   <none>           <none>
nginx-multitool-7956d896d7-k7g7m   2/2     Running    0          79m   10.1.8.207   mentukov-minipc-pn50   <none>           <none>
multitool-pod                      1/1     Running    0          77m   10.1.8.208   mentukov-minipc-pn50   <none>           <none>
nginx-deployment-f9c79c578-r4dhv   0/1     Init:0/1   0          13s   10.1.8.209   mentukov-minipc-pn50   <none>           <none>
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml2$ kubectl describe pod nginx-deployment-f9c79c578-r4dhv
Name:             nginx-deployment-f9c79c578-r4dhv
Namespace:        default
Priority:         0
Service Account:  default
Node:             mentukov-minipc-pn50/172.20.10.7
Start Time:       Thu, 04 May 2023 12:21:09 +0300
Labels:           app=nginx
                  pod-template-hash=f9c79c578
Annotations:      cni.projectcalico.org/containerID: 22f63330fa717b2eb8a9c2069dba4b65c74948b62d0f041d06b90fea9122e26e
                  cni.projectcalico.org/podIP: 10.1.8.209/32
                  cni.projectcalico.org/podIPs: 10.1.8.209/32
Status:           Running
IP:               10.1.8.209
IPs:
  IP:           10.1.8.209
Controlled By:  ReplicaSet/nginx-deployment-f9c79c578
Init Containers:
  init:
    Container ID:  containerd://6c912b94c3c7fa577dae2cc1c9372ccbc4e47c51f911fa64f8bb6d84f39b3959
    Image:         busybox
    Image ID:      docker.io/library/busybox@sha256:b5d6fe0712636ceb7430189de28819e195e8966372edfc2d9409d79402a0dc16
    Port:          <none>
    Host Port:     <none>
    Command:
      sh
      -c
      until nslookup nginx; do echo waiting for nginx; sleep 2; done;
    State:          Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Thu, 04 May 2023 12:21:21 +0300
      Finished:     Thu, 04 May 2023 12:21:21 +0300
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-dgnf2 (ro)
Containers:
  nginx:
    Container ID:   containerd://76d14959a5b7d96975b41575c3e4fdcba372f8078367fa15420cc9512276c511
    Image:          nginx
    Image ID:       docker.io/library/nginx@sha256:480868e8c8c797794257e2abd88d0f9a8809b2fe956cbfbc05dcc0bca1f7cd43
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Thu, 04 May 2023 12:21:26 +0300
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-dgnf2 (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kube-api-access-dgnf2:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason             Age                From               Message
  ----     ------             ----               ----               -------
  Normal   Scheduled          40s                default-scheduler  Successfully assigned default/nginx-deployment-f9c79c578-r4dhv to mentukov-minipc-pn50
  Normal   Pulling            40s                kubelet            Pulling image "busybox"
  Normal   Pulled             28s                kubelet            Successfully pulled image "busybox" in 11.897104966s (11.897117467s including waiting)
  Normal   Created            28s                kubelet            Created container init
  Normal   Started            28s                kubelet            Started container init
  Normal   Pulling            27s                kubelet            Pulling image "nginx"
  Normal   Pulled             23s                kubelet            Successfully pulled image "nginx" in 3.521414353s (3.521438937s including waiting)
  Normal   Created            23s                kubelet            Created container nginx
  Normal   Started            23s                kubelet            Started container nginx
  Warning  MissingClusterDNS  22s (x6 over 40s)  kubelet            pod: "nginx-deployment-f9c79c578-r4dhv_default(942318ef-7e96-42f4-91e5-c2eb5448fb96)". kubelet does not have ClusterDNS IP configured and cannot create Pod using "ClusterFirst" policy. Falling back to "Default" policy.

После старта init сервиса

mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml2$ kubectl apply -f service.yaml 
service/nginx-service created
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml2$ kubectl get pods -o wide
NAME                               READY   STATUS    RESTARTS   AGE    IP           NODE                   NOMINATED NODE   READINESS GATES
nginx-multitool-7956d896d7-lxn7z   2/2     Running   0          83m    10.1.8.206   mentukov-minipc-pn50   <none>           <none>
nginx-multitool-7956d896d7-k7g7m   2/2     Running   0          82m    10.1.8.207   mentukov-minipc-pn50   <none>           <none>
multitool-pod                      1/1     Running   0          80m    10.1.8.208   mentukov-minipc-pn50   <none>           <none>
nginx-deployment-f9c79c578-r4dhv   1/1     Running   0          3m8s   10.1.8.209   mentukov-minipc-pn50   <none>           <none>
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml2$ kubectl get svc -o wide
NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE     SELECTOR
kubernetes                ClusterIP   10.152.183.1    <none>        443/TCP   3h20m   <none>
nginx-multitool-service   ClusterIP   10.152.183.58   <none>        80/TCP    81m     app=nginx-multitool
nginx-service             ClusterIP   10.152.183.71   <none>        80/TCP    19s     app=nginx
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.3/yaml2$ kubectl describe pod nginx-deployment-f9c79c578-r4dhv
Name:             nginx-deployment-f9c79c578-r4dhv
Namespace:        default
Priority:         0
Service Account:  default
Node:             mentukov-minipc-pn50/172.20.10.7
Start Time:       Thu, 04 May 2023 12:21:09 +0300
Labels:           app=nginx
                  pod-template-hash=f9c79c578
Annotations:      cni.projectcalico.org/containerID: 22f63330fa717b2eb8a9c2069dba4b65c74948b62d0f041d06b90fea9122e26e
                  cni.projectcalico.org/podIP: 10.1.8.209/32
                  cni.projectcalico.org/podIPs: 10.1.8.209/32
Status:           Running
IP:               10.1.8.209
IPs:
  IP:           10.1.8.209
Controlled By:  ReplicaSet/nginx-deployment-f9c79c578
Init Containers:
  init:
    Container ID:  containerd://6c912b94c3c7fa577dae2cc1c9372ccbc4e47c51f911fa64f8bb6d84f39b3959
    Image:         busybox
    Image ID:      docker.io/library/busybox@sha256:b5d6fe0712636ceb7430189de28819e195e8966372edfc2d9409d79402a0dc16
    Port:          <none>
    Host Port:     <none>
    Command:
      sh
      -c
      until nslookup nginx; do echo waiting for nginx; sleep 2; done;
    State:          Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Thu, 04 May 2023 12:21:21 +0300
      Finished:     Thu, 04 May 2023 12:21:21 +0300
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-dgnf2 (ro)
Containers:
  nginx:
    Container ID:   containerd://76d14959a5b7d96975b41575c3e4fdcba372f8078367fa15420cc9512276c511
    Image:          nginx
    Image ID:       docker.io/library/nginx@sha256:480868e8c8c797794257e2abd88d0f9a8809b2fe956cbfbc05dcc0bca1f7cd43
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Thu, 04 May 2023 12:21:26 +0300
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-dgnf2 (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kube-api-access-dgnf2:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason             Age                  From               Message
  ----     ------             ----                 ----               -------
  Normal   Scheduled          3m41s                default-scheduler  Successfully assigned default/nginx-deployment-f9c79c578-r4dhv to mentukov-minipc-pn50
  Normal   Pulling            3m41s                kubelet            Pulling image "busybox"
  Normal   Pulled             3m29s                kubelet            Successfully pulled image "busybox" in 11.897104966s (11.897117467s including waiting)
  Normal   Created            3m29s                kubelet            Created container init
  Normal   Started            3m29s                kubelet            Started container init
  Normal   Pulling            3m28s                kubelet            Pulling image "nginx"
  Normal   Pulled             3m24s                kubelet            Successfully pulled image "nginx" in 3.521414353s (3.521438937s including waiting)
  Normal   Created            3m24s                kubelet            Created container nginx
  Normal   Started            3m24s                kubelet            Started container nginx
  Warning  MissingClusterDNS  56s (x8 over 3m41s)  kubelet            pod: "nginx-deployment-f9c79c578-r4dhv_default(942318ef-7e96-42f4-91e5-c2eb5448fb96)". kubelet does not have ClusterDNS IP configured and cannot create Pod using "ClusterFirst" policy. Falling back to "Default" policy.

```

------

