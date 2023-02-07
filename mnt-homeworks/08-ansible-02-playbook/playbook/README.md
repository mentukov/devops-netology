### playbook

- Установка ClickHouse:
          - clickhouse-common-static
          - clickhouse-client
          - clickhouse-server
- и установка Vector

### Какие у него есть параметры 

- IP серверов нужно задать в файле inventory\prod.yml
- Отредактировать версии ПО - group_vars\clickhouse\vars.yaml и group_vars\vector\vars.yaml
