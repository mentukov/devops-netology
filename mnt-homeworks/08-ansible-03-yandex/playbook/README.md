### Playbook

Данный плейбук устанавливает Clickhouse, Vector, Nginx, Git, Lighthouse на указанные хосты. 

В директории group_vars созданы файлы vars.yml

| Имя параметра                   | Значение                 |
|:--------------------------------|:-------------------------|
| *{{ clickhouse_version }}*      | 23.1.3.5                 |
| *{{ clickhouse_packages }}*     | clickhouse-client        |
|                                 | clickhouse-server        |
|                                 | clickhouse-common-static |
| *{{ vector_version }}*          | 0.27.0                   |
| *{{ lighthouse_location_dir }}* | директория lighthouse    |
| "{{ lighthouse_vcs }}"          | git lighthouse           |

## Inventory list

```
clickhouse:
  hosts:
    click01:
      ansible_host: 158.160.6.136
      ansible_ssh_user: ***
vector:
  hosts:
    vector01:
      ansible_host: 84.201.152.191
      ansible_ssh_user: ***
lighthouse:
  hosts:
    light01:
      ansible_host: 51.250.17.154
      ansible_ssh_user: ***
```

## Tasks list 

| Задача                        | Описание                             |
|:------------------------------|:-------------------------------------|
| Get clickhouse distrib        | скачивают пакеты clickhouse          |
| Install clickhouse packages   | установка с помощью yum              |
| Flush handlers                | старт сервиса clickhouse-server      |
| Create database               | создает БД                           |
| Download Vector               | скачивает пакет vector               |
| Install Vector                | установка с помощью yum              |
| Install epel-release          | установка доп пакетов для enterprise |
| Install Nginx                 | установка Nginx                      |
| Create dir for Lighthouse     | создание директории для lighthouse   |
| Create Nginx config           | Создание конфига для Вебсервера      |
| Install git                   | установка GIT                        |
| Copy lighthouse from git      | скачивает git Lighthouse             |
| Create lighthouse config      | создает конфиг для Lighthouse        |

## Parameters

| Параметр | Описание параметра                                |
|:---------|:--------------------------------------------------|
| name     | Наименование Play                                 |
| hosts    | список хостов для Плейбук                         |
| handlers | обработчик событий                                |
| tasks    | набор действий, которые будут выполнены на хостах |

## Teamplates

| teamplate          | Description                     |
|:-------------------|:--------------------------------|
| lighthouse.conf.j2 | Lighthouse configuration        |
| nginx.conf.j2      | Nginx configuration             |
