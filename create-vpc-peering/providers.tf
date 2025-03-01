provider "aws" {
  region = var.master-region
  alias  = "master-region"
}

provider "aws" {
  region = var.worker-region
  alias  = "worker-region"
}