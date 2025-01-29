terraform {
  required_providers {
    cloudstack = {
      source  = "cloudstack/cloudstack"
      version = ">= 0.5.0"
    }
  }
}

provider "cloudstack" {
  api_url    = var.api_url
  api_key    = var.api_key
  secret_key = var.secret_key
}


resource "cloudstack_instance" "iis_server" {
  name             = "www01"
  service_offering = "CD-I-2-12"
  template         = "WIN2022-UEFI-CLOUDINIT-TMPLT"
  root_disk_size   = "100"
  zone             = "us-mi-lab-01"
  network_id       = "70e12960-4bcf-4fe3-ad2c-9d7b59e6172d"
  uefi             = "true"
  
  user_data = <<-EOF
    #cloud-config
    write_files:
      - path: C:\\setup.ps1
        content: |
          Install-WindowsFeature -name Web-Server -IncludeManagementTools
          Restart-Computer
    runcmd:
      - powershell.exe -ExecutionPolicy Unrestricted -File C:\\setup.ps1
  EOF
}


