# Домашнее задание к занятию «Kubernetes. Причины появления. Команда kubectl»

### Цель задания

Для экспериментов и валидации ваших решений вам нужно подготовить тестовую среду для работы с Kubernetes. Оптимальное решение — развернуть на рабочей машине или на отдельной виртуальной машине MicroK8S.

------

### Чеклист готовности к домашнему заданию

1. Личный компьютер с ОС Linux или MacOS 

или

2. ВМ c ОС Linux в облаке либо ВМ на локальной машине для установки MicroK8S  

------

### Инструкция к заданию

1. Установка MicroK8S:
    - sudo apt update,
    - sudo apt install snapd,
    - sudo snap install microk8s --classic,
    - добавить локального пользователя в группу `sudo usermod -a -G microk8s $USER`,
    - изменить права на папку с конфигурацией `sudo chown -f -R $USER ~/.kube`.

2. Полезные команды:
    - проверить статус `microk8s status --wait-ready`;
    - подключиться к microK8s и получить информацию можно через команду `microk8s command`, например, `microk8s kubectl get nodes`;
    - включить addon можно через команду `microk8s enable`; 
    - список addon `microk8s status`;
    - вывод конфигурации `microk8s config`;
    - проброс порта для подключения локально `microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443`.

3. Настройка внешнего подключения:
    - отредактировать файл /var/snap/microk8s/current/certs/csr.conf.template
    ```shell
    # [ alt_names ]
    # Add
    # IP.4 = 123.45.67.89
    ```
    - обновить сертификаты `sudo microk8s refresh-certs --cert front-proxy-client.crt`.

4. Установка kubectl:
    - curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl;
    - chmod +x ./kubectl;
    - sudo mv ./kubectl /usr/local/bin/kubectl;
    - настройка автодополнения в текущую сессию `bash source <(kubectl completion bash)`;
    - добавление автодополнения в командную оболочку bash `echo "source <(kubectl completion bash)" >> ~/.bashrc`.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://microk8s.io/docs/getting-started) по установке MicroK8S.
2. [Инструкция](https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/#bash) по установке автодополнения **kubectl**.
3. [Шпаргалка](https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/) по **kubectl**.

------

### Задание 1. Установка MicroK8S

1. Установить MicroK8S на локальную машину или на удалённую виртуальную машину.
2. Установить dashboard.
3. Сгенерировать сертификат для подключения к внешнему ip-адресу.

### Ответ

```
mentukov@minik8s:~$ sudo snap install microk8s --classic
microk8s (1.26/stable) v1.26.1 from Canonical✓ installed
mentukov@minik8s:~$ sudo usermod -a -G microk8s $USER
mentukov@minik8s:~$ newgrp microk8s
mentukov@minik8s:~$ microk8s status --wait-ready
microk8s is running

mentukov@minik8s:~$ alias kubectl='microk8s kubectl'
mentukov@minik8s:~$ kubectl get nodes
NAME      STATUS   ROLES    AGE   VERSION
minik8s   Ready    <none>   26m   v1.26.1

mentukov@mentukov-MINIPC-PN50:~$ token=$(microk8s kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
microk8s kubectl -n kube-system describe secret $token

mentukov@mentukov-MINIPC-PN50:~$ sudo mkdir -p /root/certs
mentukov@mentukov-MINIPC-PN50:~$ sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /root/certs/dashboard.key -out /root/certs/dashboard.crt -subj "/CN=dashboard"
mentukov@minik8s:~$ microk8s enable dns dashboard storage

mentukov@minik8s:~$ mkdir ~/certs
mentukov@minik8s:~$ openssl req -newkey rsa:2048 -nodes -keyout ~/certs/dashboard.key -x509 -days 365 -out ~/certs/dashboard.crt

mentukov@minik8s:~$ microk8s kubectl create secret tls kubernetes-dashboard-certs --key ~/certs/dashboard.key --cert ~/certs/dashboard.crt -n kube-system
error: failed to create secret secrets "kubernetes-dashboard-certs" already exists
mentukov@minik8s:~$ sudo microk8s kubectl create secret tls kubernetes-dashboard-certs --key ~/certs/dashboard.key --cert ~/certs/dashboard.crt -n kube-system --dry-run=client -o yaml | sudo microk8s kubectl apply -f -
E0328 09:47:39.595248    7836 memcache.go:255] couldn't get resource list for metrics.k8s.io/v1beta1: the server is currently unable to handle the request
E0328 09:47:39.607755    7836 memcache.go:106] couldn't get resource list for metrics.k8s.io/v1beta1: the server is currently unable to handle the request
The Secret "kubernetes-dashboard-certs" is invalid: type: Invalid value: "kubernetes.io/tls": field is immutable
mentukov@minik8s:~$ sudo microk8s kubectl delete secret kubernetes-dashboard-certs -n kube-system
E0328 09:47:55.725070    8227 memcache.go:255] couldn't get resource list for metrics.k8s.io/v1beta1: the server is currently unable to handle the request
E0328 09:47:55.801557    8227 memcache.go:106] couldn't get resource list for metrics.k8s.io/v1beta1: the server is currently unable to handle the request
E0328 09:47:55.806177    8227 memcache.go:106] couldn't get resource list for metrics.k8s.io/v1beta1: the server is currently unable to handle the request
E0328 09:47:55.812490    8227 memcache.go:106] couldn't get resource list for metrics.k8s.io/v1beta1: the server is currently unable to handle the request
secret "kubernetes-dashboard-certs" deleted
mentukov@minik8s:~$ sudo microk8s kubectl delete secret kubernetes-dashboard-certs -n kube-system
Error from server (NotFound): secrets "kubernetes-dashboard-certs" not found
mentukov@minik8s:~$ sudo microk8s kubectl create secret tls kubernetes-dashboard-certs --key ~/certs/dashboard.key --cert ~/certs/dashboard.crt -n kube-system
secret/kubernetes-dashboard-certs created

mentukov@minik8s:~$ KUBE_EDITOR="nano" microk8s kubectl edit deployment kubernetes-dashboard -n kube-system
mentukov@minik8s:~$ microk8s kubectl patch service kubernetes-dashboard -n kube-system -p '{"spec": {"type": "NodePort"}}'
service/kubernetes-dashboard patched
mentukov@minik8s:~$ microk8s kubectl get service kubernetes-dashboard -n kube-system
NAME                   TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
kubernetes-dashboard   NodePort   10.152.183.93   <none>        443:32002/TCP   12m

mentukov@minik8s:~$ sudo microk8s kubectl create -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kube-system
EOF
serviceaccount/admin-user created
clusterrolebinding.rbac.authorization.k8s.io/admin-user created
mentukov@minik8s:~$ sudo microk8s kubectl -n kube-system describe secret $(sudo microk8s kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

```

------

### Задание 2. Установка и настройка локального kubectl
1. Установить на локальную машину kubectl.
2. Настроить локально подключение к кластеру.
3. Подключиться к дашборду с помощью port-forward.

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода команд `kubectl get nodes` и скриншот дашборда.

------

### Критерии оценки
Зачёт — выполнены все задания, ответы даны в развернутой форме, приложены соответствующие скриншоты и файлы проекта, в выполненных заданиях нет противоречий и нарушения логики.

На доработку — задание выполнено частично или не выполнено, в логике выполнения заданий есть противоречия, существенные недостатки.