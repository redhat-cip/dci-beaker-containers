# dci-beaker-containers

## requirements

- podman
- ansible

## log in registry.redhat.io

    podman login registry.redhat.io

## run services

    ansible-playbook -v deploy.yml
