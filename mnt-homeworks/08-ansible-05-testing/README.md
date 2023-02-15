# Домашнее задание к занятию "5. Тестирование roles"

## Подготовка к выполнению
1. Установите molecule: `pip3 install "molecule==3.5.2"`

```
(my_env) mentukov@ubuntu:~$ molecule --version
molecule 3.5.2 using python 3.8 
    ansible:2.13.7
    delegated:3.5.2 from molecule
```

2. Выполните `docker pull aragast/netology:latest` -  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри

```
mentukov@ubuntu:~$ sudo docker pull aragast/netology:latest 
latest: Pulling from aragast/netology
f70d60810c69: Pull complete 
545277d80005: Pull complete 
3787740a304b: Pull complete 
8099be4bd6d4: Pull complete 
78316366859b: Pull complete 
a887350ff6d8: Pull complete 
8ab90b51dc15: Pull complete 
14617a4d32c2: Pull complete 
b868affa868e: Pull complete 
1e0b58337306: Pull complete 
9167ab0cbb7e: Pull complete 
907e71e165dd: Pull complete 
6025d523ea47: Pull complete 
6084c8fa3ce3: Pull complete 
cffe842942c7: Pull complete 
d984a1f47d62: Pull complete 
Digest: sha256:e44f93d3d9880123ac8170d01bd38ea1cd6c5174832b1782ce8f97f13e695ad5
Status: Downloaded newer image for aragast/netology:latest
docker.io/aragast/netology:latest

```

## Основная часть

Наша основная цель - настроить тестирование наших ролей. Задача: сделать сценарии тестирования для vector. Ожидаемый результат: все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos7` внутри корневой директории clickhouse-role, посмотрите на вывод команды.
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.

```
mentukov@ubuntu:~/vector-role$ molecule init scenario -d docker
INFO     Initializing new scenario default...
INFO     Initialized scenario in /home/mentukov/vector-role/molecule/default successfully.
mentukov@ubuntu:~/vector-role$ molecule init scenario ubuntu_latest --driver-name docker
INFO     Initializing new scenario ubuntu_latest...
INFO     Initialized scenario in /home/mentukov/vector-role/molecule/ubuntu_latest successfully.
mentukov@ubuntu:~/vector-role$ molecule init scenario centos8 --driver-name docker
INFO     Initializing new scenario centos8...
INFO     Initialized scenario in /home/mentukov/vector-role/molecule/centos8 successfully.
```

4. Добавьте несколько assert'ов в verify.yml файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска, etc). Запустите тестирование роли повторно и проверьте, что оно прошло успешно.

```
(my_env) mentukov@vector:~/vector$ molecule test -s ubuntu_latest
INFO     ubuntu_latest scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/home/mentukov/.cache/ansible-compat/b0d51c/modules:/home/mentukov/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/mentukov/.cache/ansible-compat/b0d51c/collections:/home/mentukov/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/mentukov/.cache/ansible-compat/b0d51c/roles:/home/mentukov/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /home/mentukov/.cache/ansible-compat/b0d51c/roles/mentukov.vector symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running ubuntu_latest > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running ubuntu_latest > lint
INFO     Lint is disabled.
INFO     Running ubuntu_latest > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running ubuntu_latest > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running ubuntu_latest > syntax

playbook: /home/mentukov/vector/molecule/ubuntu_latest/converge.yml
INFO     Running ubuntu_latest > create

PLAY [Create] ******************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}) 

TASK [Synchronization the context] *********************************************
skipping: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}) 

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/quay.io/centos/centos:stream8) 

TASK [Create docker network(s)] ************************************************

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '884000749177.29166', 'results_file': '/home/mentukov/.ansible_async/884000749177.29166', 'changed': True, 'item': {'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=2    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running ubuntu_latest > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running ubuntu_latest > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include vector] **********************************************************

TASK [vector : Get vector distrib] *********************************************
changed: [instance]

TASK [vector : Install vector packages] ****************************************
changed: [instance]

TASK [vector : Create vector config file] **************************************
changed: [instance]

TASK [vector : Vector systemd unit] ********************************************
changed: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running ubuntu_latest > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include vector] **********************************************************

TASK [vector : Get vector distrib] *********************************************
ok: [instance]

TASK [vector : Install vector packages] ****************************************
ok: [instance]

TASK [vector : Create vector config file] **************************************
ok: [instance]

TASK [vector : Vector systemd unit] ********************************************
ok: [instance]

PLAY RECAP *********************************************************************
instance                   : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running ubuntu_latest > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running ubuntu_latest > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Example assertion] *******************************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
instance                   : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running ubuntu_latest > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running ubuntu_latest > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```

несколько assert'ов в verify.yml

```
---
# This is an example playbook to execute Ansible tests.

- name: Verify
  hosts: all
  gather_facts: false
  tasks:
  - name: Example assertion
    assert:
      that: true
  - name: Check NGINX configs
    shell: vector validate --no-environment --config-yaml /etc/vector/vector.yml
  - name: Check NGINX status
    shell: ps aux | grep [v]ector
```

5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

https://github.com/mentukov/vector-role/tree/v0.0.2

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example)
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo - путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini` для того чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на  ваш репозиторий и скриншоты этапов выполнения задания. 