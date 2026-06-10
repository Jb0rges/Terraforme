# Configurações globais do Terraform
terraform {

  # Providers necessários para o projeto
  required_providers {

    aws = {

      # Provider oficial da AWS
      source = "hashicorp/aws"

      # Versão utilizada
      version = "~> 5.0"
    }
  }
}

# Configuração da AWS
provider "aws" {

  # Região onde os recursos serão criados
  region = "us-east-1"

  # Caso utilize AWS Academy ou credenciais temporárias
  access_key = ""
  secret_key = ""
  token      = ""
}
