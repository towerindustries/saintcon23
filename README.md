# SaintCon 2023 - Cloud Automation with Terraform
## David Thurm: @packetmonster
## Introduction
This repository contains the code and instructions for the Intro to Cloud Automation with Terraform workshop.  This workshop will cover the basics thru moderately advanced of Terraform and how to use it to automate the creation of cloud resources.  We will be using AWS as our cloud provider for this workshop, but the concepts can be applied to other cloud providers as well.

## Prerequisites -- To be done **BEFORE** the day of class
* AWS Account
* AWS CLI
* Terraform
* Git
* Text Editor

## AWS Account
You will need your own AWS account to complete this workshop.  If this is a major issue for you I can allow access to my personal AWS account.  

If you do not already have an AWS account, you can create one [here](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/).  You will need to provide a credit card to create an AWS account.  Services created today have little to no cost depending on how long you leave them running.  If this a new AWS account all services will be free.  If you are over the free-tier limit, you will be charged around $1.00 for the services created today.

If you are concerned about being charged for resources, you can set up a billing alarm in the AWS console to notify you if your account exceeds a certain amount.

## AWS CLI
The AWS CLI is a command line tool that allows you to interact with AWS services from the command line.  You can download the AWS CLI [here](https://aws.amazon.com/cli/).  Once you have the AWS CLI installed, you will need to configure it with your AWS credentials.

```
# AWS CLI Login
## Generate Access Key
1. Login to AWS Console
2. Click on your name in the top right corner
3. Click on "Security Credentials"
5. Click on "Create Access Key"
6. Click on "Show Access Key"
7. Copy Access Key and Secret Key to Notepad
8. Click on "Download .csv file" (Optional)
9. Click on "Done"
```
Login from the CLI
```
# AWS CLI Authentication
aws configure
AWS Access Key ID: <enter your access key>
AWS Secret Access Key: <enter your secret key>
Default region name: us-east-1
Default output format: json
```
Test the CLI
```
aws sts get-caller-identity
```
## Terraform
Terraform is an open source tool that allows you to automate the creation of cloud resources.  You can download Terraform [here](https://www.terraform.io/downloads.html).  Once you have Terraform installed, you will need to add it to your PATH.  You can find instructions on how to do that [here](https://stackoverflow.com/questions/14637979/how-to-permanently-set-path-on-linux-unix).

## Text Editor
You will need a text editor to edit the Terraform files.  You can use any text editor you like, but I recommend using [Visual Studio Code](https://code.visualstudio.com/).

Install VScode on your local workstation with the following extensions:
* HashiCorp Terraform
  
## Clone the Repository
Git is a version control system that allows you to track changes to files.  Download git from [here](https://git-scm.com/downloads) and install it on your local workstation.  Once you have git installed, you will need to clone the repository to your local workstation.  You can do this by running the following command:
```
git clone https://github.com/towerindustries/saintcon23.git
```
Once you have Git installed, you will need to configure it with your name and email address.  You can find instructions on how to do that [here](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup).


