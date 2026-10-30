Docker Role
===========

Setup docker repo, install and start necessary services

Requirements
------------
- `gather_facts` must be `true`: `defaults/main.yml` uses `ansible_facts['distribution']`.
- Ubuntu hosts only (uses `apt` and Docker's Ubuntu repo).

Role Variables
--------------

All variables live in `defaults/main.yml`, so any of them can be overridden.

- Rarely changed
  <!-- https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository -->
  - docker_packages_to_check
  - docker_packages
  - docker_services
- Meant to be overridden
  - docker_deb822_base_url
  - docker_deb822_components
- Derived from other variables
  - docker_os_distribution
  - docker_deb822_uris
  - docker_deb822_signed_by

License
-------

MIT

Author Information
------------------

Mushigarou