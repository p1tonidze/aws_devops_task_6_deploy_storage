# AWS Essentials: Deploy storage

Now, when you are familiar with S3 service, let's deploy one for backups of your Gradana deployment!

## Prerequirements

Before completing any task in the module, make sure that you followed all the steps described in the **Environment Setup** topic, in particular: 

1. Make sure you have an [AWS](https://aws.amazon.com/free/) account.

2. Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

3. Install [PowerShell Core](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.4).

4. Install [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

5. Log in to AWS CLI on your computer by running the command:
   
    ```
    aws configure
    ```

## Task Requirements 

In this task, you will deploy a S3 bucket and configure access to it from your Grafana VM you deployed in the [previous task](https://github.com/mate-academy/aws_devops_task_5_use_iam_roles). With such infrastructure in place, you potentially can write a script, which uploads backups of your Grafana deployment to the S3 bucket (but such script is not included in the task scope). 

To complete this task: 

1. Edit `terraform.tfvars` - fill out the `tfvars` file with the previous modules' outputs and your configuration variables. You should use those variables as parameters for the resources in this task. This task requires only one variable - `grafana_iam_role_arn`. You can get it as terraform module output in the [previous task](https://github.com/mate-academy/aws_devops_task_5_use_iam_roles). 

3. Edit `main.tf` — add resources, required for this task: 
    
    - use [`aws_s3_bucket`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) resource to create a S3 bucket. 

    - use [`aws_s3_bucket_policy`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) and `aws_iam_policy_document` resources to authorize your Grafana VM to use S3 bucket using bucket policy. For that, `aws_iam_policy_document` resource should have two statements: 

        - both statements should use grafana IAM role ARN as identifier (principal type - AWS) 

        - first statement should allow action `s3:ListBucket` only for the S3 bucket you deployed 

        - second statement should allow `s3:GetObject` and `s3:PutObject` for all objects within the bucket you deployed 

4. After adding the code to the `main.tf`, review the file `outputs.tf` and make sure, that all output variables are valid and can output relevant values, as described in the output variable descriptions. 

5. Run the following commands to generate a Terraform execution plan in **JSON** format: 

    ```
    terraform init
    terraform plan -out=tfplan
    terraform show -json tfplan > tfplan.json
    ```

6. Run an automated test to check yourself:
 
    ```
    pwsh ./tests/test-tf-plan.ps1
    ```

If any test fails, please check your task code and repeat step 4 to generate a new tfplan.json file. 

7. Deploy infrastructure using the following command: 
    
    ```
    terraform apply
    ```
    Make sure to collect module output. 

8. Connect to your Grafana EC2 instance from the previous task, and run the following script, replacing <bucket> with name of your S3 bucket: 
    ```
        wget https://github.com/mate-academy/aws_devops_task_6_deploy_storage/raw/refs/heads/main/files/title.mp4 -O title.mp4
        aws s3 cp title.mp4 s3://<bucket>/
    ```
Validate that the file was uploaded to the S3 bucket from your VM, and make a screenshot of command execution. 

9. Commit file `tfplan.json` and the screenshot from the VM, and submit your solution for review. 
10. Go and watch that video, you uploaded to your S3 bucket - this is the last task in the module! Well done! 
