# Домашнее задание к занятию "5.4. Оркестрация группой Docker контейнеров на примере Docker Compose"

## Задача 1

Создать собственный образ операционной системы с помощью Packer.

Для получения зачета, вам необходимо предоставить:
- Скриншот страницы, как на слайде из презентации (слайд 37).
```shell
➜  ~ yc --version
Yandex Cloud CLI 0.91.0 darwin/amd64

➜  ~ brew install hashicorp/tap/packer
==> Downloading https://releases.hashicorp.com/packer/1.8.2/packer_1.8.2_darwin_amd64.zip
######################################################################## 100.0%
==> Installing packer from hashicorp/tap
🍺  /usr/local/Cellar/packer/1.8.2: 3 files, 179.2MB, built in 13 seconds
==> Running `brew cleanup packer`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
➜  ~ packer --version
1.8.2

➜  ~ brew install terraform
==> Downloading https://ghcr.io/v2/homebrew/core/terraform/manifests/1.2.4
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/terraform/blobs/sha256:ba5e1d87d5fcf97aa31fdb74a87363c060a940dabfac07e8465f1363bb38d341
==> Downloading from https://pkg-containers.githubusercontent.com/ghcr1/blobs/sha256:ba5e1d87d5fcf97aa31fdb74a87363c060a940dabfac07e8465f136
######################################################################## 100.0%
==> Pouring terraform--1.2.4.catalina.bottle.tar.gz
🍺  /usr/local/Cellar/terraform/1.2.4: 6 files, 66.8MB
==> Running `brew cleanup terraform`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
➜  ~ terraform --version
Terraform v1.2.4
on darwin_amd64

➜  ~ cd Devops 
➜  Devops cd devops-netology/virt-homeworks/05-virt-04-docker-compose/src 
➜  src git:(main) ✗ ls
ansible   packer    terraform
➜  src git:(main) ✗ tree
.
├── ansible
│   ├── ansible.cfg
│   ├── inventory
│   ├── provision.yml
│   └── stack
│       ├── alertmanager
│       │   └── config.yml
│       ├── caddy
│       │   └── Caddyfile
│       ├── docker-compose.yaml
│       ├── exporters
│       │   └── docker-compose.exporters.yaml
│       ├── grafana
│       │   └── provisioning
│       │       ├── dashboards
│       │       │   ├── dashboard.yml
│       │       │   ├── general_docker_host.json
│       │       │   └── general_monitor_services.json
│       │       └── datasources
│       │           └── datasource.yml
│       └── prometheus
│           ├── alert.rules
│           └── prometheus.yml
├── packer
│   └── centos-7-base.json
└── terraform
    ├── network.tf
    ├── node01.tf
    ├── output.tf
    ├── provider.tf
    └── variables.tf

12 directories, 19 files

➜  src git:(main) ✗ yc init
Welcome! This command will take you through the configuration process.
Please go to https://oauth.yandex.ru/authorize?response_type=token&client_id= in order to obtain OAuth token.

Please enter OAuth token: 
You have one cloud available: 'cloud-alexey-mentukov' (id = ). It is going to be used by default.
Please choose folder to use:
 [1] default (id = )
 [2] Create a new folder
Please enter your numeric choice: 1
Your current folder has been set to 'default' (id = ).
Do you want to configure a default Compute zone? [Y/n] y
Which zone do you want to use as a profile default?
 [1] ru-central1-a
 [2] ru-central1-b
 [3] ru-central1-c
 [4] Don't set default zone
Please enter your numeric choice: 1
Your profile default Compute zone has been set to 'ru-central1-a'.

➜  src git:(main) ✗ yc config list
token: 
cloud-id: 
folder-id: 
compute-default-zone: ru-central1-a

➜  src git:(main) ✗ yc vpc network create \
     --name net \
     --labels my-label=netology \
     --description "network for netology"   
id: 
folder_id: 
created_at: "2022-07-04T08:39:24Z"
name: net
description: network for netology
labels:
  my-label: netology

➜  src git:(main) ✗ yc vpc subnet create \
    --name My-test-subnet \
    --zone ru-central1-a \
    --range 192.168.94.0/24 \
    --network-name net \
    --description "network for netology"
id: 
folder_id: 
created_at: "2022-07-04T08:44:21Z"
name: My-test-subnet
description: network for netology
network_id: 
zone_id: ru-central1-a
v4_cidr_blocks:
- 192.168.94.0/24

➜  src git:(main) ✗ nano ./packer/centos-7-base.json
➜  src git:(main) ✗ cd packer 
➜  packer git:(main) ✗ ls
centos-7-base.json
➜  packer git:(main) ✗ packer validate centos-7-base.json
The configuration is valid.

➜  packer git:(main) ✗ packer build centos-7-base.json
yandex: output will be in this color.

==> yandex: Creating temporary RSA SSH key for instance...
==> yandex: Using as source image:  (name: "centos-7-v20220620", family: "centos-7")
==> yandex: Use provided subnet id 
==> yandex: Creating disk...
==> yandex: Creating instance...
==> yandex: Waiting for instance with id  to become active...
    yandex: Detected instance IP: 51.250.67.20
==> yandex: Using SSH communicator to connect: 51.250.67.20
==> yandex: Waiting for SSH to become available...
==> yandex: Connected to SSH!
==> yandex: Provisioning with shell script: /var/folders/jg/.../T/packer-shell1886220565
    yandex: Loaded plugins: fastestmirror
    yandex: Determining fastest mirrors
    yandex:  * base: mirror.corbina.net
    yandex:  * extras: mirrors.datahouse.ru
    yandex:  * updates: mirror.corbina.net
    yandex: Resolving Dependencies
    yandex: --> Running transaction check
    yandex: ---> Package kernel.x86_64 0:3.10.0-1160.71.1.el7 will be installed
    yandex: ---> Package kernel-tools.x86_64 0:3.10.0-1160.66.1.el7 will be updated
    yandex: ---> Package kernel-tools.x86_64 0:3.10.0-1160.71.1.el7 will be an update
    yandex: ---> Package kernel-tools-libs.x86_64 0:3.10.0-1160.66.1.el7 will be updated
    yandex: ---> Package kernel-tools-libs.x86_64 0:3.10.0-1160.71.1.el7 will be an update
    yandex: ---> Package krb5-libs.x86_64 0:1.15.1-51.el7_9 will be updated
    yandex: ---> Package krb5-libs.x86_64 0:1.15.1-54.el7_9 will be an update
    yandex: ---> Package python.x86_64 0:2.7.5-90.el7 will be updated
    yandex: ---> Package python.x86_64 0:2.7.5-92.el7_9 will be an update
    yandex: ---> Package python-libs.x86_64 0:2.7.5-90.el7 will be updated
    yandex: ---> Package python-libs.x86_64 0:2.7.5-92.el7_9 will be an update
    yandex: ---> Package python-perf.x86_64 0:3.10.0-1160.66.1.el7 will be updated
    yandex: ---> Package python-perf.x86_64 0:3.10.0-1160.71.1.el7 will be an update
    yandex: --> Finished Dependency Resolution
    yandex:
    yandex: Dependencies Resolved
    yandex:
    yandex: ================================================================================
    yandex:  Package               Arch       Version                     Repository   Size
    yandex: ================================================================================
    yandex: Installing:
    yandex:  kernel                x86_64     3.10.0-1160.71.1.el7        updates      50 M
    yandex: Updating:
    yandex:  kernel-tools          x86_64     3.10.0-1160.71.1.el7        updates     8.2 M
    yandex:  kernel-tools-libs     x86_64     3.10.0-1160.71.1.el7        updates     8.1 M
    yandex:  krb5-libs             x86_64     1.15.1-54.el7_9             updates     810 k
    yandex:  python                x86_64     2.7.5-92.el7_9              updates      96 k
    yandex:  python-libs           x86_64     2.7.5-92.el7_9              updates     5.6 M
    yandex:  python-perf           x86_64     3.10.0-1160.71.1.el7        updates     8.2 M
    yandex:
    yandex: Transaction Summary
    yandex: ================================================================================
    yandex: Install  1 Package
    yandex: Upgrade  6 Packages
    yandex:
    yandex: Total download size: 81 M
    yandex: Downloading packages:
    yandex: Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
    yandex: --------------------------------------------------------------------------------
    yandex: Total                                               43 MB/s |  81 MB  00:01
    yandex: Running transaction check
    yandex: Running transaction test
    yandex: Transaction test succeeded
    yandex: Running transaction
    yandex:   Updating   : python-libs-2.7.5-92.el7_9.x86_64                           1/13
    yandex:   Updating   : python-2.7.5-92.el7_9.x86_64                                2/13
    yandex:   Updating   : kernel-tools-libs-3.10.0-1160.71.1.el7.x86_64               3/13
    yandex:   Updating   : kernel-tools-3.10.0-1160.71.1.el7.x86_64                    4/13
    yandex:   Updating   : python-perf-3.10.0-1160.71.1.el7.x86_64                     5/13
    yandex:   Updating   : krb5-libs-1.15.1-54.el7_9.x86_64                            6/13
    yandex:   Installing : kernel-3.10.0-1160.71.1.el7.x86_64                          7/13
    yandex:   Cleanup    : python-perf-3.10.0-1160.66.1.el7.x86_64                     8/13
    yandex:   Cleanup    : python-2.7.5-90.el7.x86_64                                  9/13
    yandex:   Cleanup    : kernel-tools-3.10.0-1160.66.1.el7.x86_64                   10/13
    yandex:   Cleanup    : kernel-tools-libs-3.10.0-1160.66.1.el7.x86_64              11/13
    yandex:   Cleanup    : python-libs-2.7.5-90.el7.x86_64                            12/13
    yandex:   Cleanup    : krb5-libs-1.15.1-51.el7_9.x86_64                           13/13
    yandex:   Verifying  : kernel-tools-libs-3.10.0-1160.71.1.el7.x86_64               1/13
    yandex:   Verifying  : python-libs-2.7.5-92.el7_9.x86_64                           2/13
    yandex:   Verifying  : python-perf-3.10.0-1160.71.1.el7.x86_64                     3/13
    yandex:   Verifying  : python-2.7.5-92.el7_9.x86_64                                4/13
    yandex:   Verifying  : kernel-3.10.0-1160.71.1.el7.x86_64                          5/13
    yandex:   Verifying  : krb5-libs-1.15.1-54.el7_9.x86_64                            6/13
    yandex:   Verifying  : kernel-tools-3.10.0-1160.71.1.el7.x86_64                    7/13
    yandex:   Verifying  : kernel-tools-libs-3.10.0-1160.66.1.el7.x86_64               8/13
    yandex:   Verifying  : python-libs-2.7.5-90.el7.x86_64                             9/13
    yandex:   Verifying  : kernel-tools-3.10.0-1160.66.1.el7.x86_64                   10/13
    yandex:   Verifying  : python-2.7.5-90.el7.x86_64                                 11/13
    yandex:   Verifying  : python-perf-3.10.0-1160.66.1.el7.x86_64                    12/13
    yandex:   Verifying  : krb5-libs-1.15.1-51.el7_9.x86_64                           13/13
    yandex:
    yandex: Installed:
    yandex:   kernel.x86_64 0:3.10.0-1160.71.1.el7
    yandex:
    yandex: Updated:
    yandex:   kernel-tools.x86_64 0:3.10.0-1160.71.1.el7
    yandex:   kernel-tools-libs.x86_64 0:3.10.0-1160.71.1.el7
    yandex:   krb5-libs.x86_64 0:1.15.1-54.el7_9
    yandex:   python.x86_64 0:2.7.5-92.el7_9
    yandex:   python-libs.x86_64 0:2.7.5-92.el7_9
    yandex:   python-perf.x86_64 0:3.10.0-1160.71.1.el7
    yandex:
    yandex: Complete!
    yandex: Loaded plugins: fastestmirror
    yandex: Loading mirror speeds from cached hostfile
    yandex:  * base: mirror.corbina.net
    yandex:  * extras: mirrors.datahouse.ru
    yandex:  * updates: mirror.corbina.net
    yandex: Package iptables-1.4.21-35.el7.x86_64 already installed and latest version
    yandex: Package curl-7.29.0-59.el7_9.1.x86_64 already installed and latest version
    yandex: Package net-tools-2.0-0.25.20131004git.el7.x86_64 already installed and latest version
    yandex: Package rsync-3.1.2-10.el7.x86_64 already installed and latest version
    yandex: Package openssh-server-7.4p1-22.el7_9.x86_64 already installed and latest version
    yandex: Resolving Dependencies
    yandex: --> Running transaction check
    yandex: ---> Package bind-utils.x86_64 32:9.11.4-26.P2.el7_9.9 will be installed
    yandex: --> Processing Dependency: bind-libs-lite(x86-64) = 32:9.11.4-26.P2.el7_9.9 for package: 32:bind-utils-9.11.4-26.P2.el7_9.9.x86_64
    yandex: --> Processing Dependency: bind-libs(x86-64) = 32:9.11.4-26.P2.el7_9.9 for package: 32:bind-utils-9.11.4-26.P2.el7_9.9.x86_64
    yandex: --> Processing Dependency: liblwres.so.160()(64bit) for package: 32:bind-utils-9.11.4-26.P2.el7_9.9.x86_64
    yandex: --> Processing Dependency: libisccfg.so.160()(64bit) for package: 32:bind-utils-9.11.4-26.P2.el7_9.9.x86_64
    yandex: --> Processing Dependency: libisc.so.169()(64bit) for package: 32:bind-utils-9.11.4-26.P2.el7_9.9.x86_64
    yandex: --> Processing Dependency: libirs.so.160()(64bit) for package: 32:bind-utils-9.11.4-26.P2.el7_9.9.x86_64
    yandex: --> Processing Dependency: libdns.so.1102()(64bit) for package: 32:bind-utils-9.11.4-26.P2.el7_9.9.x86_64
    yandex: --> Processing Dependency: libbind9.so.160()(64bit) for package: 32:bind-utils-9.11.4-26.P2.el7_9.9.x86_64
    yandex: --> Processing Dependency: libGeoIP.so.1()(64bit) for package: 32:bind-utils-9.11.4-26.P2.el7_9.9.x86_64
    yandex: ---> Package bridge-utils.x86_64 0:1.5-9.el7 will be installed
    yandex: ---> Package tcpdump.x86_64 14:4.9.2-4.el7_7.1 will be installed
    yandex: --> Processing Dependency: libpcap >= 14:1.5.3-10 for package: 14:tcpdump-4.9.2-4.el7_7.1.x86_64
    yandex: --> Processing Dependency: libpcap.so.1()(64bit) for package: 14:tcpdump-4.9.2-4.el7_7.1.x86_64
    yandex: ---> Package telnet.x86_64 1:0.17-66.el7 will be installed
    yandex: --> Running transaction check
    yandex: ---> Package GeoIP.x86_64 0:1.5.0-14.el7 will be installed
    yandex: --> Processing Dependency: geoipupdate for package: GeoIP-1.5.0-14.el7.x86_64
    yandex: ---> Package bind-libs.x86_64 32:9.11.4-26.P2.el7_9.9 will be installed
    yandex: --> Processing Dependency: bind-license = 32:9.11.4-26.P2.el7_9.9 for package: 32:bind-libs-9.11.4-26.P2.el7_9.9.x86_64
    yandex: ---> Package bind-libs-lite.x86_64 32:9.11.4-26.P2.el7_9.9 will be installed
    yandex: ---> Package libpcap.x86_64 14:1.5.3-13.el7_9 will be installed
    yandex: --> Running transaction check
    yandex: ---> Package bind-license.noarch 32:9.11.4-26.P2.el7_9.9 will be installed
    yandex: ---> Package geoipupdate.x86_64 0:2.5.0-1.el7 will be installed
    yandex: --> Finished Dependency Resolution
    yandex:
    yandex: Dependencies Resolved
    yandex:
    yandex: ================================================================================
    yandex:  Package            Arch       Version                        Repository   Size
    yandex: ================================================================================
    yandex: Installing:
    yandex:  bind-utils         x86_64     32:9.11.4-26.P2.el7_9.9        updates     261 k
    yandex:  bridge-utils       x86_64     1.5-9.el7                      base         32 k
    yandex:  tcpdump            x86_64     14:4.9.2-4.el7_7.1             base        422 k
    yandex:  telnet             x86_64     1:0.17-66.el7                  updates      64 k
    yandex: Installing for dependencies:
    yandex:  GeoIP              x86_64     1.5.0-14.el7                   base        1.5 M
    yandex:  bind-libs          x86_64     32:9.11.4-26.P2.el7_9.9        updates     157 k
    yandex:  bind-libs-lite     x86_64     32:9.11.4-26.P2.el7_9.9        updates     1.1 M
    yandex:  bind-license       noarch     32:9.11.4-26.P2.el7_9.9        updates      91 k
    yandex:  geoipupdate        x86_64     2.5.0-1.el7                    base         35 k
    yandex:  libpcap            x86_64     14:1.5.3-13.el7_9              updates     139 k
    yandex:
    yandex: Transaction Summary
    yandex: ================================================================================
    yandex: Install  4 Packages (+6 Dependent packages)
    yandex:
    yandex: Total download size: 3.8 M
    yandex: Installed size: 9.0 M
    yandex: Downloading packages:
    yandex: --------------------------------------------------------------------------------
    yandex: Total                                               12 MB/s | 3.8 MB  00:00
    yandex: Running transaction check
    yandex: Running transaction test
    yandex: Transaction test succeeded
    yandex: Running transaction
    yandex:   Installing : 32:bind-license-9.11.4-26.P2.el7_9.9.noarch                 1/10
    yandex:   Installing : geoipupdate-2.5.0-1.el7.x86_64                              2/10
    yandex:   Installing : GeoIP-1.5.0-14.el7.x86_64                                   3/10
    yandex:   Installing : 32:bind-libs-lite-9.11.4-26.P2.el7_9.9.x86_64               4/10
    yandex:   Installing : 32:bind-libs-9.11.4-26.P2.el7_9.9.x86_64                    5/10
    yandex:   Installing : 14:libpcap-1.5.3-13.el7_9.x86_64                            6/10
    yandex: pam_tally2: Error opening /var/log/tallylog for update: Permission denied
    yandex: pam_tally2: Authentication error
    yandex: useradd: failed to reset the tallylog entry of user "tcpdump"
    yandex:   Installing : 14:tcpdump-4.9.2-4.el7_7.1.x86_64                           7/10
    yandex:   Installing : 32:bind-utils-9.11.4-26.P2.el7_9.9.x86_64                   8/10
    yandex:   Installing : bridge-utils-1.5-9.el7.x86_64                               9/10
    yandex:   Installing : 1:telnet-0.17-66.el7.x86_64                                10/10
    yandex:   Verifying  : GeoIP-1.5.0-14.el7.x86_64                                   1/10
    yandex:   Verifying  : 14:libpcap-1.5.3-13.el7_9.x86_64                            2/10
    yandex:   Verifying  : 1:telnet-0.17-66.el7.x86_64                                 3/10
    yandex:   Verifying  : 32:bind-libs-9.11.4-26.P2.el7_9.9.x86_64                    4/10
    yandex:   Verifying  : geoipupdate-2.5.0-1.el7.x86_64                              5/10
    yandex:   Verifying  : 14:tcpdump-4.9.2-4.el7_7.1.x86_64                           6/10
    yandex:   Verifying  : 32:bind-license-9.11.4-26.P2.el7_9.9.noarch                 7/10
    yandex:   Verifying  : bridge-utils-1.5-9.el7.x86_64                               8/10
    yandex:   Verifying  : 32:bind-libs-lite-9.11.4-26.P2.el7_9.9.x86_64               9/10
    yandex:   Verifying  : 32:bind-utils-9.11.4-26.P2.el7_9.9.x86_64                  10/10
    yandex:
    yandex: Installed:
    yandex:   bind-utils.x86_64 32:9.11.4-26.P2.el7_9.9   bridge-utils.x86_64 0:1.5-9.el7
    yandex:   tcpdump.x86_64 14:4.9.2-4.el7_7.1           telnet.x86_64 1:0.17-66.el7
    yandex:
    yandex: Dependency Installed:
    yandex:   GeoIP.x86_64 0:1.5.0-14.el7
    yandex:   bind-libs.x86_64 32:9.11.4-26.P2.el7_9.9
    yandex:   bind-libs-lite.x86_64 32:9.11.4-26.P2.el7_9.9
    yandex:   bind-license.noarch 32:9.11.4-26.P2.el7_9.9
    yandex:   geoipupdate.x86_64 0:2.5.0-1.el7
    yandex:   libpcap.x86_64 14:1.5.3-13.el7_9
    yandex:
    yandex: Complete!
==> yandex: Stopping instance...
==> yandex: Deleting instance...
    yandex: Instance has been deleted!
==> yandex: Creating image: centos-7-base
==> yandex: Waiting for image to complete...
==> yandex: Success image create...
==> yandex: Destroying boot disk...
    yandex: Disk has been deleted!
Build 'yandex' finished after 4 minutes 22 seconds.

==> Wait completed after 4 minutes 22 seconds

==> Builds finished. The artifacts of successful builds are:
--> yandex: A disk image was created: centos-7-base (id: ) with family name centos
```
## Задача 2

Создать вашу первую виртуальную машину в Яндекс.Облаке.

Для получения зачета, вам необходимо предоставить:
- Скриншот страницы свойств созданной ВМ, как на примере ниже:

<p align="center">
  <img width="1200" height="600" src="./assets/yc_01.png">
</p>

## Задача 3

Создать ваш первый готовый к боевой эксплуатации компонент мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить:
- Скриншот работающего веб-интерфейса Grafana с текущими метриками, как на примере ниже
<p align="center">
  <img width="1200" height="600" src="./assets/yc_02.png">
</p>

## Задача 4 (*)

Создать вторую ВМ и подключить её к мониторингу развёрнутому на первом сервере.

Для получения зачета, вам необходимо предоставить:
- Скриншот из Grafana, на котором будут отображаться метрики добавленного вами сервера.
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
