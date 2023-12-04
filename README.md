# Terracloud Setup - IAAS

## Tools
- Terraform
- Ansible
- Docker/Docker-compose
- Azure

## Que se passe-t-il ?
1. Déploiement via Terraform de l'infrastructure sur Azure dans un dev test lab.
2. Playbook ansible pour configurer les VMs
  - Installation des utilitaires
  - Installation de Docker
  - Clone et lancement de l'application

## Process
> :warning: placement des variables d'environnements dans un fichier group_vars/all.yml

```sh
cd ansible
mkdir group_vars
cat <<EOF >>group_vars/all.yml
db_name: <<placeholder>>
db_user: <<placeholder>>
db_password: <<placeholder>>
db_host: <<placeholder>>
db_admin_password: <<placeholder>>
EOF
```

1. Lancer **infrasetup.sh** à la racine du projet
```sh
./infrasetup.sh create
```
2. ... C'est tout !

## Metrics
Réflexion sur les outils
- Possibilité d'utiliser les outils Azure ?
  - Metrics
  - Alert
  - ...
- JMeter ?

# Releases
- v1.0.0 - 4/12/2023

## To Do
- Kube
  1. Transition vers Kubernetes k3S
  2. Configuration fluxcd
  3. Installation helm automatique du monitoring et de l'application
- Template
  1. Utilisation d'Azure VM Template
  2. Possibilité d'utiliser Packer ?