## Requirements

Ansible Release >= **2.5** (Playbooks sind nicht abwärtskompatibel)

Außerdem Juniper Ansible Galaxy Role inkl. Abhängigkeiten:

    pip install jxmlease junos-eznc
    ansible-galaxy install Juniper.junos


#### Playbook Optionen

    -u     eigener Username (Tacacs-user in unserem Fall). Angabe nicht nötig, falls dieser dem lokalen User entspricht
    -k     Aufforderung zur Passworteingabe (ansonsten wird SSH-Key verwendet)
    -l     Ziel-Devices in hosts-Datei auf Gruppe oder einzelnen Host limiteren, z.B. -l "lab-ex"
    -e     extra-Variable angeben, z.B. -e commit=no (abhängig vom Playbook)


## Playbook zur Interface-Abfrage

Abfrage des Interface-Status (führt ```show interfaces terse```+ ```descriptions``` via CLI aus), um z.B. freie Interfaces zu identifizieren

	ansible-playbook -k get-interfaces.yml -l 'ia1.b1'


## Playbook zur Automatisierung der Infrastruktur

Playbook konfiguriert alle Systeme via juniper_junos_config Modul. Wird bei Pushes in *master* automatisch über Jenkins ausgeführt. Greift per default auf Inventory ```hosts_production``` zurück, wo alle **noch nicht automatisierten Systeme auskommentiert** sind. Die Datei ```hosts_production``` NICHT unbedacht ändern, sonst können Konfigurationen von Produktivsystemen überschrieben werden.

    ansible-playbook main.yml -e commit=yes

#### 'show | compare'

Durch die Angabe der Extra-Variable ```commit=no``` kann ein "show | compare"-artiger Diff von Konfigurationsänderungen durchgeführt werden. Die config wird dabei auf das Device gepusht, verglichen und direkt anschließend ein Rollback durchgeführt. Damit können Änderungen non-destruktiv verifiziert werden.

    ansible-playbook -k main.yml -l 'ia1.b1' -e commit=no
