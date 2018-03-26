## Info

Repository basiert auf Ansible Release 2.4.3.0.


## Loslegen

Repository klonen und eigene Junos-Logindaten in credentials.yml eintragen. 
Ggf. via `ansible-vault encrypt` verschlüsseln; Playbooks müssen dann mit `--ask-vault-pass` ausgeführt werden.

    git clone https://gogs.intern.example.com/noc/ansible-juniper.git
    cp /group_vars/all/credentials.example.yml /group_vars/all/credentials.yml
    vi /group_vars/all/credentials.yml


## Playbook für NETCONF Verbindungstest

Playbook verbindet sich zu Switch und gibt via 'junos_facts'-Modul die Junos-Version aus

    ansible-playbook -i hosts junos-test.yml


## Playbook zur Konfiguration der Infrastruktur

Playbook kann derzeit noch ohne Auswirkungen auf Produktivsysteme ausgeführt werden, da 'junos_config'-Modul auskommentiert. Es erfolgt jedoch bereits ein lokaler Build der config, so dass dieser Teil der Automation gefahrenlos getestet werden kann.

    ansible-playbook -i hosts main.yml


