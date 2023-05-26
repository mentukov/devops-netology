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
02:37:02 mentukov@mentukov-MINIPC-PN50 yaml2 ±|main|→ kubectl apply -f multitool.yaml 
daemonset.apps/multitool-daemonset created

02:37:15 mentukov@mentukov-MINIPC-PN50 yaml2 ±|main|→ kubectl logs -l app=multitool
May 26 14:37:23 mentukov-MINIPC-PN50 microk8s.daemon-containerd[4136]: time="2023-05-26T14:37:23.365276245+03:00" level=info msg="CreateContainer within sandbox \"8de481d93f1a34385ba7d7ae28144ce2384f507efac856bc5511cdd69ab9a2ab\" for container &ContainerMetadata{Name:multitool,Attempt:0,}"
May 26 14:37:23 mentukov-MINIPC-PN50 microk8s.daemon-containerd[4136]: time="2023-05-26T14:37:23.382020742+03:00" level=info msg="CreateContainer within sandbox \"8de481d93f1a34385ba7d7ae28144ce2384f507efac856bc5511cdd69ab9a2ab\" for &ContainerMetadata{Name:multitool,Attempt:0,} returns container id \"77374ed645691733511203f5a2f3159d383984cb74c0256a8d283f27a6cab1dc\""
May 26 14:37:23 mentukov-MINIPC-PN50 microk8s.daemon-containerd[4136]: time="2023-05-26T14:37:23.382788144+03:00" level=info msg="StartContainer for \"77374ed645691733511203f5a2f3159d383984cb74c0256a8d283f27a6cab1dc\""
May 26 14:37:23 mentukov-MINIPC-PN50 microk8s.daemon-containerd[4136]: time="2023-05-26T14:37:23.451676607+03:00" level=info msg="StartContainer for \"77374ed645691733511203f5a2f3159d383984cb74c0256a8d283f27a6cab1dc\" returns successfully"
May 26 14:37:24 mentukov-MINIPC-PN50 systemd[1]: var-snap-microk8s-common-var-lib-containerd-tmpmounts-containerd\x2dmount3656990519.mount: Deactivated successfully.
May 26 14:37:24 mentukov-MINIPC-PN50 microk8s.daemon-kubelite[4262]: I0526 14:37:24.401527    4262 pod_startup_latency_tracker.go:102] "Observed pod startup duration" pod="default/multitool-daemonset-dm8th" podStartSLOduration=-9.223372027453335e+09 pod.CreationTimestamp="2023-05-26 14:37:15 +0300 MSK" firstStartedPulling="2023-05-26 14:37:16.232815688 +0300 MSK m=+12985.834729150" lastFinishedPulling="0001-01-01 00:00:00 +0000 UTC" observedRunningTime="2023-05-26 14:37:24.399803175 +0300 MSK m=+12994.001717056" watchObservedRunningTime="2023-05-26 14:37:24.401440435 +0300 MSK m=+12994.003354386"
May 26 14:37:24 mentukov-MINIPC-PN50 systemd[1]: run-containerd-runc-k8s.io-fe18717231ed900efadb2b97f2e300309f123fbd0a3289a6d18bf2d520ed00d8-runc.8KQPT7.mount: Deactivated successfully.
May 26 14:37:34 mentukov-MINIPC-PN50 systemd[1]: run-containerd-runc-k8s.io-fe18717231ed900efadb2b97f2e300309f123fbd0a3289a6d18bf2d520ed00d8-runc.ezMrlo.mount: Deactivated successfully.
May 26 14:37:36 mentukov-MINIPC-PN50 systemd[1]: run-containerd-runc-k8s.io-fe18717231ed900efadb2b97f2e300309f123fbd0a3289a6d18bf2d520ed00d8-runc.iBKdlR.mount: Deactivated successfully.
May 26 14:37:38 mentukov-MINIPC-PN50 systemd[1354]: Started snap.microk8s.microk8s.3d2ce257-0440-4e44-8df9-afb762ed32fc.scope.

02:39:01 mentukov@mentukov-MINIPC-PN50 yaml2 ±|main|→ kubectl exec -it multitool-daemonset-dm8th -- cat /var/log/syslog
May 25 12:03:56 mentukov-MINIPC-PN50 systemd[1]: logrotate.service: Deactivated successfully.
May 25 12:03:56 mentukov-MINIPC-PN50 systemd[1]: Finished Rotate log files.
May 25 12:03:56 mentukov-MINIPC-PN50 kernel: [    4.419215] intel_rapl_common: Found RAPL domain package
May 25 12:03:56 mentukov-MINIPC-PN50 kernel: [    4.419219] intel_rapl_common: Found RAPL domain core
May 25 12:03:56 mentukov-MINIPC-PN50 kernel: [    4.457474] snd_hda_intel 0000:05:00.1: enabling device (0000 -> 0002)
May 25 12:03:56 mentukov-MINIPC-PN50 kernel: [    4.457538] snd_hda_intel 0000:05:00.1: Handle vga_switcheroo audio client
May 25 12:03:56 mentukov-MINIPC-PN50 kernel: [    4.457662] snd_hda_intel 0000:05:00.6: enabling device (0000 -> 0002)
May 25 12:03:56 mentukov-MINIPC-PN50 kernel: [    4.461907] snd_hda_intel 0000:05:00.6: no codecs found!
May 25 12:03:56 mentukov-MINIPC-PN50 iio-sensor-prox[719]: Found proximity sensor but no PROXIMITY_NEAR_LEVEL udev property
May 25 12:03:56 mentukov-MINIPC-PN50 iio-sensor-prox[719]: See https://gitlab.freedesktop.org/hadess/iio-sensor-proxy/blob/master/README.md
May 25 12:03:56 mentukov-MINIPC-PN50 kernel: [    4.488001] input: HD-Audio Generic HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:08.1/0000:05:00.1/sound/card0/input12

```

------
