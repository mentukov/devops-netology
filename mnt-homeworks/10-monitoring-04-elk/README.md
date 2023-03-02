# Домашнее задание к занятию 15 «Система сбора логов Elastic Stack»

## Дополнительные ссылки

При выполнении задания используйте дополнительные ресурсы:

- [поднимаем elk в docker](https://www.elastic.co/guide/en/elastic-stack-get-started/current/get-started-docker.html);
- [поднимаем elk в docker с filebeat и docker-логами](https://www.sarulabs.com/post/5/2019-08-12/sending-docker-logs-to-elasticsearch-and-kibana-with-filebeat.html);
- [конфигурируем logstash](https://www.elastic.co/guide/en/logstash/current/configuration.html);
- [плагины filter для logstash](https://www.elastic.co/guide/en/logstash/current/filter-plugins.html);
- [конфигурируем filebeat](https://www.elastic.co/guide/en/beats/libbeat/5.3/config-file-format.html);
- [привязываем индексы из elastic в kibana](https://www.elastic.co/guide/en/kibana/current/index-patterns.html);
- [как просматривать логи в kibana](https://www.elastic.co/guide/en/kibana/current/discover.html);
- [решение ошибки increase vm.max_map_count elasticsearch](https://stackoverflow.com/questions/42889241/how-to-increase-vm-max-map-count).

В процессе выполнения в зависимости от системы могут также возникнуть не указанные здесь проблемы.

Используйте output stdout filebeat/kibana и api elasticsearch для изучения корня проблемы и её устранения.

## Задание повышенной сложности

Не используйте директорию [help](./help) при выполнении домашнего задания.

## Задание 1

Вам необходимо поднять в докере и связать между собой:

- elasticsearch (hot и warm ноды);
- logstash;
- kibana;
- filebeat.

Logstash следует сконфигурировать для приёма по tcp json-сообщений.

Filebeat следует сконфигурировать для отправки логов docker вашей системы в logstash.

В директории [help](./help) находится манифест docker-compose и конфигурации filebeat/logstash для быстрого 
выполнения этого задания.

Результатом выполнения задания должны быть:

- скриншот `docker ps` через 5 минут после старта всех контейнеров (их должно быть 5);
- скриншот интерфейса kibana;
- docker-compose манифест (если вы не использовали директорию help);
- ваши yml-конфигурации для стека (если вы не использовали директорию help).

```
/etc/sysctl.conf
vm.max_map_count=262144

sysctl -p
```
docker-compose.yml
```
filebeat:
    networks:
      - elastic
```
logstash.conf
```
input {
  beats {
    port => 5046
    codec => json
  }
}
```
<img width="1120" alt="Снимок экрана 2023-03-02 в 16 26 32" src="https://user-images.githubusercontent.com/65667114/222412552-255bb356-b765-4c9b-97c5-872e2d478c4c.png">
<img width="1407" alt="Снимок экрана 2023-03-02 в 16 24 49" src="https://user-images.githubusercontent.com/65667114/222412612-9ba6d756-4488-4fe7-99c0-534e45791911.png">

## Задание 2

Перейдите в меню [создания index-patterns  в kibana](http://localhost:5601/app/management/kibana/indexPatterns/create) и создайте несколько index-patterns из имеющихся.
<img width="1420" alt="Снимок экрана 2023-03-02 в 16 30 59" src="https://user-images.githubusercontent.com/65667114/222412784-7d2a1627-4349-4628-86c5-55a4a520a407.png">

Перейдите в меню просмотра логов в kibana (Discover) и самостоятельно изучите, как отображаются логи и как производить поиск по логам.

В манифесте директории help также приведенно dummy-приложение, которое генерирует рандомные события в stdout-контейнера.
Эти логи должны порождать индекс logstash-* в elasticsearch. Если этого индекса нет — воспользуйтесь советами и источниками из раздела «Дополнительные ссылки» этого задания.
 <img width="1428" alt="Снимок экрана 2023-03-02 в 16 32 14" src="https://user-images.githubusercontent.com/65667114/222412803-1ebf8b85-782d-4905-a5aa-9bd5aae434e5.png">
<img width="1429" alt="Снимок экрана 2023-03-02 в 16 34 01" src="https://user-images.githubusercontent.com/65667114/222412816-d9ab6fd9-a208-4c9a-a38f-fc6b67765b58.png">

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
