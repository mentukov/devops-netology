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
➜  ~ docker run --rm -d --name pg-docker -e POSTGRES_PASSWORD=postgres -ti -p 5432:5432 -v data:/var/lib/postgresql/data -v backup:/var/lib/postgresql postgres:12
a548408bfa71e9d02d66cd227d67e7f3091f77b967904d880df7e327b73ce7bb
➜  ~ docker exec -it pg-docker bash     
root@a548408bfa71:/# psql -h localhost -U postgres
psql (12.12 (Debian 12.12-1.pgdg110+1))
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
➜  ~ export PGPASSWORD=postgres && psql -h localhost -U postgres
psql (14.5 (Homebrew), server 12.12 (Debian 12.12-1.pgdg110+1))
Type "help" for help.

postgres=# CREATE DATABASE test_db;
CREATE DATABASE
postgres=# CREATE ROLE "test-admin-user" SUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;
CREATE ROLE
```
2) В БД test_db создадим таблицу orders и clients.
```shell
postgres=# CREATE TABLE orders
(
id integer,
name text,
price integer,
PRIMARY KEY (id)
);
CREATE TABLE
postgres=# CREATE TABLE clients 
(
id integer PRIMARY KEY,
lastname text,
country text,
booking integer,
FOREIGN KEY (booking) REFERENCES orders (Id)
);
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
postgres=# CREATE ROLE "test-simple-user" NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;
CREATE ROLE
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
SELECT 
    grantee, table_name, privilege_type 
FROM 
    information_schema.table_privileges 
WHERE 
    grantee in ('test-admin-user','test-simple-user')
    and table_name in ('clients','orders')
order by 
    1,2,3;
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
------------------------------------------------------------------------
 Hash Join  (cost=37.00..57.24 rows=810 width=72)
   Hash Cond: (c.booking = o.id)
   ->  Seq Scan on clients c  (cost=0.00..18.10 rows=810 width=72)
   ->  Hash  (cost=22.00..22.00 rows=1200 width=4)
         ->  Seq Scan on orders o  (cost=0.00..22.00 rows=1200 width=4)
(5 rows)

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

   ```bash
   export PGPASSWORD=netology && pg_dumpall -h localhost -U test-admin-user > /media/postgresql/backup/all_$(date --iso-8601=m | sed 's/://g; s/+/z/g').sql
   ```

2. Остановите контейнер с PostgreSQL (но не удаляйте volumes).

   ```bash 
   $ docker-compose stop
   Stopping psql ... done
   $ docker ps -a
   CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS                     PORTS     NAMES
   213107257ce9   postgres:12   "docker-entrypoint.s…"   4 minutes ago   Exited (0) 2 seconds ago             psql
   ```

3. Поднимите новый пустой контейнер с PostgreSQL.

   ```bash
   docker run --rm -d -e POSTGRES_USER=test-admin-user -e POSTGRES_PASSWORD=netology -e POSTGRES_DB=test_db -v psql_backup:/media/postgresql/backup --name psql2 postgres:12
   ```
   ```bash
   CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS                     PORTS      NAMES
   cf2c8f875948   postgres:12   "docker-entrypoint.s…"   4 minutes ago    Up 4 minutes               5432/tcp   psql2
   213107257ce9   postgres:12   "docker-entrypoint.s…"   14 minutes ago   Exited (0) 5 minutes ago              psql
   ```

4. Восстановите БД test_db в новом контейнере.

   ```bash
   docker exec -it psql2  bash
   export PGPASSWORD=netology && psql -h localhost -U test-admin-user -f $(ls -1trh /media/postgresql/backup/all_*.sql) test_db
   ```
---