# Ansible-Juniper

This is an example layout for provisioning a Juniper-based network infrastructure with Ansible. It provides the following features:

- Configuration via netconf with the juniper_junos_config Ansible module
- Modular template structure for config provisioning across different device types
- Reusable roles for individual tasks like building configs or pushing to devices
- Integrated tests of network / protocol status with Jsnapy
- Flexible execution of playbook tasks via predefined tags


## Preparation

### Option 1 - Manual dependency installation for running Ansible directly on a host

(Example uses apt for a Debian-based OS)

    git clone https://github.com/haeringer/ansible-juniper.git
    cd ansible-juniper
    apt-get update && apt-get install python3-pip python3-venv
    python3 -m venv .venv
    source .venv/bin/activate
    export PIPENV_VENV_IN_PROJECT
    pip3 install -r requirements.txt
    ansible-galaxy install -r requirements.yml


### Option 2 - Building and running Ansible in a Docker container

    Install Docker: https://docs.docker.com/install/

When building this Docker image with the provided docker-compose file, you need to include your private SSH key for accessing your network devices. Therefore, this image is not intended for distribution, but only for usage on your local personal computer.

    git clone https://github.com/haeringer/ansible-juniper.git
    cd ansible-juniper
    docker-compose build --build-arg key="$(cat ~/.ssh/[yourprivatekey] | tr '\n' ';')"
    docker-compose run ansible-juniper bash

Add your SSH key to the ssh-agent:

    eval `ssh-agent -s` && ssh-add ~/.ssh/id_rsa


## Playbook options primer

    -l, --limit         Limit target devices in hosts files to a group or a single host, e.g. `-l reg1_loc1`
    -e, --extra-vars    Provide extra variable, e.g. `-e commit=yes confirm=1` (depending on playbook)
    -t, --tags          Provide tag for executing only specific tasks from within a playbook, e.g. `-t snap-pre`
    --skip-tags         Skip this tasks
    -u, --user          Provide a username other than your current shell user
    -k, --ask-pass      Make Ansible ask for a password, in case you don't use SSH keys


## Tags

With tags, the tasks within a playbook can be filtered. That means, when running a playbook without any tags, all tasks within the playbook are executed. With a tag, a task can be executed individually or be skipped.

Available/predefined tags:

    build-config    Generate configs locally, without contacting remote devices
    push-config     Push generated configs to devices
    snap-pre        Create status snapshots from devices before change
    snap-post       Create status snapshots from devices after change
    snap-check      Compare previously created snapshots and run tests
    testing         Aggregate tag for snap-* tagged tasks

The following examples will have the same result:

    ansible-playbook main.yml --tags 'build-config push-config'
    ansible-playbook main.yml --skip-tags testing


## Main playbook for provisioning the infrastructure

Playbook provisions device configurations with the juniper_junos_config module to all systems.
The extra variable `commit` is mandatory.

    ansible-playbook main.yml -e commit=yes

#### 'show | compare'

By running with `commit=no`, a "`show |compare`"-like diff of the configuration changes can be generated. This way changes can be verified non-destructively when testing, before committing anything.

    ansible-playbook main.yml -l switch1.loc1 -e commit=no

#### 'commit confirmed'

By providing the extra variable `confirm=n`, a "`commit confirmed`" with rollback after `n` minutes can be performed.

    ansible-playbook main.yml -e 'commit=yes confirm=1'

#### Generate local config only

By providing the extra variable `push=false`, the playbook can be run without pushing anything to the devices. This can be helpful for examining the generated configs locally, e.g. when developing templates (the configs are saved at `~/ansible_tmp/`).

    ansible-playbook main.yml -e push=false

Alternatively via `build-config` tag:

    ansible-playbook main.yml -t build-config

#### Push config via serial console connection

For initial device provisioning, it is also possible to push the config via netconf-over-serial-console:

    ansible-playbook main.yml -l switch1.loc1 -t push-config -e 'commit=yes connect_mode=serial connect_port=/dev/ttyUSB0'


### An example playbook for retrieving interface status

Query a device for the status of its interfaces:

	ansible-playbook playbooks/get-interfaces.yml -l switch1.loc1
