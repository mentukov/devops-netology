# Домашнее задание к занятию "08.01 Введение в Ansible"

#### Установите ansible версии 2.10 или выше.

```
mentukov@ubuntu:~/devops-netology/mnt-homeworks/08-ansible-01-base$ ansible --version
ansible 2.9.6
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/mentukov/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Nov 14 2022, 12:59:47) [GCC 9.4.0]
  
```

#### 1. Попробуйте запустить playbook на окружении из test.yml, зафиксируйте какое значение имеет факт some_fact для указанного хоста при выполнении playbook'a.

```
mentukov@ubuntu:~/devops-netology/mnt-homeworks/08-ansible-01-base/playbook$ ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] **********************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [localhost]

TASK [Print OS] ****************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP *********************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

#### 2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

```
mentukov@ubuntu:~/devops-netology/mnt-homeworks/08-ansible-01-base/playbook$ cat group_vars/all/examp.yml 
---
  some_fact: 12
  
mentukov@ubuntu:~/devops-netology/mnt-homeworks/08-ansible-01-base/playbook$ cat group_vars/all/examp.yml 
---
  some_fact: all default fact
  
```

#### 3. Воспользуйтесь подготовленным (используется docker) или создайте собственное окружение для проведения дальнейших испытаний.

```
mentukov@ubuntu:~/devops-netology/mnt-homeworks/08-ansible-01-base/playbook$ sudo service docker start
[sudo] password for mentukov: 
mentukov@ubuntu:~/devops-netology/mnt-homeworks/08-ansible-01-base/playbook$ sudo service docker status
● docker.service - Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2023-01-31 16:49:59 WITA; 1h 50min ago
     
```

```
mentukov@ubuntu:~/devops-netology/mnt-homeworks/08-ansible-01-base/playbook$ sudo docker ps
CONTAINER ID   IMAGE           COMMAND          CREATED          STATUS          PORTS     NAMES
c7fa2359335f   ubuntu:latest   "sleep 172800"   12 seconds ago   Up 11 seconds             ubuntu
89bad6ea8386   centos:7        "sleep 172800"   55 seconds ago   Up 54 seconds             centos7

```

#### 4. Проведите запуск playbook на окружении из prod.yml. Зафиксируйте полученные значения some_fact для каждого из managed host.

```

mentukov@ubuntu:~/devops-netology/mnt-homeworks/08-ansible-01-base/playbook$ sudo docker exec -ti ubuntu bash
root@0abb011e814e:/# apt-get update
root@0abb011e814e:/# apt-get install python3

mentukov@ubuntu:~/devops-netology/mnt-homeworks/08-ansible-01-base/playbook$ sudo ansible-playbook -i inventory/prod.yml -v site.yml
Using /etc/ansible/ansible.cfg as config file

PLAY [Print os facts] **********************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP *********************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 

```

#### 5. Добавьте факты в group_vars каждой из групп хостов так, чтобы для some_fact получились следующие значения: для deb - 'deb default fact', для el - 'el default fact'.

```
mentukov@ubuntu:~/devops-netology/mnt-homeworks/08-ansible-01-base/playbook$ cat group_vars/deb/examp.yml 
---
  some_fact: "deb default fact"
mentukov@ubuntu:~/devops-netology/mnt-homeworks/08-ansible-01-base/playbook$ cat group_vars/el/examp.yml 
---
  some_fact: "el default fact""
  
```

#### 6. Повторите запуск playbook на окружении prod.yml. Убедитесь, что выдаются корректные значения для всех хостов.

```
mentukov@ubuntu:~/devops-netology/mnt-homeworks/08-ansible-01-base/playbook$ sudo ansible-playbook -i inventory/prod.yml -v site.yml
[sudo] password for mentukov: 
Using /etc/ansible/ansible.cfg as config file

PLAY [Print os facts] **********************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *********************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
 
```

#### 7. При помощи ansible-vault зашифруйте факты в group_vars/deb и group_vars/el с паролем netology.

```
mentukov@ubuntu:~/devops-netology/mnt-homeworks/08-ansible-01-base/playbook$ ansible-vault encrypt group_vars/deb/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
mentukov@ubuntu:~/devops-netology/mnt-homeworks/08-ansible-01-base/playbook$ ansible-vault encrypt group_vars/el/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful

```

#### 8. Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь в работоспособности.

```
mentukov@ubuntu:~/devops-netology/mnt-homeworks/08-ansible-01-base/playbook$ sudo ansible-playbook -i inventory/prod.yml -v site.yml
Using /etc/ansible/ansible.cfg as config file

PLAY [Print os facts] **********************************************************************************************************************
ERROR! Attempting to decrypt but no vault secrets found
mentukov@ubuntu:~/devops-netology/mnt-homeworks/08-ansible-01-base/playbook$ sudo ansible-playbook -i inventory/prod.yml -v site.yml --ask-vault-pass
Using /etc/ansible/ansible.cfg as config file
Vault password: 

PLAY [Print os facts] **********************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *********************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```


#### 9.  Посмотрите при помощи ansible-doc список плагинов для подключения. Выберите подходящий для работы на control node.

ansible-doc -t connection -l
-> local

#### 10. В prod.yml добавьте новую группу хостов с именем local, в ней разместите localhost с необходимым типом подключения.

```
mentukov@ubuntu:~/devops-netology/mnt-homeworks/08-ansible-01-base/playbook$ cat inventory/prod.yml 
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local

```

#### 11. Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь что факты some_fact для каждого из хостов определены из верных group_vars.

```
mentukov@ubuntu:~/devops-netology/mnt-homeworks/08-ansible-01-base/playbook$ sudo ansible-playbook -i inventory/prod.yml -v site.yml --ask-vault-pass
Using /etc/ansible/ansible.cfg as config file
Vault password: 

PLAY [Print os facts] **********************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [ubuntu]
ok: [localhost]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}

PLAY RECAP *********************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 

```

#### 12. Заполните README.md ответами на вопросы. Сделайте git push в ветку master. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым playbook и заполненным README.md.

Доступно по ссылке ниже:
