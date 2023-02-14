# Домашнее задание к занятию "4. Работа с roles"

Роль Vector 

https://github.com/mentukov/vector-role

Роль Lighthouse

https://github.com/mentukov/lighthouse-role

Playbook

https://github.com/mentukov/devops-netology/tree/main/mnt-homeworks/08-ansible-04-roles/playbook

## Playbook

```shell
mentukov@ubuntu:~$ ansible-playbook devops-netology/mnt-homeworks/08-ansible-04-roles/playbook/site.yml -i devops-netology/mnt-homeworks/08-ansible-04-roles/playbook/inventory/prod.yml

PLAY [Install Clickhouse] ******************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Include OS Family Specific Variables] ***********************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] **********************************************************************************************************
included: /home/mentukov/.ansible/roles/clickhouse/tasks/precheck.yml for clickhouse-01

TASK [clickhouse : Requirements check | Checking sse4_2 support] ***************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Requirements check | Not supported distribution && release] *************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : include_tasks] **********************************************************************************************************
included: /home/mentukov/.ansible/roles/clickhouse/tasks/params.yml for clickhouse-01

TASK [clickhouse : Set clickhouse_service_enable] ******************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Set clickhouse_service_ensure] ******************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] **********************************************************************************************************
included: /home/mentukov/.ansible/roles/clickhouse/tasks/install/yum.yml for clickhouse-01

TASK [clickhouse : Install by YUM | Ensure clickhouse repo GPG key imported] ***************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Install by YUM | Ensure clickhouse repo installed] **********************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Install by YUM | Ensure clickhouse package installed (latest)] **********************************************************
ok: [clickhouse-01]

TASK [clickhouse : Install by YUM | Ensure clickhouse package installed (version latest)] **************************************************
skipping: [clickhouse-01]

TASK [clickhouse : include_tasks] **********************************************************************************************************
included: /home/mentukov/.ansible/roles/clickhouse/tasks/configure/sys.yml for clickhouse-01

TASK [clickhouse : Check clickhouse config, data and logs] *********************************************************************************
ok: [clickhouse-01] => (item=/var/log/clickhouse-server)
ok: [clickhouse-01] => (item=/etc/clickhouse-server)
ok: [clickhouse-01] => (item=/var/lib/clickhouse/tmp/)
ok: [clickhouse-01] => (item=/var/lib/clickhouse/)

TASK [clickhouse : Config | Create config.d folder] ****************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Config | Create users.d folder] *****************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Config | Generate system config] ****************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Config | Generate users config] *****************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Config | Generate remote_servers config] ********************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Config | Generate macros config] ****************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Config | Generate zookeeper servers config] *****************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Config | Fix interserver_http_port and intersever_https_port collision] *************************************************
skipping: [clickhouse-01]

TASK [clickhouse : include_tasks] **********************************************************************************************************
included: /home/mentukov/.ansible/roles/clickhouse/tasks/service.yml for clickhouse-01

TASK [clickhouse : Ensure clickhouse-server.service is enabled: True and state: started] ***************************************************
ok: [clickhouse-01]

TASK [clickhouse : Wait for Clickhouse Server to Become Ready] *****************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] **********************************************************************************************************
included: /home/mentukov/.ansible/roles/clickhouse/tasks/configure/db.yml for clickhouse-01

TASK [clickhouse : Set ClickHose Connection String] ****************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Gather list of existing databases] **************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Config | Delete database config] ****************************************************************************************

TASK [clickhouse : Config | Create database config] ****************************************************************************************

TASK [clickhouse : include_tasks] **********************************************************************************************************
included: /home/mentukov/.ansible/roles/clickhouse/tasks/configure/dict.yml for clickhouse-01

TASK [clickhouse : Config | Generate dictionary config] ************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : include_tasks] **********************************************************************************************************
skipping: [clickhouse-01]

PLAY [Install Vector] **********************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [vector-01]

TASK [vector-role : Get vector distrib] ****************************************************************************************************
changed: [vector-01]

TASK [vector-role : Install vector packages] ***********************************************************************************************
changed: [vector-01]

TASK [vector-role : Create vector config file] *********************************************************************************************
[WARNING]: The value 0 (type int) in a string field was converted to u'0' (type string). If this does not look like what you expect, quote
the entire value to ensure it does not change.
changed: [vector-01]

TASK [vector-role : Vector systemd unit] ***************************************************************************************************
changed: [vector-01]

RUNNING HANDLER [vector-role : Start Vector service] ***************************************************************************************
changed: [vector-01]

PLAY [Install lighthouse] ******************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [lighthouse-01]

TASK [Lighthouse | Install git] ************************************************************************************************************
ok: [lighthouse-01]

TASK [lighthouse-role : Install epel-release] **********************************************************************************************
changed: [lighthouse-01]

TASK [lighthouse-role : Install nginx] *****************************************************************************************************
changed: [lighthouse-01]

TASK [lighthouse-role : Create nginx config] ***********************************************************************************************
changed: [lighthouse-01]

TASK [lighthouse-role : Lighthouse | Clone repository] *************************************************************************************
changed: [lighthouse-01]

TASK [lighthouse-role : Create Lighthouse config] ******************************************************************************************
changed: [lighthouse-01]

RUNNING HANDLER [lighthouse-role : Nginx start] ********************************************************************************************
changed: [lighthouse-01]

RUNNING HANDLER [lighthouse-role : Nginx reload] *******************************************************************************************
changed: [lighthouse-01]

PLAY RECAP *********************************************************************************************************************************
clickhouse-01              : ok=24   changed=0    unreachable=0    failed=0    skipped=10   rescued=0    ignored=0   
lighthouse-01              : ok=9    changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
     
