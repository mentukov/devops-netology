# Домашнее задание к занятию "6.6. Troubleshooting"

## Задача 1

Перед выполнением задания ознакомьтесь с документацией по [администрированию MongoDB](https://docs.mongodb.com/manual/administration/).

Пользователь (разработчик) написал в канал поддержки, что у него уже 3 минуты происходит CRUD операция в MongoDB и её 
нужно прервать. 

Вы как инженер поддержки решили произвести данную операцию:
- напишите список операций, которые вы будете производить для остановки запроса пользователя
```shell
db.currentOp()
db.killOp()

```
- предложите вариант решения проблемы с долгими (зависающими) запросами в MongoDB
```shell
db.collection_name.find(<query_string>).maxTimeMS(<time_limit>)

Стоит провести оптимизацию работы БД, а именно индексов.
И если все ок задуматься о масштабировании.
Возможно, стоит убедиться в правильности выбора СУБД.

```

## Задача 2

Перед выполнением задания познакомьтесь с документацией по [Redis latency troobleshooting](https://redis.io/topics/latency).

Вы запустили инстанс Redis для использования совместно с сервисом, который использует механизм TTL. 
Причем отношение количества записанных key-value значений к количеству истёкших значений есть величина постоянная и
увеличивается пропорционально количеству реплик сервиса. 

При масштабировании сервиса до N реплик вы увидели, что:
- сначала рост отношения записанных значений к истекшим
- Redis блокирует операции записи

Как вы думаете, в чем может быть проблема?
 
```shell
Недостаточно оперативной памяти для такого количества реплик в рамках одного сервера. 
И записанные значения стали очищаться раньше истечения TTL.

Warning - If you edit an existing database that already has data in it, 
some updates might fail as they could cause the total database size to exceed the memory limit. 

If memory limit is reached, Redis will start to reply with an error to write commands 
(but will continue to accept read-only commands).

```

## Задача 3

Вы подняли базу данных MySQL для использования в гис-системе. При росте количества записей, в таблицах базы,
пользователи начали жаловаться на ошибки вида:
```python
InterfaceError: (InterfaceError) 2013: Lost connection to MySQL server during query u'SELECT..... '
```

Как вы думаете, почему это начало происходить и как локализовать проблему?

Какие пути решения данной проблемы вы можете предложить?

```shell
Обычно это указывает на проблемы с сетевым подключением, и следует проверить состояние сети.

Иногда такая ошибка возникает, когда миллионы строк отправляются как часть одного или нескольких 
запросов. В этом случае следует попробовать увеличить net_read_timeout с значения по умолчанию 
30 секунд до 60 секунд или дольше, достаточного для завершения передачи данных.

Реже это может произойти, когда клиент пытается установить первоначальное соединение с сервером. 
В этом случае, если значение connect_timeout недостаточно, можно решить проблему, 
увеличив его до десяти секунд, возможно, больше, если соединение медленное.

B.3.2.3 Lost connection to MySQL server
There are three likely causes for this error message.

Usually it indicates network connectivity trouble and you should check the condition of your network 
if this error occurs frequently. If the error message includes “during query,” 
this is probably the case you are experiencing.

Sometimes the “during query” form happens when millions of rows are being sent as part of one or more queries. 
If you know that this is happening, you should try increasing net_read_timeout from its default of 
30 seconds to 60 seconds or longer, sufficient for the data transfer to complete.

More rarely, it can happen when the client is attempting the initial connection to the server. 
In this case, if your connect_timeout value is set to only a few seconds, you may be able to resolve the problem by 
increasing it to ten seconds, perhaps more if you have a very long distance or slow connection. 
You can determine whether you are experiencing this more uncommon cause by using SHOW GLOBAL STATUS LIKE 
'Aborted_connects'. It increases by one for each initial connection attempt that the server aborts. 
You may see “reading authorization packet” as part of the error message; if so, that also suggests that this is 
the solution that you need.

If the cause is none of those just described, you may be experiencing a problem with BLOB values that are larger than 
max_allowed_packet, which can cause this error with some clients. Sometime you may see an ER_NET_PACKET_TOO_LARGE error, 
and that confirms that you need to increase max_allowed_packet.

```

## Задача 4


Вы решили перевести гис-систему из задачи 3 на PostgreSQL, так как прочитали в документации, что эта СУБД работает с 
большим объемом данных лучше, чем MySQL.

После запуска пользователи начали жаловаться, что СУБД время от времени становится недоступной. В dmesg вы видите, что:

`postmaster invoked oom-killer`

Как вы думаете, что происходит?

Как бы вы решили данную проблему?

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---