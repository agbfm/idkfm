# Infrastructure

## Terraform

Most (if not all) of the relevant infrastructure is managed by Terraform, and currently deployed locally.

### Environment variables

To get started, make a copy of the `example.tfvars` file named `terraform.tfvars` and update the environment variables.

```tfvars
// infra/terraform/example.tfvars

github_token          = ""
cloudflare_account_id = ""
cloudflare_api_token  = ""
cloudflare_zone_id    = ""
discord_token         = ""
discord_server_id     = ""
```

### Deploying changes

Until CI/CD has been configured, all changes must be deployed locally:

```bash
cd infra/terraform
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

---

## To do list

- [ ] Configure GitHub Actions to deploy Terraform changes