## Test Ocean

Simple Terraform environment used to quickly spin up droplets on Digital Ocean for ad-hoc testing of things such as scripts, recipes, playbooks, etc against a fresh Enterprise Linux installation.

### Requirments

* Digital Ocean account
* Terraform v0.10.x or later

### Setup

1. Create a Digital Ocean account if you don't already have one

2. After logging into your Digital Ocean account, navigate to API and create a new Personal Access Token (copy this as you will need the key in step #6)

3. Go to Account -> Settings -> Security and click Add SSH Key to configure your public key for authorization on newly created droplets (make note of the Fingerprint displayed after you save the newly added SSH key as you will need this fingerprint in step #6)

4. Clone this repository to a local directory of your choice

5. Copy `terraform.tfvars.sample` to `terraform.tfvars`

6. Configure your API key (from step #2) and SSH key fingerprint (from step #3) in `terraform.tfvars`

7. Run `terraform init` from the repository root

8. Your test ocean is ready for surfing! See the Usage section below for how to start your droplets.

### Usage

Each of the commands below should be run locally from the repository root. Also note that when running `terraform apply` without any parameters nothing is spun up by default:

```bash
$ terraform apply

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

droplet_ipv4_addresses = {}
```

You can alter this behaviour by setting a different default `droplet_count` value in the `terraform.tfvars` file but note that this will change the procedure for terminating droplets to using the `terraform destroy` command vs what is documented below.

#### Spawning Droplets

To spin up your test ocean, run the `terraform apply` command specifying how many droplets you would like spun up like so:

    terraform apply -var droplet_count=5

Reference the `droplet_ipv4_addresses` output on the CLI for the names and corresponding IP addresses of spawned droplets.

#### Terminating Droplets

To terminate all droplets in your test ocean, simply run `terraform apply` with no `droplet_count` specified. This effectively executes with a `droplet_count` of "0" resulting in the previously spawned droplets being destroyed.

    terraform apply