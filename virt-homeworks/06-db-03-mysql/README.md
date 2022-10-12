# Домашнее задание к занятию "6.3. MySQL"


## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

### Ответ

1) Скачаем образ docker с mysql 8.
```shell
mentukov@ubuntu:~$ sudo docker pull mysql:8.0
[sudo] password for mentukov: 
8.0: Pulling from library/mysql
5d45c82139e0: Pull complete 
8c544deffc3a: Pull complete 
af07bf98dff8: Pull complete 
0554dfac498a: Pull complete 
f612237e783e: Pull complete 
7249cc35cb4b: Pull complete 
41fea0f5462f: Pull complete 
0f227634493d: Pull complete 
846b06f0fa9d: Pull complete 
bd488d76876a: Pull complete 
82bd893588df: Pull complete 
Digest: sha256:fcc59f92c4136dd017dc7ef5bb8c4fb5a67780e8dd580c7de0eb12bbcad59698
Status: Downloaded newer image for mysql:8.0
docker.io/library/mysql:8.0
```
2) Перейдем в управляющую консоль mysql внутри контейнера.
```shell
mentukov@ubuntu:~$ sudo docker run -d --name mysql -e MYSQL_ROOT_PASSWORD='123456' -p 3306:3306 -v sqlbackup:/sqlbuckup mysql:8
Unable to find image 'mysql:8' locally
8: Pulling from library/mysql
Digest: sha256:fcc59f92c4136dd017dc7ef5bb8c4fb5a67780e8dd580c7de0eb12bbcad59698
Status: Downloaded newer image for mysql:8
f5f161e48b2ea73a18af151b6a14a5c942c2c1d5f20c4415578f9e0b225bbcbd
mentukov@ubuntu:~$ sudo docker exec -ti mysql bash 
bash-4.4# mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.0.31 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 

```
3) Используем команду `\h` получим список управляющих команд. Узнаем команду для выдачи статуса БД.
```shell
mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/
```
4) Посмотрим статус БД. Приведем версию сервера БД.
```shell
mysql> \s
--------------
mysql  Ver 8.0.30-0ubuntu0.20.04.2 for Linux on aarch64 ((Ubuntu))

Connection id:		16
Current database:	test_db
Current user:		root@172.17.0.1
SSL:			Cipher in use is TLS_AES_256_GCM_SHA384
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.31 MySQL Community Server - GPL
Protocol version:	10
Connection:		127.0.0.1 via TCP/IP
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	utf8mb4
Conn.  characterset:	utf8mb4
TCP port:		3306
Binary data as:		Hexadecimal
Uptime:			33 min 28 sec

Threads: 2  Questions: 52  Slow queries: 0  Opens: 166  Flush tables: 3  Open tables: 84  Queries per second avg: 0.025
--------------


```
4) Восстановим ДБ из дампа.
```shell
$ mysql -h 127.0.0.1 -P 3306 -u root -p test_db < ./test_db_dump.sql 
Enter password:
```
5) Получим список таблиц восстановленной ДБ.
```shell
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.02 sec)


```
6) Получим количество записей с `price` > 300.
```shell
mysql> SELECT COUNT(*) FROM orders WHERE price > 300;
+----------+
| COUNT(*) |
+----------+
|        1 |
+----------+
1 row in set (0.01 sec)

```

---

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---