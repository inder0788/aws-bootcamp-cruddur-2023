# Week 0 — Billing and Architecture

## Initial set up by Root User

### IAM User Creation
For performing various tasks during the bootcamp an IAM user was created as below-
- Logged in as root user.
- Created a user named `ips` from the IAM console.
- `Enabled console access` for the user.
- User was added to the `Admin` group.
- Created `Access Key` from `Security Credentials` tab for CLI access.
- Download the CSV with the credentials

### Enable Billing 

Enabled biling alerts for the AWS account from Billing page using root user.

### MFA enabled for root and admin user

MFA was set up for the root and admin users using Virtual authenticator app.


## Configuration with Admin User.

### Gitpod Workspace Set Up

Gitpod will be used for development in the Bootcamp, so aws cli was installed in the gitpod workspace using gitpod.yml. Two ways were tried-
- INIT - It installs CLI during new workspace creation but on workspace restart AWS CLI will be lost.
- COMMAND - Executes whenever a workspace is created/restarted, so AWS CLI will always be available.

### Install AWS CLI

Updated `.gitpod.yml` to include the following task.

```sh
tasks:
  - name: aws-cli
    env:
      AWS_CLI_AUTO_PROMPT: on-partial
    command: |
      cd /workspace
      rm -rf aws          # Delete existing installation if any.
      rm -f awscliv2.zip  # Delete existing setup file if any.
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
      unzip awscliv2.zip
      sudo ./aws/install
      cd $THEIA_WORKSPACE_ROOT
```

### Store User Credentials for Gitpod Workspace

```
gp env AWS_ACCESS_KEY_ID="ABCDEFGHIJKLMNOP"
gp env AWS_SECRET_ACCESS_KEY="ABCD_1234_EFGHIJKL"
gp env AWS_DEFAULT_REGION="us-east-1"
```
