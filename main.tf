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

resource "cloudstack_instance" "windows_iis" {
  name             = "windows2022-iis"
  service_offering = "CD-I-2-12"
  template         = "WIN2022-UEFI-CLOUDINIT-TMPLT"
  root_disk_size   = "100"
  zone             = "us-mi-lab-01"
  network_id       = "70e12960-4bcf-4fe3-ad2c-9d7b59e6172d"
  uefi             = "true"

  user_data = base64encode(<<EOF
#cloud-config
write_files:
  - path: C:\install_iis_winrm.ps1
    content: |
      # Enable WinRM
      winrm quickconfig -q
      winrm set winrm/config/service/auth @{Basic="true"}
      winrm set winrm/config/service @{AllowUnencrypted="true"}
      winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1024"}
      Set-Item wsman:\localhost\Client\TrustedHosts -Value "10.200.1.170"
      
      # Set default admin password
      $password = ConvertTo-SecureString "USSignal!" -AsPlainText -Force
      $admin = [ADSI]"WinNT://./Administrator,User"
      $admin.SetPassword($password)
runcmd:
  - powershell.exe -ExecutionPolicy Bypass -File C:\install_iis_winrm.ps1
  EOF
  )

  provisioner "winrm" {
    connection {
      type     = "winrm"
      user     = "Administrator"
      password = "USSignal!"
      host     = self.ip_address
    }

    inline = [
      "Install-WindowsFeature -name Web-Server -IncludeManagementTools"
    ]
  }
}

output "windows_iis_id" {
  value = cloudstack_instance.windows_iis.id
}

output "windows_iss_ip" {
  value = cloudstack_instance.windows_iis.ip_address
}


