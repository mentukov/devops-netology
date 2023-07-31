
datasource:
  Ec2:
    strict_id: false
ssh_pwauth: yes
users:
  - name: ubuntu
    passwd: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash