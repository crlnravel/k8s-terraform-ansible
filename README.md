# Kubernetes Cluster Deployment with Terraform & Ansible

This project automates the creation and configuration of a **Kubernetes cluster on Google Cloud Platform (GCP)** using **Terraform** for infrastructure provisioning and **Ansible** for post-deployment setup.

## 📦 Project Structure

```
.
├── ansible/                # Contains Ansible playbooks and configuration
├── terraform/              # Contains Terraform modules and configs for GCP infrastructure
├── bootstrap.sh            # Main entrypoint to manage deployment
└── README.md
```

## 🚀 Features

- **Infrastructure provisioning** with Terraform (VMs, firewall, etc.)
- **Kubernetes setup** via Ansible on provisioned VMs
- **Interactive CLI** with confirmation prompts
- **Verbose logging support** (`--verbose` flag)
- **Simple start/stop interface**

## 🔧 Requirements

- [Terraform](https://www.terraform.io/)
- [Ansible](https://www.ansible.com/)
- [gcloud CLI](https://cloud.google.com/sdk/docs/install)
- `jq`, `ssh`, `bash`

Make sure your Google Cloud credentials are properly authenticated via `gcloud auth login`.

## 📜 Usage

### Start the Cluster

This will:

1. Provision infrastructure using Terraform
2. Wait for SSH access to be ready
3. Run Ansible playbook to initialize the Kubernetes cluster

```bash
chmod +x ./bootstrap.sh  # must be run for the first time
./bootstrap.sh start
```

You will be asked for confirmation before proceeding.

To see full logs:

```bash
./bootstrap.sh start --verbose
```

### Stop and Destroy the Cluster

This will destroy all infrastructure provisioned by Terraform:

```bash
./bootstrap.sh stop
```

With logs:

```bash
./bootstrap.sh stop --verbose
```

### Show Help

```bash
./bootstrap.sh help
```

## 📂 Inventory

Update `inventory.ini` with the IPs of provisioned VMs. This is automatically fetched from Terraform output (`all_ips`).

Example Terraform output snippet:

```hcl
output "all_ips" {
  value = [google_compute_instance.vm.*.network_interface[0].access_config[0].nat_ip]
}
```

## 📣 Notes

- This project assumes you're deploying on **Ubuntu-based GCP instances**.
- SSH key should be available at `~/.ssh/id_rsa` unless modified.

---

Happy shipping! ☁️🚀
