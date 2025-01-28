terraform {
  required_providers {
    cloudstack = {
<<<<<<< HEAD
      source = "cloudstack/cloudstack"
      version = "0.5.0"
=======
      source  = "cloudstack/cloudstack"
      version = ">= 0.5.0"
>>>>>>> 0e78533 (init commit)
    }
  }
}

provider "cloudstack" {
<<<<<<< HEAD
  # Configuration options
  api_url    = "https://opencloud.lab.ussignal.cloud/client/api"
  api_key    = "SMf_vY9-snJ-8hjABCdGVE1mHmNYw_Pf7f-8bm0KKgCvynQ5mzjHxlN9L2S0rbMlYoRe7SQYr2cBC8Wcx2-N2A"
  secret_key = "V-6PzSmIGE8hHpZN-zdgyIXV5fxW47HPkEMUiHhJGEsl6AL4FMq81sKEB9-T620vM_cMai3cYg5acHgdPKDZ-Q"
}

resource "cloudstack_instance" "web" {
  name             = "server-1"
  service_offering = "CD-I-1-6"
  network_id       = "36d27cc1-ca66-4820-a9c2-e97e8fc6dc1b"
  template         = "2fc0baa7-aac4-4a6e-9f39-347e698074e6"
  zone             = "c0a13a87-5076-4f3f-a4ba-66d1a05eafb1"
}
=======
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


>>>>>>> 0e78533 (init commit)
