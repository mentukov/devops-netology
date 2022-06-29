# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"


---

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

## Ответ

https://hub.docker.com/u/mentukov

```shell
➜  docker git:(main) ✗ nano index.html
➜  docker git:(main) ✗ cat index.html 
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>

➜  docker git:(main) ✗ nano Dockerfile
➜  docker git:(main) ✗ sudo docker build -t mentukov/netology-nginx:v0.0.1 .
Password:
[+] Building 14.1s (8/8) FINISHED                     

➜  docker git:(main) ✗ docker image ls
REPOSITORY                TAG       IMAGE ID       CREATED          SIZE
mentukov/netology-nginx   v0.0.1    62e5b6026ceb   58 seconds ago   142MB
➜  docker git:(main) ✗ sudo docker run --rm -d --name test-nginx -p 8080:80 mentukov/netology-nginx:v0.0.1
**********************************************
➜  docker git:(main) ✗ docker ps -a
CONTAINER ID   IMAGE                            COMMAND                  CREATED              STATUS              PORTS                  NAMES
20752de271c3   mentukov/netology-nginx:v0.0.1   "/docker-entrypoint.…"   About a minute ago   Up About a minute   0.0.0.0:8080->80/tcp   test-nginx

➜  docker git:(main) ✗ sudo docker push mentukov/netology-nginx:v0.0.1
The push refers to repository [docker.io/mentukov/netology-nginx]
6809ec89646c: Pushed 
e7344f8a29a3: Mounted from library/nginx 
44193d3f4ea2: Mounted from library/nginx 
41451f050aa8: Mounted from library/nginx 
b2f82de68e0d: Mounted from library/nginx 
d5b40e80384b: Mounted from library/nginx 
08249ce7456a: Mounted from library/nginx 
v0.0.1: digest: sha256:****************************** size: 1777
```

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
- Nodejs веб-приложение;
- Мобильное приложение c версиями для Android и iOS;
- Шина данных на базе Apache Kafka;
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
- Мониторинг-стек на базе Prometheus и Grafana;
- MongoDB, как основное хранилище данных для java-приложения;
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

### Ответ

Высоконагруженное монолитное java веб-приложение;
```
Виртуальная или физическая машина
```

Nodejs веб-приложение;
```
Контейнер
```

Мобильное приложение c версиями для Android и iOS;
```
Контейнер
```

Шина данных на базе Apache Kafka;
```
Контейнер или виртуальная машина
```

Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
```
Контейнер или виртуальная машина
```

Мониторинг-стек на базе Prometheus и Grafana;
```
Контейнер
```

MongoDB, как основное хранилище данных для java-приложения;
```
Виртуальная или физическая машина
```

Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
```
Контейнер или виртуальная машина
```

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

### Ответ

```shell
➜  05-virt-03-docker git:(main) ✗ mkdir data  

➜  05-virt-03-docker git:(main) ✗ sudo docker pull centos
Using default tag: latest
latest: Pulling from library/centos
a1d0c7532777: Pull complete 
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
docker.io/library/centos:latest

➜  05-virt-03-docker git:(main) ✗ sudo docker run -it --rm -d --name centos -v $(pwd)/data:/data centos 

➜  05-virt-03-docker git:(main) ✗ sudo docker pull debian
Using default tag: latest
latest: Pulling from library/debian
1339eaac5b67: Pull complete 
Digest: sha256:859ea45db307402ee024b153c7a63ad4888eb4751921abbef68679fc73c4c739
Status: Downloaded newer image for debian:latest
docker.io/library/debian:latest

➜  05-virt-03-docker git:(main) ✗ sudo docker run -it --rm -d --name debian -v $(pwd)/data:/data debian

➜  05-virt-03-docker git:(main) ✗ docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED              STATUS              PORTS     NAMES
78bda44b8cdc   debian    "bash"        12 seconds ago       Up 12 seconds                 debian
aecc697fa71f   centos    "/bin/bash"   About a minute ago   Up About a minute             centos

➜  05-virt-03-docker git:(main) ✗ sudo docker exec -it centos bash
[root@aecc697fa71f /]# cd /data
[root@aecc697fa71f data]# touch centos-test
[root@aecc697fa71f data]# ls
centos-test

➜  05-virt-03-docker git:(main) ✗ sudo docker exec -it debian bash
root@78bda44b8cdc:/# touch /data/debian-test
root@78bda44b8cdc:/# ls /data/
centos-test  debian-test

➜  05-virt-03-docker git:(main) ✗ ls -la data
total 0
drwxr-xr-x  4 mentukov  staff  128 29 июн 13:55 .
drwxr-xr-x  5 mentukov  staff  160 29 июн 13:45 ..
-rw-r--r--  1 mentukov  staff    0 29 июн 13:54 centos-test
-rw-r--r--  1 mentukov  staff    0 29 июн 13:55 debian-test
```

## Задача 4 (*)


Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.


---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---