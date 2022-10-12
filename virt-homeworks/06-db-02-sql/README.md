# Домашнее задание к занятию "6.2. SQL"

---

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

### Ответ

```shell
➜  ~ sudo docker pull postgres:12
12: Pulling from library/postgres
3d898485473e: Pull complete 
4ab9a79a9772: Pull complete 
8116dc73cb3e: Pull complete 
e8ceb4515aa7: Pull complete 
1d6f7eceb1d7: Pull complete 
51a94e4c3770: Pull complete 
5172abe7cf72: Pull complete 
9577c9870fc5: Pull complete 
e360e36f3dc9: Pull complete 
a090544e0e13: Pull complete 
f77c6b83cea3: Pull complete 
e10fff738d14: Pull complete 
f74f23e01cbd: Pull complete 
Digest: sha256:2028a16834c9fecf9b5b3b177c80f2c8518c793b38b88c64d3762443a6af6e52
Status: Downloaded newer image for postgres:12
docker.io/library/postgres:12
➜  ~ sudo docker volume create data
data
➜  ~ sudo docker volume create backup
backup
mentukov@ubuntu:~$ sudo docker run --rm -d --name pg-docker -e POSTGRES_PASSWORD=postgres -ti -p 5432:5432 -v data:/var/lib/postgresql/data -v backup:/var/lib/postgresql postgres:12
1579ad83a5a12954cf379b3a17921ce99e7aa8ee0399b59dd3de93ea81394a4d
mentukov@ubuntu:~$ export PGPASSWORD=postgres && psql -h localhost -U postgres
psql (12.12 (Ubuntu 12.12-0ubuntu0.20.04.1))
Type "help" for help.

postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)


```

---

## Задача 2

В БД из задачи 1:  
- создайте пользователя test-admin-user и БД test_db  
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)  
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db  
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db  

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

### Ответ

1)  Создадим пользователя test-admin-user и БД test_db.
```shell
postgres=# CREATE DATABASE test_db;
CREATE DATABASE
postgres=# CREATE ROLE "test-admin-user" SUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;
CREATE ROLE

```
2) В БД test_db создадим таблицу orders и clients.
```shell
postgres=# CREATE TABLE orders
postgres-# (
postgres(# id integer,
postgres(# name text,
postgres(# price integer,
postgres(# PRIMARY KEY (id)
postgres(# );
CREATE TABLE
postgres=# CREATE TABLE clients
postgres-# (
postgres(# id integer PRIMARY KEY,
postgres(# lastname text,
postgres(# country text,
postgres(# booking integer,
postgres(# FOREIGN KEY (booking) REFERENCES orders (Id)
postgres(# );
CREATE TABLE

```
3) Предоставим привилегии на все операции пользователю test-admin-user на таблицы БД test_db.
```shell
postgres=# GRANT ALL ON TABLE public.clients to "test-admin-user";
GRANT
postgres=# GRANT ALL ON TABLE public.orders to "test-admin-user";
GRANT
```
4) Cоздадим пользователя test-simple-user.
```shell
postgres=# CREATE ROLE "test-simple-user" NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;
CREATE ROLE
```
5) Предоставим пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db.
```shell
postgres=# GRANT SELECT ON TABLE public.clients TO "test-simple-user";
GRANT
postgres=# GRANT INSERT ON TABLE public.clients TO "test-simple-user";
GRANT
postgres=# GRANT UPDATE ON TABLE public.clients TO "test-simple-user";
GRANT
postgres=# GRANT DELETE ON TABLE public.clients TO "test-simple-user";
GRANT
postgres=# GRANT SELECT ON TABLE public.orders TO "test-simple-user";
GRANT
postgres=# GRANT INSERT ON TABLE public.orders TO "test-simple-user";
GRANT
postgres=# GRANT UPDATE ON TABLE public.orders TO "test-simple-user";
GRANT
postgres=# GRANT DELETE ON TABLE public.orders TO "test-simple-user";
GRANT

```
### Результаты
Итоговый список БД после выполнения пунктов выше.
```shell
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)
```
Описание таблиц (describe).
```shell
postgres=# \d orders
               Table "public.orders"
 Column |  Type   | Collation | Nullable | Default 
--------+---------+-----------+----------+---------
 id     | integer |           | not null | 
 name   | text    |           |          | 
 price  | integer |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_booking_fkey" FOREIGN KEY (booking) REFERENCES orders(id)
```
```shell
postgres=# \d clients
               Table "public.clients"
  Column  |  Type   | Collation | Nullable | Default 
----------+---------+-----------+----------+---------
 id       | integer |           | not null | 
 lastname | text    |           |          | 
 country  | text    |           |          | 
 booking  | integer |           |          | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_booking_fkey" FOREIGN KEY (booking) REFERENCES orders(id)
```
SQL-запрос для выдачи списка пользователей с правами над таблицами test_db.
```shell
> SELECT 
    grantee, table_name, privilege_type 
FROM 
    information_schema.table_privileges 
WHERE 
    grantee in ('test-admin-user','test-simple-user')
    and table_name in ('clients','orders')
order by 
    1,2,3

grantee|table_name|privilege_type|
-------+----------+--------------+

0 row(s) fetched.
```
Список пользователей с правами над таблицами test_db.
```shell
     grantee      | table_name | privilege_type
------------------+------------+----------------
 test-admin-user  | clients    | DELETE
 test-admin-user  | clients    | INSERT
 test-admin-user  | clients    | REFERENCES
 test-admin-user  | clients    | SELECT
 test-admin-user  | clients    | TRIGGER
 test-admin-user  | clients    | TRUNCATE
 test-admin-user  | clients    | UPDATE
 test-admin-user  | orders     | DELETE
 test-admin-user  | orders     | INSERT
 test-admin-user  | orders     | REFERENCES
 test-admin-user  | orders     | SELECT
 test-admin-user  | orders     | TRIGGER
 test-admin-user  | orders     | TRUNCATE
 test-admin-user  | orders     | UPDATE
 test-simple-user | clients    | DELETE
 test-simple-user | clients    | INSERT
 test-simple-user | clients    | SELECT
 test-simple-user | clients    | UPDATE
 test-simple-user | orders     | DELETE
 test-simple-user | orders     | INSERT
 test-simple-user | orders     | SELECT
 test-simple-user | orders     | UPDATE
(22 rows)
```

---

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

### Ответ
1) Наполним таблицы.
```shell
postgres=# insert into orders VALUES (1, 'Шоколад', 10), (2, 'Принтер', 3000), (3, 'Книга', 500), (4, 'Монитор', 7000), (5, 'Гитара', 4000);
INSERT 0 5
postgres=# insert into clients VALUES (1, 'Иванов Иван Иванович', 'USA'), (2, 'Петров Петр Петрович', 'Canada'), (3, 'Иоганн Себастьян Бах', 'Japan'), (4, 'Ронни Джеймс Дио', 'Russia'), (5, 'Ritchie Blackmore', 'Russia');
INSERT 0 5
```
2) Вычислим количество записей для каждой таблицы.
```shell
postgres=# select count (*) from orders;
 count 
-------
     5
(1 row)

postgres=# select count (*) from clients;
 count 
-------
     5
(1 row)

```
3) Приведем сами таблицы.
```shell
postgres=# select * from orders;
 id |  name   | price 
----+---------+-------
  1 | Шоколад |    10
  2 | Принтер |  3000
  3 | Книга   |   500
  4 | Монитор |  7000
  5 | Гитара  |  4000
(5 rows)

postgres=# select * from clients;
 id |       lastname       | country | booking 
----+----------------------+---------+---------
  1 | Иванов Иван Иванович | USA     |        
  2 | Петров Петр Петрович | Canada  |        
  3 | Иоганн Себастьян Бах | Japan   |        
  4 | Ронни Джеймс Дио     | Russia  |        
  5 | Ritchie Blackmore    | Russia  |        
(5 rows)


```

---

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказка - используйте директиву `UPDATE`.

### Ответ

> Приведите SQL-запросы для выполнения данных операций.

```shell
postgres=# update clients set booking = (select id from orders where name = 'Книга') where lastname = 'Иванов Иван Иванович';
UPDATE 1
postgres=# update clients set booking = (select id from orders where name = 'Монитор') where lastname = 'Петров Петр Петрович';
UPDATE 1
postgres=# update clients set booking = (select id from orders where name = 'Гитара') where lastname = 'Иоганн Себастьян Бах';
UPDATE 1
```
> Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

```shell
postgres=# select * from clients as c where exists (select id from orders as o where c.booking = o.id);
 id |       lastname       | country | booking 
----+----------------------+---------+---------
  1 | Иванов Иван Иванович | USA     |       3
  2 | Петров Петр Петрович | Canada  |       4
  3 | Иоганн Себастьян Бах | Japan   |       5
(3 rows)

```

---

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

### Ответ

> Приведите получившийся результат.

```shell
postgres=# explain select * from clients as c where exists (select id from orders as o where c.booking = o.id);
                                      QUERY PLAN                                       
---------------------------------------------------------------------------------------
 Nested Loop  (cost=0.15..25.91 rows=5 width=47)
   ->  Seq Scan on clients c  (cost=0.00..1.05 rows=5 width=47)
   ->  Index Only Scan using orders_pkey on orders o  (cost=0.15..4.97 rows=1 width=4)
         Index Cond: (id = c.booking)
(4 rows)

```
> Объясните что значат полученные значения.

Планировщик выбирает соединение по хешу, при котором строки одной таблицы (orders) записываются в хеш-таблицу в памяти, после чего сканируется другая таблица (clients) и для каждой её строки проверяется соответствие по хеш-таблице.

- cost=  
  * Приблизительная стоимость запуска.
- rows=  
  * Ожидаемое число строк, которое должен вывести этот узел плана. 
- width=  
  * Ожидаемый средний размер строк.

## Задача 6


Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1). 
Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL. 
Восстановите БД test_db в новом контейнере. 
Приведите список операций, который вы применяли для бэкапа данных и восстановления. 


### Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

1. Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

```shell
mentukov@ubuntu:~$ pg_dump -h localhost -U postgres test_db > backup/test_db.sql
mentukov@ubuntu:~$ ls backup/
test_db.sql

```

2. Остановите контейнер с PostgreSQL (но не удаляйте volumes).

```shell
mentukov@ubuntu:~$ sudo docker container ls
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                                       NAMES
1579ad83a5a1   postgres:12   "docker-entrypoint.s…"   48 minutes ago   Up 48 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   pg-docker
mentukov@ubuntu:~$ sudo docker stop pg-docker
pg-docker

```

3. Поднимите новый пустой контейнер с PostgreSQL.

```shell
mentukov@ubuntu:~$ sudo docker container ls
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                                       NAMES
1579ad83a5a1   postgres:12   "docker-entrypoint.s…"   48 minutes ago   Up 48 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   pg-docker
mentukov@ubuntu:~$ sudo docker stop pg-docker
pg-docker

```

4. Восстановите БД test_db в новом контейнере.

```shell
mentukov@ubuntu:~$ sudo docker exec -ti pg-docker3 bash
root@5585be48f101:/# psql -U postgres -c "CREATE DATABASE test_db;"
CREATE DATABASE
root@5585be48f101:/# psql -U postgres test_db < backups/test_db.sql
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET


```

---