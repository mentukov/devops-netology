# Домашнее задание к занятию "6.Создание собственных модулей"

## Подготовка к выполнению
1. Создайте пустой публичных репозиторий в любом своём проекте: `my_own_collection`
2. Скачайте репозиторий ansible: `git clone https://github.com/ansible/ansible.git` по любому удобному вам пути
3. Зайдите в директорию ansible: `cd ansible`
4. Создайте виртуальное окружение: `python3 -m venv venv`
5. Активируйте виртуальное окружение: `. venv/bin/activate`. Дальнейшие действия производятся только в виртуальном окружении
6. Установите зависимости `pip install -r requirements.txt`
7. Запустить настройку окружения `. hacking/env-setup`
8. Если все шаги прошли успешно - выйти из виртуального окружения `deactivate`
9. Ваше окружение настроено, для того чтобы запустить его, нужно находиться в директории `ansible` и выполнить конструкцию `. venv/bin/activate && . hacking/env-setup`

```
mentukov@ubuntu:~$ mkdir test
mentukov@ubuntu:~$ cd test/
mentukov@ubuntu:~/test$ sudo apt install libffi-dev python-dev
mentukov@ubuntu:~/test$ sudo apt install python3-venv
mentukov@ubuntu:~/test$ git clone https://github.com/ansible/ansible.git
mentukov@ubuntu:~/test$ cd ansible/
mentukov@ubuntu:~/test/ansible$ python3 -m venv venv
mentukov@ubuntu:~/test/ansible$ . venv/bin/activate
(venv) mentukov@ubuntu:~/test/ansible$ pip install -r requirements.txt
(venv) mentukov@ubuntu:~/test/ansible$ . hacking/env-setup
(venv) mentukov@ubuntu:~/test/ansible$ deactivate 

```

## Основная часть

Наша цель - написать собственный module, который мы можем использовать в своей role, через playbook. Всё это должно быть собрано в виде collection и отправлено в наш репозиторий.

1. В виртуальном окружении создать новый `my_own_module.py` файл
2. Наполнить его содержимым:

...

Или возьмите данное наполнение из [статьи](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html#creating-a-module).

```
(venv) mentukov@ubuntu:~/test/ansible$ deactivate 
mentukov@ubuntu:~/test/ansible$ . venv/bin/activate && . hacking/env-setup
running egg_info
creating lib/ansible_core.egg-info
writing lib/ansible_core.egg-info/PKG-INFO
writing dependency_links to lib/ansible_core.egg-info/dependency_links.txt
writing entry points to lib/ansible_core.egg-info/entry_points.txt
writing requirements to lib/ansible_core.egg-info/requires.txt
writing top-level names to lib/ansible_core.egg-info/top_level.txt
writing manifest file 'lib/ansible_core.egg-info/SOURCES.txt'
reading manifest file 'lib/ansible_core.egg-info/SOURCES.txt'
reading manifest template 'MANIFEST.in'
warning: no files found matching 'SYMLINK_CACHE.json'
warning: no previously-included files found matching 'docs/docsite/rst_warnings'
warning: no previously-included files found matching 'docs/docsite/rst/conf.py'
warning: no previously-included files found matching 'docs/docsite/rst/index.rst'
warning: no previously-included files found matching 'docs/docsite/rst/dev_guide/index.rst'
warning: no previously-included files matching '*' found under directory 'docs/docsite/_build'
warning: no previously-included files matching '*.pyc' found under directory 'docs/docsite/_extensions'
warning: no previously-included files matching '*.pyo' found under directory 'docs/docsite/_extensions'
warning: no files found matching '*.ps1' under directory 'lib/ansible/modules/windows'
warning: no files found matching '*.yml' under directory 'lib/ansible/modules'
warning: no files found matching 'validate-modules' under directory 'test/lib/ansible_test/_util/controller/sanity/validate-modules'
writing manifest file 'lib/ansible_core.egg-info/SOURCES.txt'

Setting up Ansible to run out of checkout...

PATH=/home/mentukov/test/ansible/bin:/home/mentukov/test/ansible/venv/bin:/home/mentukov/.local/bin:/home/mentukov/bin:/home/mentukov/yandex-cloud/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
PYTHONPATH=/home/mentukov/test/ansible/test/lib:/home/mentukov/test/ansible/lib:/home/mentukov/test/ansible/test/lib:/home/mentukov/test/ansible/lib
MANPATH=/home/mentukov/test/ansible/docs/man:/usr/local/man:/usr/local/share/man:/usr/share/man

Remember, you may wish to specify your host file with -i

Done!

(venv) mentukov@ubuntu:~/test/ansible$ cd lib/ansible/modules
(venv) mentukov@ubuntu:~/test/ansible/lib/ansible/modules$ nano my_own_module.py
(venv) mentukov@ubuntu:~/test/ansible/lib/ansible/modules$ chmod +x my_own_module.py
```

3. Заполните файл в соответствии с требованиями ansible так, чтобы он выполнял основную задачу: module должен создавать текстовый файл на удалённом хосте по пути, определённом в параметре `path`, с содержимым, определённым в параметре `content`.
4. Проверьте module на исполняемость локально.

```
(venv) mentukov@ubuntu:~/test/ansible/lib/ansible/modules$ nano payload.json
(venv) mentukov@ubuntu:~/test/ansible/lib/ansible/modules$ cat payload.json 
{
  "ANSIBLE_MODULE_ARGS": {
    "name": "Hello.txt",
    "path": "/tmp/my_own_files",
    "content": "Test content",
    "force": false
  }
}
(venv) mentukov@ubuntu:~/test/ansible$ python -m ansible.modules.my_own_module payload.json

{"changed": true, "original_message": "Successful created", "message": "End", "path": "/tmp/my_own_files", "content": "Test content", "uid": 1000, "gid": 1000, "owner": "mentukov", "group": "mentukov", "mode": "0775", "state": "directory", "size": 4096, "invocation": {"module_args": {"name": "Hello.txt", "path": "/tmp/my_own_files", "content": "Test content", "force": false}}}
(venv) mentukov@ubuntu:~/test/ansible$ cat /tmp/my_own_files/Hello.txt 
Test content
```

5. Напишите single task playbook и используйте module в нём.

```
(venv) mentukov@ubuntu:~/test/ansible$ cat playbook/site.yml 
---
- name: Create file whis some content
  hosts: localhost
  tasks:
  - name: run my_own_module
    my_own_module:
      name: "HelloWorld.txt"
      path: "/tmp/module_test"
      content: "Netology students\n"
    register: testout
  - name: print testout
    debug:
      msg: '{{ testout }}'
(venv) mentukov@ubuntu:~/test/ansible$ ./hacking/test-module.py -m lib/ansible/modules/my_own_module.py
* including generated source, if any, saving to: /home/mentukov/.ansible_module_generated
* ansiballz module detected; extracted module source to: /home/mentukov/debug_dir
***********************************
RAW OUTPUT

{"failed": true, "msg": "missing required arguments: content, path", "invocation": {"module_args": {"name": "example", "force": false, "path": null, "content": null}}}


***********************************
PARSED OUTPUT
{
    "failed": true,
    "invocation": {
        "module_args": {
            "content": null,
            "force": false,
            "name": "example",
            "path": null
        }
    },
    "msg": "missing required arguments: content, path"

```

6. Проверьте через playbook на идемпотентность.

```
(venv) mentukov@ubuntu:~/test/ansible$ ansible-playbook playbook/site.yml
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible
engine, or trying out features under development. This is a rapidly changing source of code and can become unstable at any point.
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Create file whis some content] *******************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [localhost]

TASK [run my_own_module] *******************************************************************************************************************
changed: [localhost]

TASK [print testout] ***********************************************************************************************************************
ok: [localhost] => {
    "msg": {
        "changed": true,
        "content": "Netology students\n",
        "failed": false,
        "gid": 1000,
        "group": "mentukov",
        "message": "End",
        "mode": "0775",
        "original_message": "Successful created",
        "owner": "mentukov",
        "path": "/tmp/module_test",
        "size": 4096,
        "state": "directory",
        "uid": 1000
    }
}

PLAY RECAP *********************************************************************************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

7. Выйдите из виртуального окружения.
8. Инициализируйте новую collection: `ansible-galaxy collection init my_own_namespace.yandex_cloud_elk`

```
mentukov@ubuntu:~/test/ansible$ ansible-galaxy collection init my_own_namespace.yandex_cloud_elk
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible
engine, or trying out features under development. This is a rapidly changing source of code and can become unstable at any point.
- Collection my_own_namespace.yandex_cloud_elk was created successfully
```

9. В данную collection перенесите свой module в соответствующую директорию.

```
mentukov@ubuntu:~/test/ansible/my_own_namespace$ tree
.
└── yandex_cloud_elk
    ├── docs
    ├── galaxy.yml
    ├── meta
    │----└── runtime.yml
    ├── plugins
    │---------├── modules
    │---------|---- └── my_own_module.py
    │---------└── README.md
    ├── README.md
    └── roles

```

10. Single task playbook преобразуйте в single task role и перенесите в collection. У role должны быть default всех параметров module
11. Создайте playbook для использования этой role.

```
mentukov@ubuntu:~/test/ansible/my_own_namespace$ tree
.
└── yandex_cloud_elk
    ├── docs
    ├── galaxy.yml
    ├── meta
    │    └── runtime.yml
    ├── my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz
    ├── plugins
    │     ├── modules
    │     │   └── my_own_module.py
    │     └── README.md
    ├── README.md
    └── roles
        ├── defaults
        │   └── main.yml
        ├── handlers
        │   └── main.yml
        ├── meta
        │   └── main.yml
        ├── tasks
        │   └── main.yml
        └── vars
            └── main.yml
mentukov@ubuntu:~/test/ansible/playbook$ tree
.
├── inventories
│    └── prod
│         └── hosts.yml
├── requirements.yml
└── site.yml
```

12. Заполните всю документацию по collection, выложите в свой репозиторий, поставьте тег `1.0.0` на этот коммит.

https://github.com/mentukov/yandex_cloud_elk/tree/1.0.0

13. Создайте .tar.gz этой collection: `ansible-galaxy collection build` в корневой директории collection.

```
mentukov@ubuntu:~/test/ansible/my_own_namespace/yandex_cloud_elk$ ansible-galaxy collection build
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible
engine, or trying out features under development. This is a rapidly changing source of code and can become unstable at any point.
Created collection for my_own_namespace.yandex_cloud_elk at /home/mentukov/test/ansible/my_own_namespace/yandex_cloud_elk/my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz
```

14. Создайте ещё одну директорию любого наименования, перенесите туда single task playbook и архив c collection.
15. Установите collection из локального архива: `ansible-galaxy collection install <archivename>.tar.gz`

```
mentukov@ubuntu:~/test/testplay$ ls
my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz  playbook
mentukov@ubuntu:~/test/testplay$ ansible-galaxy collection install -p collections my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz 
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible
engine, or trying out features under development. This is a rapidly changing source of code and can become unstable at any point.
Starting galaxy collection install process
[WARNING]: The specified collections path '/home/mentukov/test/testplay/collections' is not part of the configured Ansible collections
paths '/home/mentukov/.ansible/collections:/usr/share/ansible/collections'. The installed collection will not be picked up in an Ansible
run, unless within a playbook-adjacent collections directory.
Process install dependency map
Starting collection install process
Installing 'my_own_namespace.yandex_cloud_elk:1.0.0' to '/home/mentukov/test/testplay/collections/ansible_collections/my_own_namespace/yandex_cloud_elk'
my_own_namespace.yandex_cloud_elk:1.0.0 was installed successfully
```

16. Запустите playbook, убедитесь, что он работает.

```
mentukov@ubuntu:~/test/testplay$sudo ansible-playbook playbook/site.yml -i playbook/inventories/prod/hosts.yml

PLAY [Playbook for my own collection] ******************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [my_own_namespace.yandex_cloud_elk.my_own_role : Run the module my_own_module] ***
changed: [localhost]

TASK [my_own_namespace.yandex_cloud_elk.my_own_role : dump test output] *******
ok: [localhost] => {
    "msg": {
        "changed": true,
        "content": "Content for my module",
        "failed": false,
        "gid": 0,
        "group": "root",
        "message": "End",
        "mode": "0755",
        "original_message": "Successful created",
        "owner": "root",
        "path": "/tmp/my_own_files/",
        "size": 4096,
        "state": "directory",
        "uid": 0
    }
}

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

17. В ответ необходимо прислать ссылки на collection и tar.gz архив, а также скриншоты выполнения пунктов 4, 6, 15 и 16.

https://github.com/mentukov/yandex_cloud_elk/tree/1.0.0




### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---