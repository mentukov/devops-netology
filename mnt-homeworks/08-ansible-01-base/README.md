# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
#### 1. Установите ansible версии 2.10 или выше.

```
mentukov@ubuntu:~/devops-netology/mnt-homeworks/08-ansible-01-base$ ansible --version
ansible 2.9.6
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/mentukov/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Nov 14 2022, 12:59:47) [GCC 9.4.0]
```

## Основная часть
#### 1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

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

#### 3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

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

#### 4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

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

#### 5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.

```
$ cat group_vars/deb/examp.yml 
---
  some_fact: "deb default fact"

$ cat group_vars/el/examp.yml 
---
  some_fact: "el default fact"
```

#### 6. Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

```
vagrant@dev-ansible:~/devops-netology-tests/ansible/81$ sudo ansible-playbook -i inventory/prod.yml -v site.yml
Using /etc/ansible/ansible.cfg as config file

PLAY [Print os facts] ******************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **********************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *****************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

#### 7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

```
vagrant@dev-ansible:~/devops-netology-tests/ansible/81$ ansible-vault encrypt group_vars/deb/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
vagrant@dev-ansible:~/devops-netology-tests/ansible/81$ ansible-vault encrypt group_vars/el/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
```

#### 8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

```
vagrant@dev-ansible:~/devops-netology-tests/ansible/81$ sudo ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] ******************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **********************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *****************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


#### 9.  Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

ansible-doc -t connection -l
-> local

#### 10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

```
$ cat inventory/prod.yml 
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

#### 11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

```
vagrant@dev-ansible:~/devops-netology-tests/ansible/81$ sudo ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pas
s
Vault password:

PLAY [Print os facts] ******************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **********************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP *****************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

При добавлении group_vars для local, получаем local default fact 

```
vagrant@dev-ansible:~/devops-netology-tests/ansible/81$ sudo ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] ******************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **********************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "local default fact"
}

PLAY RECAP *****************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

#### 12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

Доступно по ссылке ниже:
https://github.com/skurudo/devops-netology-tests/tree/master/ansible/81


## Необязательная часть

#### 1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.

```
vagrant@dev-ansible:~/devops-netology-tests/ansible/81$ sudo ansible-vault decrypt --ask-vault-password group_vars/deb/* group_vars/el/*

Vault password:
Decryption successful
```

#### 2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.

```
vagrant@dev-ansible:~/devops-netology-tests/ansible/81$ sudo ansible-vault encrypt_string "PaSSw0rd"
New Vault password:
Confirm New Vault password:
Encryption successful
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          64366662376566633937653932663866393432613164366339353934303764373362303037376161
          6365346566613338636130333130356166393464353833630a343835353037343231333930643962
          65646462313661363866353937613461303739646137316666396265363435366534633730343135
          6630643132393934310a356333616361396435303366623930353237656465626236336465633035
          3066
```

```
vagrant@dev-ansible:~/devops-netology-tests/ansible/81$ cat group_vars/all/examp.yml
---
  some_fact: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          64366662376566633937653932663866393432613164366339353934303764373362303037376161
          6365346566613338636130333130356166393464353833630a343835353037343231333930643962
          65646462313661363866353937613461303739646137316666396265363435366534633730343135
          6630643132393934310a356333616361396435303366623930353237656465626236336465633035
          3066
```

#### 3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.

```
vagrant@dev-ansible:~/devops-netology-tests/ansible/81$ rm -rf group_vars/local
vagrant@dev-ansible:~/devops-netology-tests/ansible/81$ sudo ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] *****************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************************************************************************************
ok: [ubuntu]
ok: [localhost]
ok: [centos7]

TASK [Print OS] ***********************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *********************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP ****************************************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


#### 4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).

Запустим доп контейнер

```
sudo docker run --name fedora -d pycontribs/fedora:latest sleep 36000000
```

Добавим в инвентори и груп_ворс

```
$ cat  /home/vagrant/devops-netology-tests/ansible/81/inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  fedor:
    hosts:
      fedora:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
```

```
vagrant@dev-ansible:~/devops-netology-tests/ansible/81$ cat group_vars/fedor/examp.yml
---
  some_fact: "fedor default facts"
```

```
vagrant@dev-ansible:~/devops-netology-tests/ansible/81$ sudo ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] *****************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************************************************************************************
ok: [localhost]
ok: [fedora]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ***********************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [fedora] => {
    "msg": "Fedora"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *********************************************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [fedora] => {
    "msg": "fedor default facts"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP ****************************************************************************************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```


#### 5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.

Пропустил.. не очень понятно - каких автоматизации необходимы? если всех контейнеры подряд, то это перечисление команд из ДЗ в чистом виде по кругу.

#### 6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

```
vagrant@dev-ansible:~/devops-netology-tests$ git add .
vagrant@dev-ansible:~/devops-netology-tests$ git commit -m "second part"
[master 1e9e54f] second part
 6 files changed, 18 insertions(+), 18 deletions(-)
 rewrite ansible/81/group_vars/all/examp.yml (88%)
 rewrite ansible/81/group_vars/deb/examp.yml (100%)
 rewrite ansible/81/group_vars/el/examp.yml (100%)
 create mode 100644 ansible/81/group_vars/fedor/examp.yml
 delete mode 100644 ansible/81/group_vars/local/examp.yml
vagrant@dev-ansible:~/devops-netology-tests$ git push
Enumerating objects: 27, done.
Counting objects: 100% (27/27), done.
Delta compression using up to 2 threads
Compressing objects: 100% (8/8), done.
Writing objects: 100% (15/15), 1.26 KiB | 161.00 KiB/s, done.
Total 15 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To github.com:skurudo/devops-netology-tests.git
   9dea2bb..1e9e54f  master -> master
```