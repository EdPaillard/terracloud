#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

help_script() {
    echo -e "### How to use:\nPossible parameters: create or destroy.\nex: $0 create | destroy"
}

create() {
    echo -e "\n${GREEN}Terraform init${ENDCOLOR}\n"
    terraform init
    echo -e "\n${GREEN}Terraform plan${ENDCOLOR}\n"
    terraform plan -out=tfplan # -var client_id=$CLIENT_ID -var client_secret=$CLIENT_SECRET -var tenant_id=$TENANT_ID -var subscription_id=$SUBSCRIPTION_ID 
    echo -e "\n${GREEN}Terraform apply${ENDCOLOR}\n"
    terraform apply tfplan

    if [[ $? != 0 ]]; then
        echo "An error occured while applying infrastructure with terraform"
        exit 1
    fi

    echo -e "\n${GREEN}Outpout Lab Name${ENDCOLOR}:\n"
    lab_name=$(terraform output -raw lab_name)
    echo -e "$lab_name:\n"
    echo -e "\n${GREEN}Outpout Resource Group Name${ENDCOLOR}:\n"
    resource_group_name=$(terraform output -raw resource_group_name)
    echo -e "$resource_group_name:\n"
    echo -e "\n${GREEN}Outpout VM Names${ENDCOLOR}:\n"
    raw_vm_names=$(terraform output vm_names)
    vm_names_output=$(echo "$raw_vm_names" | sed -e 's/\[//g' -e 's/\]//g' -e 's/"//g' -e 's/,/ /g')
    vm_names=($vm_names_output)
    echo -e "${vm_names[@]}:\n"
    echo -e "\n${GREEN}Outpout VM IP addresses${ENDCOLOR}:\n"
    ipaddresses=()
    for vm_name in "${vm_names[@]}"; do
        vm=$($vm_name | tr '[:upper:]' '[:lower:]')
        ipaddresses+=$(az network public-ip show --resource-group t-clo-901-lil-2-items --name $vm | jq '.ipAddress')
    done
    echo -e "\n${GREEN}Outpout VM FQDNs${ENDCOLOR}:\n"
    raw_vm_fqdns=$(terraform output vm_fqdn)
    vm_fqdns_output=$(echo "$raw_vm_fqdns" | sed -e 's/\[//g' -e 's/\]//g' -e 's/"//g' -e 's/,/ /g')
    vm_fqdns=($vm_fqdns_output)
    echo -e "${vm_fqdns[@]}\n"


    echo -e "\n${GREEN}Claiming VMs${ENDCOLOR}:\n"
    for vm_name in "${vm_names[@]}"; do
        echo -e "${vm_name}\n"
        az lab vm claim -g $resource_group_name --lab-name $lab_name --name $vm_name || true
    done

    echo -e "\n${GREEN}Creating Ansible hosts.yml${ENDCOLOR}:\n"
    echo -e "all:\n  hosts:" > ansible/inventory/hosts.yml

    echo -e "\n${GREEN}Completing hosts.yml with fqdns${ENDCOLOR}:\n"
    for vm_fqdn in "${vm_fqdns[@]}"; do
        echo -e "${vm_fqdn}\n"
        echo -e "    $vm_fqdn:" >> ansible/inventory/hosts.yml
    done

    echo -e "\n${GREEN}Running Ansible playbook${ENDCOLOR}:\n"
    ansible-playbook -i ansible/inventory/hosts.yml ansible/configuration.yml
}

destroy() {
    terraform destroy --auto-approve
}

if [[ $1 == "create" ]]; then
    create
elif [[ $1 == "destroy" ]]; then
    destroy
else
    help_script
fi