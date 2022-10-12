# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

### Ответ

```shell
mentukov@ubuntu:~$ sudo docker pull postgres:13
[sudo] password for mentukov: 
13: Pulling from library/postgres
df8e44b0463f: Pull complete 
b754b0988cff: Pull complete 
ad5356093597: Pull complete 
f89869ca900b: Pull complete 
47843a81e9ab: Pull complete 
07e62452bcf1: Pull complete 
da41c6e7f3d3: Pull complete 
2dc9a0774b1e: Pull complete 
fe421beced8f: Pull complete 
188cc1f84cbb: Pull complete 
7ca45f7ec91c: Pull complete 
802849f5f3e1: Pull complete 
02b9536ee8ed: Pull complete 
Digest: sha256:7cc1c1a6a9df06df9e775eccdd77e45a868cb197e8e0981e23a2a814aaf56906
Status: Downloaded newer image for postgres:13
docker.io/library/postgres:13

mentukov@ubuntu:~$ sudo docker volume create postgre_db
postgre_db
mentukov@ubuntu:~$ sudo docker run -d --name postgres --restart unless-stopped -e POSTGRES_PASSWORD=netology -p 5432:5432 -v postgre_db:/var/lib/postgresql/data postgres:13
7fca3095a625a3dd1659703dc864337becd7e6e6363d1a81b27897c366c5815a
mentukov@ubuntu:~$ sudo docker exec -ti postgres bash
root@7fca3095a625:/# 



```

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---