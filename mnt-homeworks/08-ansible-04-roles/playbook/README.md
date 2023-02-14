### playbook

- Установка ClickHouse:
          - clickhouse-common-static
          - clickhouse-client
          - clickhouse-server
- Установка Vector
- Установка NGINX
- Установка GIT
- Клон репы Lighthouse

### Какие у него есть параметры 

- IP серверов нужно задать в файле inventory\prod.yml
- версии ПО и переменные в vars.yml - group_vars\clickhouse\, group_vars\vector\ etc.