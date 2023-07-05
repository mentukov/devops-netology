# Домашнее задание к занятию «Как работает сеть в K8s»

### Цель задания

Настроить сетевую политику доступа к подам.

-----

### Задание 1. Создать сетевую политику или несколько политик для обеспечения доступа

1. Создать deployment'ы приложений frontend, backend и cache и соответсвующие сервисы.
2. В качестве образа использовать network-multitool.
3. Разместить поды в namespace App.
4. Создать политики, чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены.
5. Продемонстрировать, что трафик разрешён и запрещён.

### Ответ

```
kuber@master:~/3.3$ kubectl get po -o wide
NAME                       READY   STATUS    RESTARTS   AGE   IP               NODE    NOMINATED NODE   READINESS GATES
backend-5c496f8f74-9c549   1/1     Running   0          67m   172.16.166.137   node1   <none>           <none>
cache-5cd6c7468-q45nd      1/1     Running   0          67m   172.16.135.9     node3   <none>           <none>
frontend-7ddf66cbb-d2m92   1/1     Running   0          67m   172.16.3.74      node4   <none>           <none>
kuber@master:~/3.3$ kubectl get svc -o wide
NAME       TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE   SELECTOR
backend    ClusterIP   10.108.168.218   <none>        80/TCP    77m   app=backend
cache      ClusterIP   10.104.197.77    <none>        80/TCP    77m   app=cache
frontend   ClusterIP   10.108.179.103   <none>        80/TCP    80m   app=frontend
kuber@master:~/3.3$ kubectl get deployments -o wide
NAME       READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS          IMAGES                                  SELECTOR
backend    1/1     1            1           67m   network-multitool   praqma/network-multitool:alpine-extra   app=backend
cache      1/1     1            1           67m   network-multitool   praqma/network-multitool:alpine-extra   app=cache
frontend   1/1     1            1           67m   network-multitool   praqma/network-multitool:alpine-extra   app=frontend
kuber@master:~/3.3$ kubectl get networkpolicy -o wide
NAME                   POD-SELECTOR   AGE
back-to-cache          app=cache      6m2s
default-deny-ingress   <none>         47m
front-to-back          app=backend    6m20s

kuber@master:~/3.3$ kubectl get networkpolicy
NAME                   POD-SELECTOR   AGE
default-deny-ingress   <none>         38m
kuber@master:~/3.3$ kubectl exec cache-5cd6c7468-q45nd -- curl cache
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:02 --:--:--     0^C
kuber@master:~/3.3$ kubectl exec backend-5c496f8f74-9c549 -- curl cache
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:05 --:--:--     0^C
kuber@master:~/3.3$ kubectl exec frontend-7ddf66cbb-d2m92 -- curl backend
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:08 --:--:--     0^C
kuber@master:~/3.3$ kubectl apply -f front-to-back.yaml 
networkpolicy.networking.k8s.io/front-to-back created
kuber@master:~/3.3$ kubectl exec frontend-7ddf66cbb-d2m92 -- curl backend
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0Praqma Network MultiTool (with NGINX) - backend-5c496f8f74-9c549 - 172.16.166.137
100    82  100    82    0     0  11302      0 --:--:-- --:--:-- --:--:-- 11714
kuber@master:~/3.3$ kubectl apply -f back-to-cache.yaml 
networkpolicy.networking.k8s.io/back-to-cache created
kuber@master:~/3.3$ kubectl exec backend-5c496f8f74-9c549 -- curl cache
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0Praqma Network MultiTool (with NGINX) - cache-5cd6c7468-q45nd - 172.16.135.9
100    77  100    77    0     0  13386      0 --:--:-- --:--:-- --:--:-- 15400
kuber@master:~/3.3$ kubectl exec backend-5c496f8f74-9c549 -- curl frontend
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:09 --:--:--     0^C
kuber@master:~/3.3$ kubectl exec backend-5c496f8f74-9c549 -- curl backend
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:05 --:--:--     0^C
kuber@master:~/3.3$ kubectl exec frontend-7ddf66cbb-d2m92 -- curl cache
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:06 --:--:--     0^C
kuber@master:~/3.3$ kubectl exec frontend-7ddf66cbb-d2m92 -- curl frontend
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:12 --:--:--     0^C
kuber@master:~/3.3$ kubectl exec cache-5cd6c7468-q45nd -- curl frontend
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:06 --:--:--     0^C
kuber@master:~/3.3$ kubectl exec cache-5cd6c7468-q45nd -- curl backend
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:09 --:--:--     0^C
kuber@master:~/3.3$ kubectl exec cache-5cd6c7468-q45nd -- curl cache
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:05 --:--:--     0^C
```

-----