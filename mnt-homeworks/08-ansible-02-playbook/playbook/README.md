### Playbook

Данный плейбук устанавливает Clickhouse и Vector на указанные хосты. 

В директории group_vars созданы 2 файла vars.yml

| Имя параметра              | Значение                 |
|:---------------------------|:-------------------------|
| *{{ clickhouse_version }}* | 23.1.3.5                 |
| *{{clickhouse_packages }}* | clickhouse-client        |
|                            | clickhouse-server        |
|                            | clickhouse-common-static |
| *{{vector_version}}*       | 0.27.0                   |

## Inventory list

```
  clickhouse:
    hosts: 
      click01:
        ansible_host: 158.160.16.20
        ansible_ssh_user: ***
  vector:
    hosts:
      click02:
        ansible_host: 158.160.1.252
        ansible_ssh_user: ***

```

## Tasks list 

| Задача                      | Описание                        |
|:----------------------------|:--------------------------------|
| Get clickhouse distrib      | скачивают пакеты clickhouse     |
| Install clickhouse packages | установка с помощью yum         |
| Flush handlers              | старт сервиса clickhouse-server |
| Create database             | создает БД                      |
| Download Vector             | скачивает пакет vector          |
| Install Vector              | установка с помощью yum         |

## Parameters

| Параметр | Описание параметра                                |
|:---------|:--------------------------------------------------|
| name     | Наименование Play                                 |
| hosts    | список хостов для Плейбук                         |
| handlers | обработчик событий                                |
| tasks    | набор действий, которые будут выполнены на хостах |
      


