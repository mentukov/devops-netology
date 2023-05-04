# Домашнее задание к занятию «Базовые объекты K8S»

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Pod с приложением и подключиться к нему со своего локального компьютера. 

------

### Задание 1. Создать Pod с именем hello-world

1. Создать манифест (yaml-конфигурацию) Pod.
2. Использовать image - gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Подключиться локально к Pod с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

### Ответ

```
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.2$ mkdir yaml
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.2$ cd yaml/

mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.2/yaml$ nano hello-world.yaml 
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.2/yaml$ cat hello-world.yaml 
apiVersion: v1
kind: Pod
metadata:
  name: hello-world
spec:
  containers:
  - name: hello-world
    image: gcr.io/kubernetes-e2e-test-images/echoserver:2.2
    ports:
    - containerPort: 8080

mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.2/yaml$ kubectl apply -f hello-world.yaml
pod/hello-world created
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.2/yaml$ kubectl port-forward pod/hello-world 8080:8080
Forwarding from 127.0.0.1:8080 -> 8080
Forwarding from [::1]:8080 -> 8080
Handling connection for 8080

mentukov@mentukov-MINIPC-PN50:~$ curl http://localhost:8080/

Hostname: hello-world

Pod Information:
	-no pod information available-

Server values:
	server_version=nginx: 1.12.2 - lua: 10010

Request Information:
	client_address=127.0.0.1
	method=GET
	real path=/
	query=
	request_version=1.1
	request_scheme=http
	request_uri=http://localhost:8080/

Request Headers:
	accept=*/*  
	host=localhost:8080  
	user-agent=curl/7.81.0  

Request Body:
	-no body in request-

```

------

### Задание 2. Создать Service и подключить его к Pod

1. Создать Pod с именем netology-web.
2. Использовать image — gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Создать Service с именем netology-svc и подключить к netology-web.
4. Подключиться локально к Service с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

```
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.2/yaml$ cat netology-web.yaml 
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: netology
  name: netology-web
spec:
  containers:
  - name: netology-web
    image: gcr.io/kubernetes-e2e-test-images/echoserver:2.2

mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.2/yaml$ cat netology-svc.yaml 
apiVersion: v1
kind: Service
metadata:
  name: netology-svc
spec:
  selector:
    app: netology
  ports:
  - name: http
    port: 8080
    
kubectl apply -f netology-web.yaml
kubectl apply -f netology-svc.yaml 
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.2/yaml$ kubectl get svc -o wide
NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE     SELECTOR
kubernetes     ClusterIP   10.152.183.1     <none>        443/TCP    61m     <none>
netology-svc   ClusterIP   10.152.183.193   <none>        8080/TCP   4m14s   app=netology
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.2/yaml$ kubectl get pods -o wide
NAME           READY   STATUS    RESTARTS   AGE     IP           NODE                   NOMINATED NODE   READINESS GATES
hello-world    1/1     Running   0          37m     10.1.8.198   mentukov-minipc-pn50   <none>           <none>
netology-web   1/1     Running   0          6m48s   10.1.8.200   mentukov-minipc-pn50   <none>           <none>
mentukov@mentukov-MINIPC-PN50:~/temp/devops-netology/kuber-homeworks/1.2/yaml$ kubectl port-forward service/netology-svc 8080:8080
Forwarding from 127.0.0.1:8080 -> 8080
Forwarding from [::1]:8080 -> 8080
Handling connection for 8080

mentukov@mentukov-MINIPC-PN50:~$ curl http://localhost:8080/


Hostname: netology-web

Pod Information:
	-no pod information available-

Server values:
	server_version=nginx: 1.12.2 - lua: 10010

Request Information:
	client_address=127.0.0.1
	method=GET
	real path=/
	query=
	request_version=1.1
	request_scheme=http
	request_uri=http://localhost:8080/

Request Headers:
	accept=*/*  
	host=localhost:8080  
	user-agent=curl/7.81.0  

Request Body:
	-no body in request-

```

------

