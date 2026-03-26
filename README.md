🚀 Azure-Terraform Project Documentation

1️⃣ Project Overview

Project Name: azure-terraform
Purpose: Deploy a Linux VM (Ubuntu 24.04 LTS Gen2 x64) on Azure using Terraform. Includes networking, optional public IP, and secure SSH access.

Specifications:

Subscription: Azure for Students
Region: Switzerland North
VM Size: Standard_D2s_v3
OS: Ubuntu 24.04 LTS Gen2 x64

2️⃣ Project Structure & File Explanation
azure-terraform/
│   terraform.auto.tfvars       # Auto-generated variable values including SSH key
│   main.tf                     # Root configuration; calls modules
│   variables.tf                # Declares input variables
│   outputs.tf                  # Displays outputs like VM name, IPs
└───modules/
    ├───networking/
    │       main.tf             # Creates VNet, Subnet, NSG
    │       variables.tf        # Input variables: RG, location
    │       outputs.tf          # Outputs subnet ID for VM module
    │
    └───my-vm/
            main.tf             # Creates VM, NIC, optional Public IP
            variables.tf        # Input variables: VM name, size, username, SSH key, subnet ID
            outputs.tf          # Outputs VM ID, NIC ID, public IP

Key Notes:

Root files orchestrate the modules.
Networking module sets up VNet and Subnet for the VM.
VM module attaches VM to the network and optionally exposes it publicly.
terraform.auto.tfvars is auto-generated; do not edit manually.

3️⃣ Resource Relationships & Communication
VM → NIC → Subnet → VNet → Resource Group
Private IP: internal communication in subnet
Public IP (optional): external SSH access
NIC connects VM to subnet and VNet
OS Disk: stores VM system data

Network Flow:

Internet (optional) → Public IP → NIC → VM → Subnet → VNet → Resource Group

4️⃣ Deployment Steps
Step 1: Prerequisites
Install Terraform ≥1.5
Install Azure PowerShell or Azure CLI
Login:
Connect-AzAccount
Step 2: Generate SSH Key
ssh-keygen -t rsa -b 4096 -f $env:USERPROFILE\.ssh\id_rsa

Use the public key (.pub) only, in single-line format.

Step 3: Run PowerShell Deployment Script
deploy.ps1 will:
Prompt for VM name, RG, IP, location, size, SSH key path.
Read SSH key safely as one string.
Auto-generate terraform.auto.tfvars.
Run Terraform commands:
terraform fmt       # Format files
terraform init      # Initialize providers/modules
terraform validate  # Check syntax
terraform plan      # Preview resources
terraform apply     # Deploy resources

Credentials (TenantId, SubscriptionId) are hidden in the script.

Step 4: terraform.auto.tfvars (Auto-Generated)

Example:

location            = "switzerlandnorth"
resource_group_name = "syrine_rg"
vm_name             = "syrine_vm"
vm_size             = "Standard_D2s_v3"
admin_username      = "azureuser"
admin_ssh_key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQ..."
private_ip          = "10.0.1.18"
public_ip           = true

⚠️ Do not manually use file() or paste multi-line keys.

Step 5: SSH into VM
ssh azureuser@<public_ip> -i ~/.ssh/id_rsa
Step 6: Destroy Resources
terraform destroy

Cleans up all Azure resources to avoid costs.


5️⃣ Drift / Manual UI Changes

If you modify resources directly in the Azure Portal:

Terraform may detect differences (“drift”) and attempt to recreate resources.
Common drift issues:
Public IP or NIC changed → Terraform will try to revert or recreate
Subnet or VNet modified → may cause VM apply failure
Fix by either:
Updating Terraform to match the portal changes
Or revert portal changes and let Terraform manage resources

✅ Always consider Terraform as the source of truth.


6️⃣ Terraform Command Outputs & What They Generate
Command	Purpose	Resources Created / Affected
terraform fmt	Formats Terraform files	None
terraform init	Initializes providers & modules	Downloads AzureRM provider
terraform validate	Checks syntax	Detects configuration errors
terraform plan	Shows intended changes	Preview VM, NIC, Subnet, Public IP, RG creation
terraform apply	Deploys resources	Creates VNet, Subnet, NIC, VM, Public IP, OS disk
terraform destroy	Deletes all resources	Removes all created Azure resources

7️⃣ Architecture Diagram

Logical View:

Internet (optional)
   │
Public IP
   │
NIC → Private IP
   │
Subnet
   │
VNet
   │
Resource Group

Physical View:

VM hosted in Switzerland North
OS Disk on Standard_LRS
NIC attaches VM to subnet & VNet
Public IP allows SSH from Internet

8️⃣ Best Practices
Terraform = source of truth; avoid manual Azure edits
SSH key = single-line public key
Use auto-generated .tfvars via PowerShell script
Keep sensitive info out of repositories

9️⃣ Useful Terraform Commands
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
terraform destroy

✅ This README explains:

Project structure & file purposes
Deployment steps & Terraform commands
Resource relationships & communication
Drift handling (manual changes in Azure)
SSH setup & best practices

