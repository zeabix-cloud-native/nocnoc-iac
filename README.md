# Performance Cluster

This workflow require URL secret environment

<img width="267" alt="image" src="https://user-images.githubusercontent.com/46469458/201837580-f76839fc-ec8d-486d-8f12-5e0eaac82e08.png">
<img width="790" alt="image" src="https://user-images.githubusercontent.com/46469458/201837660-28503a02-836f-4d6f-b275-d666db6c8450.png">

## Terraform_Plan job
1. Checkout source code
<img width="243" alt="image" src="https://user-images.githubusercontent.com/46469458/201816057-a8e9c52e-dd78-4a40-b6d2-4add09b3918d.png">

2. Initial AWS Account
<img width="479" alt="image" src="https://user-images.githubusercontent.com/46469458/201816172-2a24adcb-093d-4035-8ab4-415d4e63b189.png">

** This task require 3 secrets
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION
<img width="796" alt="image" src="https://user-images.githubusercontent.com/46469458/201816369-02ab576b-f829-428c-b7de-dd671b52ed7f.png">

3. Setup Terraform
<img width="282" alt="image" src="https://user-images.githubusercontent.com/46469458/201816540-29a7b265-d996-431f-b579-174463e49cf1.png">

4. Terraform format

Rewrite Terraform configuration files to a canonical format and style.

<img width="349" alt="image" src="https://user-images.githubusercontent.com/46469458/201816760-8e56ac7e-8df3-4013-8db8-84cf34b0dbd9.png">

5. Terraform initial

Initializes a working directory containing Terraform configuration files.

<img width="198" alt="image" src="https://user-images.githubusercontent.com/46469458/201816985-8cd62c4d-e43d-4df5-9191-ff05b2722fa2.png">

6. Terraform Validate

Validates the configuration files in a directory.

<img width="281" alt="image" src="https://user-images.githubusercontent.com/46469458/201817196-2ac31499-315b-4d60-842f-cb5514dacfbe.png">

7. Terraform plan

Creates an execution plan and generate output name `tf_plan` , which lets you preview the changes that Terraform plans to make to your infrastructure.

<img width="443" alt="image" src="https://user-images.githubusercontent.com/46469458/201817392-ebac424e-6ec9-492c-8ca7-5a36fcaed242.png">

8. Upload TF Plan

Upload `tf_plan` file and store it in the artifact.

<img width="292" alt="image" src="https://user-images.githubusercontent.com/46469458/201817821-d71398d7-263c-40bb-a2eb-00f1d89e15b4.png">


## Terraform_Apply

Run this job after previous job done.

<img width="176" alt="image" src="https://user-images.githubusercontent.com/46469458/201818527-e621765d-97eb-4220-bc2e-237d33119bbf.png">

1. Checkout source code
<img width="243" alt="image" src="https://user-images.githubusercontent.com/46469458/201816057-a8e9c52e-dd78-4a40-b6d2-4add09b3918d.png">

2. Initial AWS Account
<img width="479" alt="image" src="https://user-images.githubusercontent.com/46469458/201816172-2a24adcb-093d-4035-8ab4-415d4e63b189.png">

** This task require 3 secrets
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION
<img width="796" alt="image" src="https://user-images.githubusercontent.com/46469458/201816369-02ab576b-f829-428c-b7de-dd671b52ed7f.png">
 
3. Download tf_plan file 

Download `tf_plan` file from artifact.

<img width="279" alt="image" src="https://user-images.githubusercontent.com/46469458/201818801-25ffc191-e7ca-4360-bab7-a411ad82cdf3.png">

4. Login to Amazon ECR

<img width="298" alt="image" src="https://user-images.githubusercontent.com/46469458/201819101-c90e5de3-ee1f-4752-87ec-1140a27ee657.png">

5. Setup Terraform

<img width="282" alt="image" src="https://user-images.githubusercontent.com/46469458/201816540-29a7b265-d996-431f-b579-174463e49cf1.png">

6. Terraform initial

Initializes a working directory containing Terraform configuration files.

<img width="198" alt="image" src="https://user-images.githubusercontent.com/46469458/201816985-8cd62c4d-e43d-4df5-9191-ff05b2722fa2.png">

7. Terraform Apply

Executes the actions proposed in a Terraform plan (`tf_plan`).

<img width="255" alt="image" src="https://user-images.githubusercontent.com/46469458/201819608-b32ebd95-d85a-48f3-a27d-1c78625f0520.png">

8. Update Kubeconfig

Update kubernetes configuration on runner

<img width="858" alt="image" src="https://user-images.githubusercontent.com/46469458/201838361-960a413a-ff26-4483-9222-b186745c1549.png">

9. Install kubectl command

Install kubectl command

<img width="272" alt="image" src="https://user-images.githubusercontent.com/46469458/201838561-e7676ff7-6d3f-4d93-8e85-4d8eaec27dc7.png">

10. Test kubectl command

Test kubectl command after install

<img width="225" alt="image" src="https://user-images.githubusercontent.com/46469458/201838723-893cebff-94a7-4907-bc57-a04a9574d7c8.png">

11. Upload tfstate file 

Upload `terraform.tfstate` file and store it in the artifact.

<img width="264" alt="image" src="https://user-images.githubusercontent.com/46469458/201819776-77e10fa6-d593-42cf-a6d7-b217a5e71df6.png">

12. Upload kubeconfig file 

Upload `config` file and store it in the artifact.

<img width="289" alt="image" src="https://user-images.githubusercontent.com/46469458/201838864-a4540625-c2a3-4e8f-bf97-8750509cd084.png">

13. Verify application started 

Run script to verify application started

<img width="517" alt="image" src="https://user-images.githubusercontent.com/46469458/201839092-7cc23d34-6d50-4840-bef5-f405067963aa.png">

14. Chane URL in k6 script

Change URL before run test

<img width="437" alt="image" src="https://user-images.githubusercontent.com/46469458/201839432-0b6e76d0-0162-493c-aeb5-9409ef5a7589.png">

15. Run Performance test

Run performance test cluster

<img width="729" alt="image" src="https://user-images.githubusercontent.com/46469458/201839552-8e4d328a-eec2-4827-9fce-1ab60a64b388.png">

Reference : https://k6.io/docs/using-k6/k6-options/reference/

16. Upload performance test cluster result

Upload performance test cluster result from previous step

<img width="311" alt="image" src="https://user-images.githubusercontent.com/46469458/201839934-98d2bade-e4bf-4fc5-8a02-7034a4c33d1d.png">


## Terraform_Destroy

Always run this job after previous job failed or finished.

<img width="211" alt="image" src="https://user-images.githubusercontent.com/46469458/201820221-9558ab20-5245-4d48-b9ba-037b28c2ef95.png">

1. Checkout source code
<img width="243" alt="image" src="https://user-images.githubusercontent.com/46469458/201816057-a8e9c52e-dd78-4a40-b6d2-4add09b3918d.png">

2. Initial AWS Account
<img width="479" alt="image" src="https://user-images.githubusercontent.com/46469458/201816172-2a24adcb-093d-4035-8ab4-415d4e63b189.png">

** This task require 3 secrets
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION
<img width="796" alt="image" src="https://user-images.githubusercontent.com/46469458/201816369-02ab576b-f829-428c-b7de-dd671b52ed7f.png">
 
3. Download tfstate file 

Download `terraform.tfstate` file from artifact.

<img width="282" alt="image" src="https://user-images.githubusercontent.com/46469458/201820515-d57e7d26-9966-40cc-b0b1-6f44bc07232d.png">

4. Setup Terraform

<img width="282" alt="image" src="https://user-images.githubusercontent.com/46469458/201816540-29a7b265-d996-431f-b579-174463e49cf1.png">

5. Terraform initial

Initializes a working directory containing Terraform configuration files.

<img width="198" alt="image" src="https://user-images.githubusercontent.com/46469458/201816985-8cd62c4d-e43d-4df5-9191-ff05b2722fa2.png">

6. Terraform plan destroy

Plan before destroy.

<img width="245" alt="image" src="https://user-images.githubusercontent.com/46469458/201820619-b823c979-cbb8-4d4c-900a-97aff4117b87.png">

7. Terraform Destroy

Destroy all remote objects managed by a particular Terraform configuration.

<img width="402" alt="image" src="https://user-images.githubusercontent.com/46469458/201820753-e0880ca8-8452-427b-8301-95785f9cf12c.png">
