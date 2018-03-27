## Requirements

Ansible Release **2.5.0** (Playbooks sind nicht abwärtskompatibel!)

Außerdem Juniper Ansible Galaxy Role inkl. Abhängigkeiten:

    pip install jxmlease junos-eznc
    ansible-galaxy install Juniper.junos


## Test-Playbook

Simpler NETCONF-Verbindungstest und Abfrage der Junos-Version über unterschiedliche Module

    ansible-playbook -u harry -k junos-test.yml

#### Optionen

    -u     eigener Username (Tacacs-user in unserem Fall). Nicht nötig, falls dieser dem lokalen User entspricht
    -k     Aufforderung zur Passworteingabe (ansonsten wird SSH-Key verwendet)
    -l     Ziel-Devices in hosts-Datei auf Gruppe limiteren, z.B. -l "lab-ex"


## Playbook zur Konfiguration der Infrastruktur

Playbook kann derzeit noch ohne Auswirkungen auf Produktivsysteme ausgeführt werden ('junos_config'-Modul auskommentiert). Es erfolgt jedoch bereits ein lokaler Build der config, so dass dieser Teil der Automation gefahrenlos getestet werden kann.

    ansible-playbook -k main.yml

