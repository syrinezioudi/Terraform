param(
    [string]$TenantId       = "------------",
    [string]$SubscriptionId = "------------",
    [string]$TerraformDir   = "D:\azure-terraform\terraform"
)

function Write-Info($msg){ Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Ok($msg){ Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Warn($msg){ Write-Host "[WARN] $msg" -ForegroundColor Yellow }

# --- Azure login ---
Write-Info "Connecting to Azure..."
Connect-AzAccount -TenantId $TenantId -SubscriptionId $SubscriptionId | Out-Null
Set-AzContext -TenantId $TenantId -SubscriptionId $SubscriptionId | Out-Null
Write-Ok "Connected to Azure"

# --- Gather input ---
$rgName      = Read-Host "Resource Group name (will be created)"
$vmName      = Read-Host "VM name"
$privIp      = Read-Host "Private IP (e.g., 10.0.1.10)"
$location    = Read-Host "Azure location (e.g., switzerlandnorth)"
$vmSize      = Read-Host "VM Size (e.g., Standard_D2s_v3)"
$sshKeyPath  = Read-Host "Path to SSH public key"

# --- Read SSH key ---
$sshKey = (Get-Content -Path $sshKeyPath -Raw).Trim()
# --- Generate terraform.auto.tfvars ---
$tfvars = Join-Path $TerraformDir "terraform.auto.tfvars"

@"
location            = "$location"
resource_group_name = "$rgName"
vm_name             = "$vmName"
vm_size             = "$vmSize"
admin_username      = "azureuser"
admin_ssh_key       = "$sshKey"
private_ip          = "$privIp"
public_ip           = true
"@ | Set-Content -Path $tfvars -Encoding UTF8

Write-Ok "Generated terraform.auto.tfvars at $tfvars"

# --- Run Terraform ---
Push-Location $TerraformDir

Write-Info "Formatting Terraform files..."
terraform fmt -recursive

Write-Info "Initializing Terraform..."
terraform init

Write-Info "Validating Terraform..."
terraform validate

Write-Info "Planning Terraform..."
terraform plan

$apply = Read-Host "Type APPLY to deploy resources"
if ($apply -eq "APPLY") {
    Write-Info "Applying Terraform..."
    terraform apply -auto-approve
    Write-Ok "Deployment completed!"
} else {
    Write-Warn "Terraform apply skipped."
}

Pop-Location
