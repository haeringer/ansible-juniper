## Info

Repository basiert auf Ansible Release 2.4.3.0.


## Loslegen

Repository klonen und eigene Junos-Logindaten in credentials.yml eintragen. 
Ggf. via ansible-vault encrypt verschlüsseln; Playbooks müssen dann mit --ask-vault-pass ausgeführt werden.

    git clone https://gogs.intern.example.com/noc/ansible-juniper.git
    cp /group_vars/all/credentials.example.yml /group_vars/all/credentials.yml


## Playbook für NETCONF Verbindungstest

Playbook verbindet sich zu Switch und gibt via 'junos_facts'-Modul die Junos-Version aus

   ansible-playbook -i hosts pb-junos-test.yml

