# Домашнее задание к занятию «Обновление приложений»

### Цель задания

Выбрать и настроить стратегию обновления приложения.

-----

### Задание 1. Выбрать стратегию обновления приложения и описать ваш выбор

1. Имеется приложение, состоящее из нескольких реплик, которое требуется обновить.
2. Ресурсы, выделенные для приложения, ограничены, и нет возможности их увеличить.
3. Запас по ресурсам в менее загруженный момент времени составляет 20%.
4. Обновление мажорное, новые версии приложения не умеют работать со старыми.
5. Вам нужно объяснить свой выбор стратегии обновления приложения.

### Ответ

### UPD 3

С учетом предоставленных условий и ограничений, оптимальным выбором стратегии обновления приложения будет "Recreate" (Пересоздание) с использованием Kubernetes.

Стратегия "Recreate" предполагает следующий процесс обновления:

1. Создание нового полностью обновленного контейнера с приложением.
2. Остановка работы текущего приложения и удаление его реплик.
3. Запуск новых реплик обновленного приложения на освобожденных ресурсах.

Объяснение выбора "Recreate" с использованием Kubernetes:

1. Эффективное использование ресурсов: Учитывая ограниченность ресурсов и невозможность их увеличения, стратегия "Recreate" позволяет освобождать все ресурсы, занимаемые текущей версией приложения, перед запуском обновленной версии. Это предотвращает конкуренцию за ресурсы между старой и новой версиями, что помогает снизить риск перегрузки системы и обеспечить более плавное обновление.

2. Простота и надежность: Стратегия "Recreate" является относительно простой и надежной. Она не требует сложных механизмов управления версиями и обновлений, что уменьшает возможность возникновения ошибок и снижает риски сбоев во время процесса обновления.

3. Поддержка мажорных обновлений: Учитывая, что новые версии приложения не могут работать со старыми, стратегия "Recreate" идеально подходит для мажорных обновлений, когда требуется полностью заменить старую версию на новую.

4. Запас ресурсов: Имея запас ресурсов в менее загруженный момент времени на уровне 20%, можно эффективно использовать этот запас для безопасного проведения процесса обновления. Стратегия "Recreate" обеспечит освобождение всех ресурсов, что позволит обновленной версии приложения стартовать с оптимальной загрузкой.

5. Изоляция: В процессе "Recreate" новая версия приложения запускается после полного удаления предыдущей версии, что способствует изоляции обновления от текущих работающих процессов. Это помогает предотвратить возможные конфликты и проблемы, связанные с взаимодействием между старой и новой версиями приложения.

Учитывая все вышеперечисленные факторы, стратегия "Recreate" с использованием Kubernetes является безопасным и эффективным способом обновления приложения в данном контексте.

### Задание 2. Обновить приложение

1. Создать deployment приложения с контейнерами nginx и multitool. Версию nginx взять 1.19. Количество реплик — 5.
2. Обновить версию nginx в приложении до версии 1.20, сократив время обновления до минимума. Приложение должно быть доступно.
3. Попытаться обновить nginx до версии 1.28, приложение должно оставаться доступным.
4. Откатиться после неудачного обновления.

### Ответ

```
kuber@master:~/3.4$ kubectl get svc
NAME     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
my-svc   ClusterIP   10.105.33.201   <none>        7001/TCP,7002/TCP   5m4s
kuber@master:~/3.4$ kubectl get po
NAME                      READY   STATUS    RESTARTS   AGE
my-app-5f5b84857c-7dk4t   2/2     Running   0          9m1s
my-app-5f5b84857c-mpdgd   2/2     Running   0          9m1s
my-app-5f5b84857c-qm5px   2/2     Running   0          9m1s
my-app-5f5b84857c-vcx2h   2/2     Running   0          9m1s
my-app-5f5b84857c-x8g6g   2/2     Running   0          9m1s

kuber@master:~/3.4$ kubectl get po my-app-5f5b84857c-7dk4t -o yaml
apiVersion: v1
kind: Pod
...
  containerStatuses:
  - containerID: containerd://7a2368426375b6d847246900fe0955bc9276f100ebdfd0c626fc8c7051561c8d
    image: docker.io/praqma/network-multitool:alpine-extra
    imageID: docker.io/praqma/network-multitool@sha256:5662f8284f0dc5f5e5c966e054d094cbb6d0774e422ad9031690826bc43753e5
    lastState: {}
    name: multitool
    ready: true
    restartCount: 0
    started: true
    state:
      running:
        startedAt: "2023-07-05T12:08:58Z"
  - containerID: containerd://6c0322d027c5c999d73391419d133f90c0235612a76cf42a662c4d7ad4f264ac
    image: docker.io/library/nginx:1.19
    imageID: docker.io/library/nginx@sha256:df13abe416e37eb3db4722840dd479b00ba193ac6606e7902331dcea50f4f1f2
    lastState: {}
    name: nginx
    ready: true
    restartCount: 0
    started: true
    state:
      running:
        startedAt: "2023-07-05T12:08:58Z"
  hostIP: 192.168.82.78
  phase: Running
  podIP: 172.16.104.8
  podIPs:
  - ip: 172.16.104.8
  qosClass: BestEffort
  startTime: "2023-07-05T12:08:57Z"

kuber@master:~/3.4$ kubectl exec my-app-5f5b84857c-7dk4t -- curl my-svc:7002
Defaulted container "nginx" out of: nginx, multitool
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    81  100    81    0     0   9000      0 --:--:-- --:--:-- --:--:-- 10125
Praqma Network MultiTool (with NGINX) - my-app-5f5b84857c-vcx2h - 172.16.166.144
kuber@master:~/3.4$ kubectl exec my-app-5f5b84857c-7dk4t -- curl my-svc:7001
Defaulted container "nginx" out of: nginx, multitool
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0    99k      0 --:--:-- --:--:-- --:--:--  119k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
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
kuber@master:~/3.4$ cat deployment.yaml 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
        - name: nginx
          image: nginx:1.20
          ports:
            - containerPort: 80

        - name: multitool
          image: praqma/network-multitool:alpine-extra
          ports:
            - containerPort: 8080
          env:
          - name: HTTP_PORT
            value: "8080"
          ports:
          - containerPort: 8080
            name: http-port

kuber@master:~/3.4$ kubectl apply -f deployment.yaml
kuber@master:~/3.4$ kubectl get po -o wide
NAME                      READY   STATUS    RESTARTS   AGE   IP               NODE    NOMINATED NODE   READINESS GATES
my-app-6676bf4dc7-kh5zz   2/2     Running   0          25s   172.16.135.17    node3   <none>           <none>
my-app-6676bf4dc7-n2wrz   2/2     Running   0          23s   172.16.104.9     node2   <none>           <none>
my-app-6676bf4dc7-qkbs5   2/2     Running   0          25s   172.16.3.81      node4   <none>           <none>
my-app-6676bf4dc7-r7nd6   2/2     Running   0          23s   172.16.166.145   node1   <none>           <none>
my-app-6676bf4dc7-zkzbc   2/2     Running   0          21s   172.16.166.146   node1   <none>           <none>
kuber@master:~/3.4$ kubectl get deploy
NAME     READY   UP-TO-DATE   AVAILABLE   AGE
my-app   5/5     5            5           18m
kuber@master:~/3.4$ kubectl describe deploy my-app
Name:                   my-app
Namespace:              app
CreationTimestamp:      Wed, 05 Jul 2023 12:08:57 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 2
Selector:               app=my-app
Replicas:               5 desired | 5 updated | 5 total | 5 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  1 max unavailable, 1 max surge
Pod Template:
  Labels:  app=my-app
  Containers:
   nginx:
    Image:        nginx:1.20
    Port:         80/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
   multitool:
    Image:      praqma/network-multitool:alpine-extra
    Port:       8080/TCP
    Host Port:  0/TCP
    Environment:
      HTTP_PORT:  8080
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  my-app-5f5b84857c (0/0 replicas created)
NewReplicaSet:   my-app-6676bf4dc7 (5/5 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  19m   deployment-controller  Scaled up replica set my-app-5f5b84857c to 5
  Normal  ScalingReplicaSet  80s   deployment-controller  Scaled up replica set my-app-6676bf4dc7 to 1
  Normal  ScalingReplicaSet  80s   deployment-controller  Scaled down replica set my-app-5f5b84857c to 4 from 5
  Normal  ScalingReplicaSet  80s   deployment-controller  Scaled up replica set my-app-6676bf4dc7 to 2 from 1
  Normal  ScalingReplicaSet  78s   deployment-controller  Scaled down replica set my-app-5f5b84857c to 3 from 4
  Normal  ScalingReplicaSet  78s   deployment-controller  Scaled up replica set my-app-6676bf4dc7 to 3 from 2
  Normal  ScalingReplicaSet  78s   deployment-controller  Scaled down replica set my-app-5f5b84857c to 2 from 3
  Normal  ScalingReplicaSet  78s   deployment-controller  Scaled up replica set my-app-6676bf4dc7 to 4 from 3
  Normal  ScalingReplicaSet  76s   deployment-controller  Scaled down replica set my-app-5f5b84857c to 1 from 2
  Normal  ScalingReplicaSet  76s   deployment-controller  Scaled up replica set my-app-6676bf4dc7 to 5 from 4
  Normal  ScalingReplicaSet  76s   deployment-controller  (combined from similar events): Scaled down replica set my-app-5f5b84857c to 0 from 1
kuber@master:~/3.4$ cat deployment.yaml 
apiVersion: apps/v1
kind: Deployment
...
    spec:
      containers:
        - name: nginx
          image: nginx:1.28
...
kuber@master:~/3.4$ kubectl get po
NAME                      READY   STATUS             RESTARTS   AGE
my-app-6676bf4dc7-kh5zz   2/2     Running            0          6m45s
my-app-6676bf4dc7-n2wrz   2/2     Running            0          6m43s
my-app-6676bf4dc7-qkbs5   2/2     Running            0          6m45s
my-app-6676bf4dc7-r7nd6   2/2     Running            0          6m43s
my-app-7cd574f597-dth6b   1/2     ImagePullBackOff   0          7s
my-app-7cd574f597-lzmkm   1/2     ImagePullBackOff   0          7s
kuber@master:~/3.4$ kubectl exec my-app-6676bf4dc7-kh5zz -- curl my-svc:7001
Defaulted container "nginx" out of: nginx, multitool
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0    99k      0 --:--:-- --:--:-- --:--:--   99k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
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

kuber@master:~/3.4$ kubectl rollout status deployment my-app
Waiting for deployment "my-app" rollout to finish: 2 out of 5 new replicas have been updated...

kuber@master:~/3.4$ kubectl rollout undo deployment my-app
deployment.apps/my-app rolled back
kuber@master:~/3.4$ kubectl get po
NAME                      READY   STATUS    RESTARTS   AGE
my-app-6676bf4dc7-dxmhx   2/2     Running   0          5s
my-app-6676bf4dc7-kh5zz   2/2     Running   0          9m10s
my-app-6676bf4dc7-n2wrz   2/2     Running   0          9m8s
my-app-6676bf4dc7-qkbs5   2/2     Running   0          9m10s
my-app-6676bf4dc7-r7nd6   2/2     Running   0          9m8s

```

-----
