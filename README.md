## Requirements

Ansible Release >= **2.5** (Playbooks sind nicht abwärtskompatibel)

Außerdem Juniper Ansible Galaxy Role inkl. Abhängigkeiten:

    pip install jxmlease junos-eznc
    ansible-galaxy install Juniper.junos


#### Playbook Optionen

    -u     eigener Username (Tacacs-user in unserem Fall). Angabe nicht nötig, falls dieser dem lokalen User entspricht
    -k     Aufforderung zur Passworteingabe (ansonsten wird SSH-Key verwendet)
    -l     Ziel-Devices in hosts-Datei auf Gruppe oder einzelnen Host limiteren, z.B. -l "lab-ex"


## Playbook zur Interface-Abfrage

Abfrage des Interface-Status (führt ```show interfaces terse```+ ```descriptions``` via CLI aus), um z.B. freie Interfaces zu identifizieren

	ansible-playbook -k get-interfaces.yml -l 'ia1.b1'


## Playbook für 'show | compare'

Konfigurationsänderungen können mit diesem Playbook verifiziert werden, ohne dass die Konfiguration tatsächlich geändert oder committed wird. Die Konfiguration wird zudem direkt nach dem check + diff wieder vom Device entladen, so dass keinerlei Änderungen zurückbleiben. Entspricht strukturell main.yml (s.u.), lediglich ohne commit.

	ansible-playbook -k main-compare.yml -l 'ia1.b1'


## Playbook zur Automation der Infrastruktur

Playbook konfiguriert alle Systeme via juniper_junos_config Modul. Wird bei Pushes in *master* automatisch ausgeführt. Greift per default auf Inventory ```hosts_production``` zurück, wo alle **noch nicht automatisierten Systeme auskommentiert** sind. Die Datei ```hosts_production``` NICHT unbedacht ändern, sonst können Konfigurationen von Produktivsystemen überschrieben werden.

    ansible-playbook -k main.yml


