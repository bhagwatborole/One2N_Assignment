######  One2N Assignment  ######
1) Problem Statement
      The task consists of two parts:

- Part 1: HTTP Service

      Develop an HTTP service with a GET endpoint:
      http://IP:PORT/list-bucket-content/<path>
      
      This endpoint lists the contents of an S3 bucket based on the provided <path>. If no path is specified, the service returns the 
      top-level contents.

      Examples:

      Top-level contents:
      Request: http://IP:PORT/list-bucket-content
      Response: {"content": ["dir1", "dir2"]}

      Specific directory contents:
      Request: http://IP:PORT/list-bucket-content/dir1
      Response: {"content": []}

      Request: http://IP:PORT/list-bucket-content/dir2
      Response: {"content": ["file1", "file2"]}

      Non-existing path:
      Request: http://IP:PORT/list-bucket-content/non-existing
      Response: {"error": "Path does not exist"}

- Part 2: Infrastructure Provisioning
      Using Terraform, create an AWS infrastructure to deploy the service. The solution provisions the following:

      An EC2 instance running the HTTP service.
      A security group allowing traffic on ports 22 and 5000.
      IAM roles for S3 read-only access.
      
####

2) solution

- Repository Structure.     
    ├── terraform/.                                             
        │   ├── main.tf                   # Terraform configuration for AWS infrastructure.   
        │   ├── setup_instance.sh         # User data script for instance setup.  
    ├── list_bucket.py                # Flask application for the HTTP service.  
    ├── requirements.txt              # Python dependencies.  
    ├── README.md                     # Project documentation.  
_________________________________________________________________________________________________________________________________________

- Prerequisites.         
      Terraform.  
      AWS Free Tier Account.  
_________________________________________________________________________________________________________________________________________
      
- Deployment Instructions.    
- Step 1: Clone the Repository.

      git clone https://github.com/bhagwatborole/One2N_Assignment
      cd One2N_Assignment/terraform
      
- Step 2: Configure AWS Credentials

      Export your AWS credentials:
      export AWS_ACCESS_KEY_ID=your-access-key
      export AWS_SECRET_ACCESS_KEY=your-secret-key
      
- Step 3: Deploy Infrastructure

      Initialize Terraform:
      terraform init
      Apply the Terraform configuration:
      terraform apply
      
- Confirm when prompted. Terraform will:

      Create an EC2 instance.
      Deploy the HTTP service automatically using the setup_instance.sh script.
      Upon completion, Terraform will output the public IP and URLs:

- Outputs:

      instance_url = "http://<public_ip>:5000/list-bucket-content"
      instance_test1_url = "http://<public_ip>:5000/list-bucket-content/test1"
      instance_test2_url = "http://<public_ip>:5000/list-bucket-content/test2"
      
- Step 4: Access the Application
      Visit the URLs provided in the Terraform output to interact with the service.
_________________________________________________________________________________________________________________________________________

3) Design Decisions
- Automated Deployment:

      The setup_instance.sh script ensures that the application is deployed and running as soon as the EC2 instance is launched.

- Error Handling:

      Handles invalid paths by returning a 404 error.
Logs errors and warnings using a rotating file handler.
      Terraform for Infrastructure:
Terraform provisions AWS resources, including EC2 instances, security groups, and IAM roles.

- Screenshots

- Success Case:

      Top-Level Content
![Annotation 2024-12-05 210529](https://github.com/user-attachments/assets/3c5ddb67-8dd8-47eb-98ba-93be16c79bee)

_________________________________________________________________________________________________________________________________________

      Directory Content
![Annotation 2024-12-05 210552](https://github.com/user-attachments/assets/0ef87923-2a7f-430e-80bd-7addfe252fd3)

_________________________________________________________________________________________________________________________________________

      Directory without Content
![Annotation 2024-12-05 210454](https://github.com/user-attachments/assets/6f9c3342-976c-4727-b6fd-fa58580494e4)

_________________________________________________________________________________________________________________________________________

- Error Cases

      Non-Existing S3bucket
![Annotation 2024-12-05 210648](https://github.com/user-attachments/assets/a41cbc9d-eebe-4590-9950-522bf89bfcfb)

_________________________________________________________________________________________________________________________________________

      Invalid Path
![Annotation 2024-12-05 210614](https://github.com/user-attachments/assets/90a9c973-9779-4623-88fb-3dbe1d3c3eef)

_________________________________________________________________________________________________________________________________________

- Future Improvements.   
      HTTPS deployment.        
      Advanced logging and monitoring.      
      CI/CD pipeline integration.          

_________________________________________________________________________________________________________________________________________

- Notes.   
      Ensure that all AWS resources are terminated after use to avoid unnecessary charges.        
      This version emphasizes the automated deployment and eliminates manual setup steps.        
