AWS Project
# NetMaze – Automated Cloud Backup & Monitoring System

NetMaze is a cloud-based automation project designed to monitor, validate, and securely back up files from on-premises/NFS storage to AWS S3 using shell scripting, Python, and serverless AWS services.

## Project Overview
The system automates file validation and backup processes, ensuring data integrity and availability in the cloud. It uses cron-based scheduling, AWS Lambda, and CloudWatch for real-time monitoring and alerting.

## Architecture
NFS Server → Validation Script → S3 Upload → CloudWatch Monitoring → Lambda Processing

## Key Features
- Automated file validation using shell scripts
- Scheduled jobs using Linux crontab
- Secure file upload to Amazon S3
- Serverless processing using AWS Lambda
- Monitoring and logging using CloudWatch
- Database logging using AWS RDS
- Secure configuration management using AWS Secrets Manager / Vault
- Error handling and alert mechanism

## Technologies Used
- AWS Services: S3, Lambda, CloudWatch, RDS, IAM
- Programming: Python, Bash Shell Scripting
- DevOps Tools: Cron, Git
- Database: MySQL (RDS)
- OS: Linux

## Automation Workflow
1. Files generated in NFS location
2. Cron triggers validation.sh
3. validation.sh verifies file integrity
4. s3_upload.sh uploads valid files to S3
5. Lambda processes metadata/logs
6. CloudWatch monitors execution and errors
7. Logs stored in RDS

