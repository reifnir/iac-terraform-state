terraform {
  backend "http" {
    address        = "https://gitlab.com/api/v4/projects/83231681/terraform/state/terraform-state"
    lock_address   = "https://gitlab.com/api/v4/projects/83231681/terraform/state/terraform-state/lock"
    unlock_address = "https://gitlab.com/api/v4/projects/83231681/terraform/state/terraform-state/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
    retry_wait_max = 10
    retry_max      = 3
    # Passed via environment variables:
    # - username as TF_HTTP_USERNAME
    # - password as TF_HTTP_PASSWORD
  }
}
