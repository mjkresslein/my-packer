packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "firstrun-windows" {
  ami_name      = "packer-windows-build-${local.timestamp}"
  communicator  = "winrm"
  instance_type = "t3.xlarge"
  region        = "${var.region}"
  source_ami_filter {
    filters = {
      name                = "Windows_Server-2022*English-Full-SQL_2022_Enterprise*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  user_data_file = "./scripts/bootstrap_win.txt"
  winrm_password = "SuperS3cr3t!!!!"
  winrm_username = "Administrator"

  tags = {
    Name = "packer-windows-build-${local.timestamp}"
    Environment = "${var.environment}"
    Retention = "Deregister"
    CreatedBy = "${var.ops_user} with Packer"
  }
}

build {
  name    = "sample-packer"
  sources = ["source.amazon-ebs.firstrun-windows"]

  provisioner "powershell" {
    environment_vars = ["DEVOPS_LIFE_IMPROVER=PACKER"]
    inline           = ["Write-Host \"HELLO NEW USER; WELCOME TO $Env:DEVOPS_LIFE_IMPROVER\"", "Write-Host \"You need to use backtick escapes when using\"", "Write-Host \"characters such as DOLLAR`$ directly in a command\"", "Write-Host \"or in your own scripts.\""]
  }
  provisioner "windows-restart" {
  }
  provisioner "powershell" {
    environment_vars = ["VAR1=A$Dollar", "VAR2=A`Backtick", "VAR3=A'SingleQuote", "VAR4=A\"DoubleQuote"]
    script           = "./scripts/sample_script.ps1"
  }
  provisioner "powershell" {
    environment_vars = [
      "ssmsPath=C:\\Program Files (x86)\\Microsoft SQL Server Management Studio 18\\Common7\\IDE\\Ssms.exe",
      "latestVersionUrl=https://aka.ms/ssmsfullsetup",
      "downloadPath=C:\\Windows\\Temp\\SSMS-Setup.exe"
    ]
    script = "./scripts/update_ssms.ps1"
  }
}
