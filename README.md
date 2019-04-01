## Requirements

Ansible Release >= **2.5** plus Juniper Ansible Galaxy Role inkl. Abhängigkeiten:

    pip install ansible jxmlease junos-eznc

    ansible-galaxy install Juniper.junos


#### Playbook Optionen

    -l     Ziel-Devices in hosts-Datei auf Gruppe oder einzelnen Host limiteren, z.B. -l "lab-ex"
    -e     extra-Variable angeben, z.B. -e commit=no (abhängig vom Playbook)
    -u     eigener Username (Tacacs-user in unserem Fall). Angabe nicht nötig, falls dieser dem lokalen User entspricht
    -k     Aufforderung zur Passworteingabe, falls kein SSH-Key vorhanden


## Playbook zur Interface-Abfrage

Abfrage des Interface-Status (führt ```show interfaces terse```+ ```descriptions``` via CLI aus), um z.B. freie Interfaces zu identifizieren

	ansible-playbook get-interfaces.yml -l ia1.b1


## Playbook zur Automatisierung der Infrastruktur

Playbook konfiguriert alle Systeme via juniper_junos_config Modul. Wird bei Pushes in *master* automatisch über Jenkins ausgeführt. Greift per default auf Inventory ```hosts_production``` zurück, wo alle **noch nicht automatisierten Systeme auskommentiert** sind. Die Datei ```hosts_production``` NICHT unbedacht ändern, sonst können Konfigurationen von Produktivsystemen überschrieben werden.

    ansible-playbook main.yml -e commit=yes

#### 'show | compare'

Durch die Angabe der Extra-Variable ```commit=no``` kann ein "show | compare"-artiger Diff von Konfigurationsänderungen durchgeführt werden. Die config wird dabei auf das Device gepusht, verglichen und direkt anschließend ein Rollback durchgeführt. Damit können Änderungen non-destruktiv verifiziert werden.

    ansible-playbook main.yml -l ia1.b1 -e commit=no

#### 'commit confirmed'

Durch die optionale Angabe der Extra-Variable ```confirm=n``` kann ein 'commit confirmed' mit automatischem Rollback nach ```n``` Minuten durchgeführt werden.

    ansible-playbook main.yml -l ia1.b1 -e 'commit=yes confirm=1'

#### Config nur lokal generieren, ohne zu pushen

Durch die optionale Angabe der Extra-Variable ```push=false``` kann das Playbook ausgeführt werden, ohne dass überhaupt etwas auf die Geräte gepusht wird. So lässt sich z.B. die generierte Config lokal überprüfen.

    ansible-playbook main.yml -l ia1.b1 -e push=false
