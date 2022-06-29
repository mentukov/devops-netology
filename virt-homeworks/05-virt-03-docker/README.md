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
20752de271c30ccaad8efc016cc77f0ff650dd7bf3452a39ab0dc32aa026850e
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
v0.0.1: digest: sha256:8ff4b673910256b960546c8cbb38505da8be58c5804e4c70d1e283c4b2cf9fe7 size: 1777
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

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.


---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---