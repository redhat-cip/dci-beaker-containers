# dci-beaker-containers

## requirements

subscription-manager repos --enable ansible-2.9-for-rhel-8-x86_64-rpms

dnf -y install ansible-2.9.\* dnf-command\(versionlock\)
dnf versionlock ansible

ansible-galaxy collection install -r requirements.yml

## run services

    ansible-playbook -e ansible_python_interpreter=python3.6 deploy.yml
