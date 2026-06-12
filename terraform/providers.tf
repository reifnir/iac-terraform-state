provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = "prod"
      ManagedBy   = "Terraform. Noli me tangere!"
    }
  }
}

provider "aws" {
  alias  = "primary"
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = "prod"
      ManagedBy   = "Terraform. Noli me tangere!"
    }
  }
}

provider "aws" {
  alias  = "secondary"
  region = "us-west-2"

  default_tags {
    tags = {
      Environment = "prod"
      ManagedBy   = "Terraform. Noli me tangere!"
    }
  }
}
