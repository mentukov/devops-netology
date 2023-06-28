# Домашнее задание к занятию «Установка Kubernetes»

### Цель задания

Установить кластер K8s.

### Чеклист готовности к домашнему заданию

1. Развёрнутые ВМ с ОС Ubuntu 22.04-lts.

### Задание 1. Установить кластер k8s с 1 master node

1. Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды.
2. В качестве CRI — containerd.
3. Запуск etcd производить на мастере.
4. Способ установки выбрать самостоятельно.

### Ответ

```
kubeadm

kuber@master:~$ cat /etc/hosts
127.0.0.1 localhost
127.0.0.1 master
192.168.82.76 master
192.168.82.77 node1
192.168.82.78 node2
192.168.82.79 node3
192.168.82.80 node4

kuber@master:~$ containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
kuber@master:~$ sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
kuber@master:~$ sudo systemctl restart containerd
kuber@master:~$ sudo systemctl enable containerd

kuber@master:~$ sudo kubeadm init --control-plane-endpoint=master
Then you can join any number of worker nodes by running the following on each as root:

kubeadm join master:6443 --token xkwv0b.zue3f3032v9mnnha \
	--discovery-token-ca-cert-hash sha256:75fbc60098c78fc0a7cacc4c954fdb4e729d2a1cdaebc3954a42ff6494900739 

kuber@master:~$ kubectl cluster-info
Kubernetes control plane is running at https://master:6443
CoreDNS is running at https://master:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
kuber@master:~$ kubectl get nodes
NAME     STATUS     ROLES           AGE   VERSION
master   NotReady   control-plane   88s   v1.27.3

kuber@node1:~$ sudo kubeadm join master:6443 --token xkwv0b.zue3f3032v9mnnha \
        --discovery-token-ca-cert-hash sha256:75fbc60098c78fc0a7cacc4c954fdb4e729d2a1cdaebc3954a42ff6494900739

kuber@master:~$ kubectl get nodes
NAME     STATUS     ROLES           AGE   VERSION
master   NotReady   control-plane   46m   v1.27.3
node1    NotReady   <none>          66s   v1.27.3
node2    NotReady   <none>          54s   v1.27.3
node3    NotReady   <none>          44s   v1.27.3
node4    NotReady   <none>          32s   v1.27.3

kuber@master:~$ kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

kuber@master:~$ kubectl get pods -n kube-system
NAME                                       READY   STATUS    RESTARTS   AGE
calico-kube-controllers-6c99c8747f-tkps8   1/1     Running   0          119s
calico-node-cgf5z                          0/1     Running   0          119s
calico-node-hf6z8                          1/1     Running   0          119s
calico-node-qksxx                          1/1     Running   0          119s
calico-node-rjs8j                          0/1     Running   0          119s
calico-node-s7bkl                          0/1     Running   0          119s
coredns-5d78c9869d-6dgc5                   1/1     Running   0          63m
coredns-5d78c9869d-hw4kx                   1/1     Running   0          63m
etcd-master                                1/1     Running   0          63m
kube-apiserver-master                      1/1     Running   0          63m
kube-controller-manager-master             1/1     Running   0          63m
kube-proxy-2trc9                           1/1     Running   0          17m
kube-proxy-4pl5r                           1/1     Running   0          17m
kube-proxy-c8t25                           1/1     Running   0          63m
kube-proxy-tdmrb                           1/1     Running   0          17m
kube-proxy-zc9f9                           1/1     Running   0          18m
kube-scheduler-master                      1/1     Running   0          63m

kuber@master:~$ kubectl get nodes
NAME     STATUS   ROLES           AGE   VERSION
master   Ready    control-plane   63m   v1.27.3
node1    Ready    <none>          18m   v1.27.3
node2    Ready    <none>          18m   v1.27.3
node3    Ready    <none>          18m   v1.27.3
node4    Ready    <none>          17m   v1.27.3

```

-----


