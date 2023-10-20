# dci-beaker-containers

## requirements

- https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
- podman
- ansible
- ansible-collection-community-general
- ansible-collection-containers-podman
- ansible-collection-ansible-posix
- python3-netaddr.noarch

## run services

    ansible-playbook -e ansible_python_interpreter=python3.6 deploy.yml
