# Домашнее задание к занятию «Хранение в K8s. Часть 1»

------

### Задание 1 

**Что нужно сделать**

Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.
3. Обеспечить возможность чтения файла контейнером multitool.
4. Продемонстрировать, что multitool может читать файл, который периодоически обновляется.
5. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.

```
02:17:13 mentukov@mentukov-MINIPC-PN50 yaml1 ±|main|→ kubectl apply -f deployment.yaml
deployment.apps/data-exchange-app created
02:17:21 mentukov@mentukov-MINIPC-PN50 yaml1 ±|main|→ kubectl get deployments -o wide
NAME                READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS                            IMAGES                            SELECTOR
data-exchange-app   1/1     1            1           20s   busybox-container,network-multitool   busybox,wbitt/network-multitool   app=data-exchange-app
02:17:41 mentukov@mentukov-MINIPC-PN50 yaml1 ±|main|→ kubectl get pods -o wide
NAME                                READY   STATUS    RESTARTS   AGE   IP           NODE                   NOMINATED NODE   READINESS GATES
data-exchange-app-dd97cf5cf-kfgsv   2/2     Running   0          35s   10.1.8.199   mentukov-minipc-pn50   <none>           <none>
02:18:51 mentukov@mentukov-MINIPC-PN50 yaml1 ±|main|→ kubectl exec -it data-exchange-app-dd97cf5cf-kfgsv -- cat /shared-data/data.txt
Defaulted container "busybox-container" out of: busybox-container, network-multitool
Fri May 26 11:17:23 UTC 2023
Fri May 26 11:17:28 UTC 2023
Fri May 26 11:17:33 UTC 2023
Fri May 26 11:17:38 UTC 2023
Fri May 26 11:17:43 UTC 2023
Fri May 26 11:17:48 UTC 2023
Fri May 26 11:17:53 UTC 2023
Fri May 26 11:17:58 UTC 2023
Fri May 26 11:18:03 UTC 2023
Fri May 26 11:18:08 UTC 2023

```

------

### Задание 2

**Что нужно сделать**

Создать DaemonSet приложения, которое может прочитать логи ноды.

1. Создать DaemonSet приложения, состоящего из multitool.
2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.
3. Продемонстрировать возможность чтения файла изнутри пода.
4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.

```

```

------
