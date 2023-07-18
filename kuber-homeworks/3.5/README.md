# Домашнее задание к занятию Troubleshooting

### Цель задания

Устранить неисправности при деплое приложения.

### Задание. При деплое приложение web-consumer не может подключиться к auth-db. Необходимо это исправить

1. Установить приложение по команде:
```shell
kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
```
2. Выявить проблему и описать.
3. Исправить проблему, описать, что сделано.
4. Продемонстрировать, что проблема решена.

### Ответ

```shell
kuber@master:~$ kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "web" not found
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data" not found
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data" not found
kuber@master:~$ kubectl create namespace web
namespace/web created
kuber@master:~$ kubectl create namespace data
namespace/data created
kuber@master:~$ kubectl get ns
NAME              STATUS   AGE
app               Active   13d
data              Active   6s
default           Active   20d
kube-node-lease   Active   20d
kube-public       Active   20d
kube-system       Active   20d
web               Active   13s
kuber@master:~$ kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
deployment.apps/web-consumer created
deployment.apps/auth-db created
service/auth-db created
kuber@master:~$ kubectl get deployment --all-namespaces
NAMESPACE     NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
data          auth-db                   1/1     1            1           22s
kube-system   calico-kube-controllers   1/1     1            1           20d
kube-system   coredns                   2/2     2            2           20d
web           web-consumer              2/2     2            2           22s
kuber@master:~$ kubectl get svc -n data -o wide
NAME      TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE   SELECTOR
auth-db   ClusterIP   10.110.237.1   <none>        80/TCP    55s   app=auth-db
kuber@master:~$ kubectl get po -n data
NAME                       READY   STATUS    RESTARTS   AGE
auth-db-864ff9854c-46jtt   1/1     Running   0          97s
kuber@master:~$ kubectl get po -n web
NAME                            READY   STATUS    RESTARTS   AGE
web-consumer-84fc79d94d-ckpq7   1/1     Running   0          110s
web-consumer-84fc79d94d-wsrr2   1/1     Running   0          110s
kuber@master:~$ kubectl logs -n data pod/auth-db-864ff9854c-46jtt
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
kuber@master:~$ kubectl logs -n web pod/web-consumer-84fc79d94d-ckpq7
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
[ root@web-consumer-84fc79d94d-ckpq7:/ ]$ nslookup auth-db.data
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      auth-db.data
Address 1: 10.110.237.1 auth-db.data.svc.cluster.local
[ root@web-consumer-84fc79d94d-ckpq7:/ ]$ curl auth-db.data.svc.cluster.local
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

```
Меняем в конфиге имя с auth-db на auth-db.data.svc.cluster.local

![Снимок экрана 2023-07-18 в 13 28 51](https://github.com/mentukov/devops-netology/assets/65667114/828cd470-ffe3-437d-98a9-7b1ab9ad9c8e)

перезапускаем deployments

![Снимок экрана 2023-07-18 в 13 29 08](https://github.com/mentukov/devops-netology/assets/65667114/e5df6523-28f4-4634-a48f-4a0f33ba8c0c)

```shell
kuber@master:~$ kubectl logs -n web pod/web-consumer-86d8bc498f-fbc7k
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   101k      0 --:--:-- --:--:-- --:--:--  298k
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
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   106k      0 --:--:-- --:--:-- --:--:--  298k

```
