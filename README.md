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


## Playbook zur Interface-Abfrage

Simples Playbook zur Abfrage des Interface-Status (führt ```show interfaces terse```+ ```descriptions``` via CLI aus)

	ansible-playbook -k get-interfaces.yml -l 'ia5.b0-noc'


## Playbook zur Automation der Infrastruktur

Playbook konfiguriert alle Systeme via juniper_junos_config Modul. Greift per default auf Inventory ```hosts_production``` zurück, wo alle noch nicht automatisierten Systeme auskommentiert sind. Die Datei ```hosts_production``` NICHT unbedacht ändern, sonst können Konfigurationen von Produktivsystemen überschrieben werden.

    ansible-playbook -k main.yml


