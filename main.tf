terraform {
  required_providers {
    cloudstack = {
      source = "cloudstack/cloudstack"
      version = "0.5.0"
    }
  }
}

provider "cloudstack" {
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