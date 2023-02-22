# Домашнее задание к занятию "9.Процессы CI/CD"

## Подготовка к выполнению

1. Создаём 2 VM в yandex cloud со следующими параметрами: 2CPU 4RAM Centos7(остальное по минимальным требованиям)
2. Прописываем в [inventory](./infrastructure/inventory/cicd/hosts.yml) [playbook'a](./infrastructure/site.yml) созданные хосты
3. Добавляем в [files](./infrastructure/files/) файл со своим публичным ключом (id_rsa.pub). Если ключ называется иначе - найдите таску в плейбуке, которая использует id_rsa.pub имя и исправьте на своё
4. Запускаем playbook, ожидаем успешного завершения

```
09:05:59 vagrant@ubuntu-focal infrastructure ±|main ✗|→ ansible-playbook -i inventory/cicd/hosts.yml site.yml

PLAY [Get OpenJDK installed] ***************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [sonar-01]

TASK [install unzip] ***********************************************************************************************************************
ok: [sonar-01]

TASK [Upload .tar.gz file conaining binaries from remote storage] **************************************************************************
ok: [sonar-01]

TASK [Ensure installation dir exists] ******************************************************************************************************
ok: [sonar-01]

TASK [Extract java in the installation directory] ******************************************************************************************
skipping: [sonar-01]

TASK [Export environment variables] ********************************************************************************************************
ok: [sonar-01]

PLAY [Get PostgreSQL installed] ************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [sonar-01]

TASK [Change repo file] ********************************************************************************************************************
ok: [sonar-01]

TASK [Install PostgreSQL repos] ************************************************************************************************************
ok: [sonar-01]

TASK [Install PostgreSQL] ******************************************************************************************************************
ok: [sonar-01]

TASK [Init template1 DB] *******************************************************************************************************************
changed: [sonar-01]

TASK [Start pgsql service] *****************************************************************************************************************
ok: [sonar-01]

TASK [Create user in system] ***************************************************************************************************************
ok: [sonar-01]

TASK [Create user for Sonar in PostgreSQL] *************************************************************************************************
changed: [sonar-01]

TASK [Change password for Sonar user in PostgreSQL] ****************************************************************************************
changed: [sonar-01]

TASK [Create Sonar DB] *********************************************************************************************************************
changed: [sonar-01]

TASK [Copy pg_hba.conf] ********************************************************************************************************************
ok: [sonar-01]

PLAY [Prepare Sonar host] ******************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [sonar-01]

TASK [Create group in system] **************************************************************************************************************
ok: [sonar-01]

TASK [Create user in system] ***************************************************************************************************************
ok: [sonar-01]

TASK [Set up ssh key to access for managed node] *******************************************************************************************
ok: [sonar-01]

TASK [Allow group to have passwordless sudo] ***********************************************************************************************
ok: [sonar-01]

TASK [Increase Virtual Memory] *************************************************************************************************************
ok: [sonar-01]

TASK [Reboot VM] ***************************************************************************************************************************
changed: [sonar-01]

PLAY [Get Sonarqube installed] *************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [sonar-01]

TASK [Get distrib ZIP] *********************************************************************************************************************
ok: [sonar-01]

TASK [Unzip Sonar] *************************************************************************************************************************
skipping: [sonar-01]

TASK [Move Sonar into place.] **************************************************************************************************************
changed: [sonar-01]

TASK [Configure SonarQube JDBC settings for PostgreSQL.] ***********************************************************************************
changed: [sonar-01] => (item={'regexp': '^sonar.jdbc.username', 'line': 'sonar.jdbc.username=sonar'})
changed: [sonar-01] => (item={'regexp': '^sonar.jdbc.password', 'line': 'sonar.jdbc.password=sonar'})
changed: [sonar-01] => (item={'regexp': '^sonar.jdbc.url', 'line': 'sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance'})
changed: [sonar-01] => (item={'regexp': '^sonar.web.context', 'line': 'sonar.web.context='})

TASK [Generate wrapper.conf] ***************************************************************************************************************
changed: [sonar-01]

TASK [Symlink sonar bin.] ******************************************************************************************************************
ok: [sonar-01]

TASK [Copy SonarQube systemd unit file into place (for systemd systems).] ******************************************************************
ok: [sonar-01]

TASK [Ensure Sonar is running and set to start on boot.] ***********************************************************************************
changed: [sonar-01]

TASK [Allow Sonar time to build on first start.] *******************************************************************************************
skipping: [sonar-01]

TASK [Make sure Sonar is responding on the configured port.] *******************************************************************************
ok: [sonar-01]

PLAY [Get Nexus installed] *****************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
ok: [nexus-01]

TASK [Create Nexus group] ******************************************************************************************************************
changed: [nexus-01]

TASK [Create Nexus user] *******************************************************************************************************************
changed: [nexus-01]

TASK [Install JDK] *************************************************************************************************************************
changed: [nexus-01]

TASK [Create Nexus directories] ************************************************************************************************************
changed: [nexus-01] => (item=/home/nexus/log)
changed: [nexus-01] => (item=/home/nexus/sonatype-work/nexus3)
changed: [nexus-01] => (item=/home/nexus/sonatype-work/nexus3/etc)
changed: [nexus-01] => (item=/home/nexus/pkg)
changed: [nexus-01] => (item=/home/nexus/tmp)

TASK [Download Nexus] **********************************************************************************************************************
[WARNING]: Module remote_tmp /home/nexus/.ansible/tmp did not exist and was created with a mode of 0700, this may cause issues when running
as another user. To avoid this, create the remote_tmp dir with the correct permissions manually
changed: [nexus-01]

TASK [Unpack Nexus] ************************************************************************************************************************
changed: [nexus-01]

TASK [Link to Nexus Directory] *************************************************************************************************************
changed: [nexus-01]

TASK [Add NEXUS_HOME for Nexus user] *******************************************************************************************************
changed: [nexus-01]

TASK [Add run_as_user to Nexus.rc] *********************************************************************************************************
changed: [nexus-01]

TASK [Raise nofile limit for Nexus user] ***************************************************************************************************
changed: [nexus-01]

TASK [Create Nexus service for SystemD] ****************************************************************************************************
changed: [nexus-01]

TASK [Ensure Nexus service is enabled for SystemD] *****************************************************************************************
changed: [nexus-01]

TASK [Create Nexus vmoptions] **************************************************************************************************************
changed: [nexus-01]

TASK [Create Nexus properties] *************************************************************************************************************
changed: [nexus-01]

TASK [Lower Nexus disk space threshold] ****************************************************************************************************
skipping: [nexus-01]

TASK [Start Nexus service if enabled] ******************************************************************************************************
changed: [nexus-01]

TASK [Ensure Nexus service is restarted] ***************************************************************************************************
skipping: [nexus-01]

TASK [Wait for Nexus port if started] ******************************************************************************************************
ok: [nexus-01]

PLAY RECAP *********************************************************************************************************************************
nexus-01                   : ok=17   changed=15   unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
sonar-01                   : ok=32   changed=9    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0  
```

5. Проверяем готовность Sonarqube через [браузер](http://158.160.22.184:9000)
<img width="1434" alt="Снимок экрана 2023-02-22 в 17 27 49" src="https://user-images.githubusercontent.com/65667114/220578741-d8dd3502-7b5f-4230-96eb-0c1c49b20fb2.png">
6. Заходим под admin\admin, меняем пароль на свой
7.  Проверяем готовность Nexus через [бразуер](http://158.160.27.116:8081)
<img width="1433" alt="Снимок экрана 2023-02-22 в 17 27 39" src="https://user-images.githubusercontent.com/65667114/220578820-08d40de1-be1e-4f2f-a318-0fab7715ebfb.png">
8. Подключаемся под admin\admin123, меняем пароль, сохраняем анонимный доступ

## Знакомоство с SonarQube

### Основная часть

1. Создаём новый проект, название произвольное
2. Скачиваем пакет sonar-scanner, который нам предлагает скачать сам sonarqube
3. Делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)
4. Проверяем `sonar-scanner --version`

```
09:50:22 vagrant@ubuntu-focal ~ → sonar-scanner -v
INFO: Scanner configuration file: /opt/sonar-scanner/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 4.8.0.2856
INFO: Java 11.0.17 Eclipse Adoptium (64-bit)
INFO: Linux 5.4.0-139-generic amd64
```

5. Запускаем анализатор против кода из директории [example](./example) с дополнительным ключом `-Dsonar.coverage.exclusions=fail.py`

```
09:53:06 vagrant@ubuntu-focal example ±|main|→ sonar-scanner \
>   -Dsonar.projectKey=netology \
>   -Dsonar.sources=. \
>   -Dsonar.host.url=http://158.160.22.184:9000 \
>   -Dsonar.login=1ffbdeabe49f35f03f61c3ef3e0e08d411c369ef \
>   -Dsonar.coverage.exclusions=fail.py
INFO: Scanner configuration file: /opt/sonar-scanner/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 4.8.0.2856
INFO: Java 11.0.17 Eclipse Adoptium (64-bit)
INFO: Linux 5.4.0-139-generic amd64
INFO: User cache: /home/vagrant/.sonar/cache
INFO: Analyzing on SonarQube server 9.1.0
INFO: Default locale: "en", source code encoding: "UTF-8"
INFO: Load global settings
INFO: Load global settings (done) | time=715ms
INFO: Server id: 9CFC3560-AYZ4VyzLyFMHNwjeD8NW
INFO: User cache: /home/vagrant/.sonar/cache
INFO: Load/download plugins
INFO: Load plugins index
INFO: Load plugins index (done) | time=302ms
INFO: Load/download plugins (done) | time=586868ms
INFO: Process project properties
INFO: Process project properties (done) | time=17ms
INFO: Execute project builders
INFO: Execute project builders (done) | time=2ms
INFO: Project key: netology
INFO: Base dir: /home/vagrant/devops-netology/mnt-homeworks/09-ci-03-cicd/example
INFO: Working dir: /home/vagrant/devops-netology/mnt-homeworks/09-ci-03-cicd/example/.scannerwork
INFO: Load project settings for component key: 'netology'
INFO: Load project settings for component key: 'netology' (done) | time=360ms
INFO: Load quality profiles
INFO: Load quality profiles (done) | time=387ms
INFO: Load active rules
INFO: Load active rules (done) | time=9825ms
INFO: Indexing files...
INFO: Project configuration:
INFO:   Excluded sources for coverage: fail.py
INFO: 1 file indexed
INFO: 0 files ignored because of scm ignore settings
INFO: Quality profile for py: Sonar way
INFO: ------------- Run sensors on module netology
INFO: Load metrics repository
INFO: Load metrics repository (done) | time=315ms
INFO: Sensor Python Sensor [python]
WARN: Your code is analyzed as compatible with python 2 and 3 by default. This will prevent the detection of issues specific to python 2 or python 3. You can get a more precise analysis by setting a python version in your configuration via the parameter "sonar.python.version"
INFO: Starting global symbols computation
INFO: Load project repositories
INFO: 1 source file to be analyzed
INFO: Load project repositories (done) | time=287ms
INFO: 1/1 source file has been analyzed
INFO: Starting rules execution
INFO: 1 source file to be analyzed
INFO: 1/1 source file has been analyzed
INFO: Sensor Python Sensor [python] (done) | time=1247ms
INFO: Sensor Cobertura Sensor for Python coverage [python]
INFO: Sensor Cobertura Sensor for Python coverage [python] (done) | time=10ms
INFO: Sensor PythonXUnitSensor [python]
INFO: Sensor PythonXUnitSensor [python] (done) | time=1ms
INFO: Sensor CSS Rules [cssfamily]
INFO: No CSS, PHP, HTML or VueJS files are found in the project. CSS analysis is skipped.
INFO: Sensor CSS Rules [cssfamily] (done) | time=1ms
INFO: Sensor JaCoCo XML Report Importer [jacoco]
INFO: 'sonar.coverage.jacoco.xmlReportPaths' is not defined. Using default locations: target/site/jacoco/jacoco.xml,target/site/jacoco-it/jacoco.xml,build/reports/jacoco/test/jacocoTestReport.xml
INFO: No report imported, no coverage information will be imported by JaCoCo XML Report Importer
INFO: Sensor JaCoCo XML Report Importer [jacoco] (done) | time=4ms
INFO: Sensor C# Project Type Information [csharp]
INFO: Sensor C# Project Type Information [csharp] (done) | time=1ms
INFO: Sensor C# Analysis Log [csharp]
INFO: Sensor C# Analysis Log [csharp] (done) | time=14ms
INFO: Sensor C# Properties [csharp]
INFO: Sensor C# Properties [csharp] (done) | time=0ms
INFO: Sensor JavaXmlSensor [java]
INFO: Sensor JavaXmlSensor [java] (done) | time=1ms
INFO: Sensor HTML [web]
INFO: Sensor HTML [web] (done) | time=3ms
INFO: Sensor VB.NET Project Type Information [vbnet]
INFO: Sensor VB.NET Project Type Information [vbnet] (done) | time=2ms
INFO: Sensor VB.NET Analysis Log [vbnet]
INFO: Sensor VB.NET Analysis Log [vbnet] (done) | time=15ms
INFO: Sensor VB.NET Properties [vbnet]
INFO: Sensor VB.NET Properties [vbnet] (done) | time=1ms
INFO: ------------- Run sensors on project
INFO: Sensor Zero Coverage Sensor
INFO: Sensor Zero Coverage Sensor (done) | time=1ms
INFO: SCM Publisher SCM provider for this project is: git
INFO: SCM Publisher 1 source file to be analyzed
INFO: SCM Publisher 1/1 source file have been analyzed (done) | time=181ms
INFO: CPD Executor Calculating CPD for 1 file
INFO: CPD Executor CPD calculation finished (done) | time=12ms
INFO: Analysis report generated in 121ms, dir size=103.1 kB
INFO: Analysis report compressed in 13ms, zip size=14.4 kB
INFO: Analysis report uploaded in 565ms
INFO: ANALYSIS SUCCESSFUL, you can browse http://158.160.22.184:9000/dashboard?id=netology
INFO: Note that you will be able to access the updated dashboard once the server has processed the submitted analysis report
INFO: More about the report processing at http://158.160.22.184:9000/api/ce/task?id=AYZ4lzCu4OgcIaw0lh9n
INFO: Analysis total time: 16.178 s
INFO: ------------------------------------------------------------------------
INFO: EXECUTION SUCCESS
INFO: ------------------------------------------------------------------------
INFO: Total time: 12:33.969s
INFO: Final Memory: 7M/49M
INFO: ------------------------------------------------------------------------
```

6. Смотрим результат в интерфейсе
7. Исправляем ошибки, которые он выявил(включая warnings)
8. Запускаем анализатор повторно - проверяем, что QG пройдены успешно
9. Делаем скриншот успешного прохождения анализа, прикладываем к решению ДЗ

## Знакомство с Nexus

### Основная часть

1. В репозиторий `maven-public` загружаем артефакт с GAV параметрами:
   1. groupId: netology
   2. artifactId: java
   3. version: 8_282
   4. classifier: distrib
   5. type: tar.gz
2. В него же загружаем такой же артефакт, но с version: 8_102
3. Проверяем, что все файлы загрузились успешно
4. В ответе присылаем файл `maven-metadata.xml` для этого артефекта

### Знакомство с Maven

### Подготовка к выполнению

1. Скачиваем дистрибутив с [maven](https://maven.apache.org/download.cgi)
2. Разархивируем, делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)
3. Удаляем из `apache-maven-<version>/conf/settings.xml` упоминание о правиле, отвергающем http соединение( раздел mirrors->id: my-repository-http-unblocker)
4. Проверяем `mvn --version`
5. Забираем директорию [mvn](./mvn) с pom

### Основная часть

1. Меняем в `pom.xml` блок с зависимостями под наш артефакт из первого пункта задания для Nexus (java с версией 8_282)
2. Запускаем команду `mvn package` в директории с `pom.xml`, ожидаем успешного окончания
3. Проверяем директорию `~/.m2/repository/`, находим наш артефакт
4. В ответе присылаем исправленный файл `pom.xml`

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
