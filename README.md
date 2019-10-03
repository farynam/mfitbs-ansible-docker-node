Role Name
=========

mfitbs-ansible-docker-node

Requirements
------------

* Ansible: 2.4

Role Variables
--------------

* ext_if: eth0
* inner_if: docker0

Dependencies
------------

* farynam.mfitbs_disable_ipv6

Example Playbook
----------------

    ---
    # tasks file for docker_node
    - name: Install docker
      hosts: node1
      roles:
      - role: mfitbs-ansible-docker-node

License
-------

MIT

Author Information
------------------

Marcin Faryna
