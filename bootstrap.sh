#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

VERBOSE=false

# Cek semua argumen
ARGS=()
for arg in "$@"; do
  if [[ "$arg" == "--verbose" ]]; then
    VERBOSE=true
  else
    ARGS+=("$arg")
  fi
done

function confirm() {
  echo
  read -p "Are you sure you want to continue? (y/n): " confirm
  if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo -e "${RED} Operation stopped.${NC}"
    exit 0
  fi
}

function run() {
  if [ "$VERBOSE" = true ]; then
    eval "$1"
  else
    eval "$1" > /dev/null
  fi
}

function start() {
  echo -e "${YELLOW}⚠️  This command will run:${NC}"
  echo "  1. Terraform apply"
  echo "  2. Ansible playbook"
  confirm

  echo -e "${GREEN}Executing terraform...${NC}"
  run "terraform -chdir=./terraform apply -auto-approve"

  echo -e "${GREEN}Getting IPs from terraform...${NC}"
  IPS=$(terraform -chdir=./terraform output -json all_ips | jq -r '.[]')
  echo "IP addresses fetched"

  echo -e "${GREEN}Waiting for SSH to be ready...${NC}"
  for IP in $IPS; do
    until ssh -o StrictHostKeyChecking=no -i $HOME/id_rsa ubuntu@$IP "echo 'SSH Ready'" > /dev/null 2>&1; do
      echo "Waiting for $IP..."
      sleep 2
    done
    echo "$IP is ready"
  done

  echo -e "${GREEN}Executing Ansible...${NC}"
  run "ANSIBLE_CONFIG=./ansible/ansible.cfg ansible-playbook ./ansible/setup_k8s_cluster.yml -i ./inventory.ini"

  echo -e "${GREEN}Your Kubernetes cluster has been deployed!${NC}"
}

function stop() {
  echo -e "${YELLOW}⚠️  This command will delete the Kubernetes cluster including the resources in it${NC}"
  confirm

  echo -e "${GREEN}Executing terraform destroy...${NC}"
  run "terraform -chdir=./terraform destroy -auto-approve"

  echo -e "${GREEN}All resources has been cleaned up.${NC}"
}

function help_menu() {
  echo -e "${YELLOW}Usage:${NC} ./deploy.sh [start|stop|help] [--verbose]"
  echo
  echo "  start      - Bootstrap a Kubernetes cluster"
  echo "  stop       - Destroy Kubernetes Cluster"
  echo "  help       - Show help menu"
  echo 
  echo "Options:"
  echo "  --verbose  - Show full logs (terraform, ansible, etc)"
}

# Jalankan command yang ditemukan di ARGS[0]
case "${ARGS[0]}" in
start)
  start
  ;;
stop)
  stop
  ;;
help | "")
  help_menu
  ;;
*)
  echo -e "${RED}Unknown command: ${ARGS[0]}${NC}"
  help_menu
  exit 1
  ;;
esac
