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

```

------

