# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 1»

------

### Задание 1. Создать Deployment и обеспечить доступ к контейнерам приложения по разным портам из другого Pod внутри кластера

1. Создать Deployment приложения, состоящего из двух контейнеров (nginx и multitool), с количеством реплик 3 шт.
2. Создать Service, который обеспечит доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080.
3. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры.
4. Продемонстрировать доступ с помощью `curl` по доменному имени сервиса.
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

### Ответ

```
12:21:25 mentukov@mentukov-MINIPC-PN50 yaml1 ±|main|→ kubectl apply -f Deployment.yaml 
deployment.apps/my-app created
12:21:47 mentukov@mentukov-MINIPC-PN50 yaml1 ±|main|→ kubectl get deployments
NAME     READY   UP-TO-DATE   AVAILABLE   AGE
my-app   3/3     3            3           31s
12:22:03 mentukov@mentukov-MINIPC-PN50 yaml1 ±|main|→ kubectl apply -f Service.yaml 
service/my-app-service created
12:22:22 mentukov@mentukov-MINIPC-PN50 yaml1 ±|main|→ kubectl exec -it multitool-pod -- /bin/bash
bash-5.1# curl my-app-service.default.svc.cluster.local:9001
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
bash-5.1# curl my-app-service.default.svc.cluster.local:9002
WBITT Network MultiTool (with NGINX) - my-app-6d4769875c-pq4pp - 10.1.8.205 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)

```

------

### Задание 2. Создать Service и обеспечить доступ к приложениям снаружи кластера

1. Создать отдельный Service приложения из Задания 1 с возможностью доступа снаружи кластера к nginx, используя тип NodePort.
2. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
3. Предоставить манифест и Service в решении, а также скриншоты или вывод команды п.2.

### Ответ

```
12:31:36 mentukov@mentukov-MINIPC-PN50 yaml2 ±|main|→ kubectl apply -f Service.yaml 
service/my-app-service-ext created
12:31:51 mentukov@mentukov-MINIPC-PN50 yaml2 ±|main|→ kubectl get svc
NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                         AGE
kubernetes           ClusterIP   10.152.183.1    <none>        443/TCP                         14d
my-app-service       ClusterIP   10.152.183.78   <none>        9001/TCP,9002/TCP               9m35s
my-app-service-ext   NodePort    10.152.183.70   <none>        9001:30001/TCP,9002:30002/TCP   6s
12:31:57 mentukov@mentukov-MINIPC-PN50 yaml2 ±|main|→ kubectl get nodes -o wide
NAME                   STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
mentukov-minipc-pn50   Ready    <none>   14d   v1.26.4   172.20.10.7   <none>        Ubuntu 22.04.2 LTS   5.19.0-41-generic   containerd://1.6.15
12:32:20 mentukov@mentukov-MINIPC-PN50 yaml2 ±|main|→ curl 172.20.10.7:30001
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
12:33:01 mentukov@mentukov-MINIPC-PN50 yaml2 ±|main|→ curl 172.20.10.7:30002
WBITT Network MultiTool (with NGINX) - my-app-6d4769875c-9jxlg - 10.1.8.203 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)

```

------
