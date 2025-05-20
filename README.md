# coffeeshop-deployment

## Summary

`coffeeshop-deployment` is an infrastructure-as-code solution for deploying the Coffeeshop microservices system on AWS. It supports both development and production environments, leveraging Terraform for provisioning AWS resources (VPC, EC2, RDS, ECR, EKS), Docker Compose for development, and Kubernetes manifests for production.

---

## Architecture

- **Development:** EC2 instance running Docker Compose, RDS PostgreSQL, RabbitMQ, and all microservices (web, proxy, barista, kitchen, counter, product).
- **Production:** AWS EKS (Kubernetes), RDS PostgreSQL, RabbitMQ, all microservices deployed via manifests, autoscaling, ingress, secrets, and network policies.

---

## Component Description

- **terraform/environments/dev/**: Provisions development infrastructure (VPC, EC2, RDS) on AWS. EC2 runs Docker Compose.
- **terraform/environments/prod/**: Provisions production infrastructure (VPC, EKS, RDS, IAM, KMS, autoscaling).
- **terraform/modules/**: Shared modules for VPC, EC2, ECR, RDS, and region configuration.
- **docker/**: (Optional) Contains Dockerfiles or build scripts for images.
- **kubernetes/manifests/**: Kubernetes manifests for each service, ingress, autoscaler, network policy, secrets, and configmaps.
- **push-images.sh**: Script to push Docker images to ECR.

---

## Database: RDS PostgreSQL with AWS Secrets Manager

The solution provisions a managed PostgreSQL database using AWS RDS. For enhanced security, database credentials (username and password) are stored and managed in AWS Secrets Manager instead of being hardcoded.

### How it works

- **RDS PostgreSQL**: The database instance is created in private subnets, not publicly accessible, and secured by a dedicated security group.
- **Secrets Manager**: Credentials for the database (username, password) are generated and stored in AWS Secrets Manager. The RDS instance is configured to use these secrets for authentication.
- **Terraform Integration**: Terraform creates the secret, injects the credentials, and configures the RDS instance to use the secret.

## Homepage of the Application
Development: Access via EC2 public IP, port 8888 (e.g., http://<EC2_PUBLIC_IP>:8888)
Production: Access via the domain or endpoint of the LoadBalancer/Ingress (see Terraform output or AWS Console).

User Guideline
1. Prerequisites
Install: Terraform, AWS CLI, kubectl, Docker.
2. Deploy Development Environment
Result: EC2, RDS, and VPC are created. SSH into EC2 to check Docker Compose.
Push images to ECR:
SSH into EC2, run Docker Compose:
3. Deploy Production Environment
Result: EKS, RDS, VPC, IAM, and KMS are created.
Push images to ECR as above.
Deploy manifests:
4. Access the Application
Development: http://<EC2_PUBLIC_IP>:8888
Production: Check the LoadBalancer/Ingress address in AWS.
