# Домашнее задание к занятию "Микросервисы: подходы"

Вы работаете в крупной компанию, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps специалисту необходимо выдвинуть предложение по организации инфраструктуры, для разработки и эксплуатации.


## Задача 1: Обеспечить разработку

Предложите решение для обеспечения процесса разработки: хранение исходного кода, непрерывная интеграция и непрерывная поставка. 
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- Облачная система;
- Система контроля версий Git;
- Репозиторий на каждый сервис;
- Запуск сборки по событию из системы контроля версий;
- Запуск сборки по кнопке с указанием параметров;
- Возможность привязать настройки к каждой сборке;
- Возможность создания шаблонов для различных конфигураций сборок;
- Возможность безопасного хранения секретных данных: пароли, ключи доступа;
- Несколько конфигураций для сборки из одного репозитория;
- Кастомные шаги при сборке;
- Собственные докер образы для сборки проектов;
- Возможность развернуть агентов сборки на собственных серверах;
- Возможность параллельного запуска нескольких сборок;
- Возможность параллельного запуска тестов;

Обоснуйте свой выбор.

#### Ответ

Для обеспечения процесса разработки и доставки приложений в качестве инструмента непрерывной интеграции и доставки я рекомендую использовать GitLab CI/CD.

- GitLab CI/CD - это система автоматической сборки, тестирования и развертывания приложений, которая интегрирована непосредственно в GitLab, облачную систему для хранения кода.
- GitLab CI/CD позволяет создавать шаблоны для различных конфигураций сборок и привязывать настройки к каждой сборке. Он также обеспечивает безопасное хранение секретных данных, таких как пароли и ключи доступа. GitLab CI/CD позволяет создавать несколько конфигураций для сборки из одного репозитория, а также добавлять кастомные шаги при сборке.
- GitLab CI/CD позволяет создавать собственные докер образы для сборки проектов и развернуть агентов сборки на собственных серверах. Кроме того, он обеспечивает возможность параллельного запуска нескольких сборок и тестов.

В итоге GitLab CI/CD обеспечивает надежный, гибкий и простой в использовании процесс непрерывной интеграции и доставки для микросервисной архитектуры, который может быть адаптирован под конкретные потребности вашей компании.

## Задача 2: Логи

Предложите решение для обеспечения сбора и анализа логов сервисов в микросервисной архитектуре.
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- Сбор логов в центральное хранилище со всех хостов обслуживающих систему;
- Минимальные требования к приложениям, сбор логов из stdout;
- Гарантированная доставка логов до центрального хранилища;
- Обеспечение поиска и фильтрации по записям логов;
- Обеспечение пользовательского интерфейса с возможностью предоставления доступа разработчикам для поиска по записям логов;
- Возможность дать ссылку на сохраненный поиск по записям логов;

Обоснуйте свой выбор.

#### Ответ

Для сбора и анализа логов в микросервисной архитектуре я бы предложил использовать Elasticsearch, Logstash и Kibana (ELK-стек).

- Elasticsearch - это распределенный поисковый и аналитический движок, который может хранить и анализировать большой объем структурированных и неструктурированных данных, включая логи. Elasticsearch обеспечивает быстрый поиск и фильтрацию по записям логов и имеет API для интеграции с другими системами.
- Logstash - это инструмент для сбора, обработки и пересылки логов. Logstash может собирать логи со всех хостов обслуживающих систему, обрабатывать их и отправлять в Elasticsearch. Logstash поддерживает множество источников логов и может обрабатывать различные форматы логов.
- Kibana - это веб-интерфейс для визуализации и анализа данных, хранящихся в Elasticsearch. Kibana обеспечивает пользовательский интерфейс с возможностью предоставления доступа разработчикам для поиска по записям логов, а также позволяет сохранять запросы в виде ссылок для дальнейшего использования.

ELK-стек обеспечивает гарантированную доставку логов до центрального хранилища и минимальные требования к приложениям, сбор логов из stdout. Кроме того, ELK-стек предоставляет возможность настройки кластера Elasticsearch для обеспечения масштабируемости и отказоустойчивости.

Таким образом, использование ELK-стека позволит обеспечить сбор логов со всех хостов обслуживающих систему, их сохранение и обработку, а также быстрый поиск и фильтрацию по записям логов. Пользователи смогут использовать Kibana для анализа логов и получения необходимой информации.

## Задача 3: Мониторинг

Предложите решение для обеспечения сбора и анализа состояния хостов и сервисов в микросервисной архитектуре.
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- Сбор метрик со всех хостов, обслуживающих систему;
- Сбор метрик состояния ресурсов хостов: CPU, RAM, HDD, Network;
- Сбор метрик потребляемых ресурсов для каждого сервиса: CPU, RAM, HDD, Network;
- Сбор метрик, специфичных для каждого сервиса;
- Пользовательский интерфейс с возможностью делать запросы и агрегировать информацию;
- Пользовательский интерфейс с возможность настраивать различные панели для отслеживания состояния системы;

Обоснуйте свой выбор.

#### Ответ

Для сбора и анализа состояния хостов и сервисов в микросервисной архитектуре можно использовать инструменты мониторинга и анализа метрик, такие как Prometheus, Grafana и Node Exporter.

- Prometheus - это система мониторинга и алертинга с открытым исходным кодом, которая позволяет собирать метрики со многих источников, включая хосты и сервисы, и сохранять их в центральном хранилище. Prometheus имеет мощный язык запросов PromQL, который позволяет агрегировать и анализировать метрики и строить графики и дашборды.
- Node Exporter - это агент, который собирает метрики о состоянии хоста и его ресурсах, таких как CPU, RAM, HDD и Network. Он экспортирует метрики в формате Prometheus, что позволяет собирать метрики сразу же после установки.
- Grafana - это инструмент для визуализации метрик, который позволяет строить графики и дашборды на основе данных, собранных из различных источников, включая Prometheus. Графана предоставляет пользовательский интерфейс для анализа метрик и настройки панелей для мониторинга состояния системы.

Данный стек инструментов позволяет эффективно собирать метрики о состоянии хостов и сервисов в микросервисной архитектуре, а также анализировать и визуализировать их в удобном для пользователя формате. Он легко масштабируется и имеет открытый исходный код, что делает его привлекательным выбором для любой компании, занимающейся разработкой и эксплуатацией микросервисных систем.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---