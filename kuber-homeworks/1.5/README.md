# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 2»

------

### Задание 1. Создать Deployment приложений backend и frontend

1. Создать Deployment приложения _frontend_ из образа nginx с количеством реплик 3 шт.
2. Создать Deployment приложения _backend_ из образа multitool. 
3. Добавить Service, которые обеспечат доступ к обоим приложениям внутри кластера. 
4. Продемонстрировать, что приложения видят друг друга с помощью Service.
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

### Ответ

```
12:48:40 mentukov@mentukov-MINIPC-PN50 yaml1 ±|main|→ kubectl apply -f frontend-deployment.yaml
deployment.apps/frontend-deployment created
12:50:13 mentukov@mentukov-MINIPC-PN50 yaml1 ±|main|→ kubectl apply -f backend-deployment.yaml
deployment.apps/backend-deployment created
12:50:24 mentukov@mentukov-MINIPC-PN50 yaml1 ±|main|→ kubectl apply -f service.yaml
service/my-service created
service/backend-service created
12:50:52 mentukov@mentukov-MINIPC-PN50 yaml1 ±|main|→ kubectl apply -f MultitoolPod.yaml 
pod/multitool-pod created
12:52:42 mentukov@mentukov-MINIPC-PN50 yaml1 ±|main|→ kubectl get service -o wide
NAME              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE     SELECTOR
kubernetes        ClusterIP   10.152.183.1     <none>        443/TCP    14d     <none>
my-service        ClusterIP   10.152.183.226   <none>        80/TCP     2m18s   app=frontend
backend-service   ClusterIP   10.152.183.249   <none>        8080/TCP   2m18s   app=backend
12:52:56 mentukov@mentukov-MINIPC-PN50 yaml1 ±|main|→ kubectl exec -it multitool-pod -- /bin/bash
bash-5.1# curl 10.152.183.226:80
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
bash-5.1# curl 10.152.183.249:8080
WBITT Network MultiTool (with NGINX) - backend-deployment-8494f9f8bd-9bgwc - 10.1.8.207 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)

```

------

### Задание 2. Создать Ingress и обеспечить доступ к приложениям снаружи кластера

1. Включить Ingress-controller в MicroK8S.
2. Создать Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S так, чтобы при запросе только по адресу открывался _frontend_ а при добавлении /api - _backend_.
3. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
4. Предоставить манифесты и скриншоты или вывод команды п.2.

### Ответ

```
01:00:35 mentukov@mentukov-MINIPC-PN50 1.5 ±|main|→ microk8s enable ingress
Infer repository core for addon ingress
Addon core/ingress is already enabled
01:03:53 mentukov@mentukov-MINIPC-PN50 yaml2 ±|main|→ kubectl apply -f ingress.yaml
ingress.networking.k8s.io/my-ingress created
01:04:08 mentukov@mentukov-MINIPC-PN50 yaml2 ±|main|→ microk8s kubectl get ingress
NAME         CLASS    HOSTS   ADDRESS     PORTS   AGE
my-ingress   public   *       127.0.0.1   80      11s
➜  ~ curl 172.20.10.7:80
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
➜  ~ curl 172.20.10.7/api
WBITT Network MultiTool (with NGINX) - backend-deployment-8494f9f8bd-9bgwc - 10.1.8.207 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)

```
<img width="1173" alt="Снимок экрана 2023-05-18 в 18 06 43" src="https://github.com/mentukov/devops-netology/assets/65667114/59676937-187c-4501-9de4-77858675b7d5">

------
