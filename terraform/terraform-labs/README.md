# Terraform Labs

A comprehensive collection of Terraform configurations demonstrating real-world infrastructure-as-code practices and AWS cloud architecture skills.

## 📋 Overview

This repository showcases practical Terraform implementations covering various cloud infrastructure scenarios. Each section is designed to demonstrate different aspects of infrastructure provisioning, from basic networking to complex multi-tier deployments.

**Objective:** Demonstrate proficiency in:
- Infrastructure as Code (IaC) best practices
- AWS cloud architecture
- Resource management and automation
- Configuration modularization
- Security and compliance considerations

---

## 📚 Chapter-wise Contents

### 1. AWS VPC Infrastructure
**Location:** `aws-vpc/`

**Description:**
A foundational VPC setup demonstrating core AWS networking concepts. This configuration establishes a complete Virtual Private Cloud with:

- **Virtual Private Cloud (VPC)** — Base network with CIDR block `10.0.0.0/16`
- **Internet Gateway** — Enables external connectivity for the VPC
- **Public Subnet** — CIDR block `10.0.1.0/24` for internet-facing resources
- **Route Table** — Manages traffic routing with internet gateway integration
- **Security Group** — Controls inbound/outbound traffic policies
- **Route Table Association** — Links subnet to route table configuration

**Key Concepts Demonstrated:**
- VPC architecture and configuration
- Subnet segmentation
- Internet connectivity setup
- Security group management
- DNS hostname enablement

**Use Cases:**
- Foundation for EC2 instance deployment
- Basis for multi-tier application architecture
- Laboratory environment for testing cloud deployments

**Files:**
- `main.tf` — Main infrastructure configuration

---

## 🚀 Getting Started

### Prerequisites
- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- AWS account with necessary permissions

### Quick Start

1. Navigate to the desired section:
   ```bash
   cd aws-vpc
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review planned changes:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

5. Destroy resources when done:
   ```bash
   terraform destroy
   ```

---

## 💡 Best Practices Implemented

- ✅ Descriptive resource naming conventions
- ✅ Comprehensive inline documentation and comments
- ✅ Modular resource organization
- ✅ Environment-conscious tagging strategy
- ✅ Security-first configuration approach
- ✅ Clear variable and output definitions (when applicable)

---

## 📖 Future Sections

This repository is actively maintained and regularly updated with new infrastructure patterns including:

- [ ] Multi-tier application deployment
- [ ] Kubernetes cluster setup
- [ ] Database configurations (RDS)
- [ ] Load balancing architectures
- [ ] Auto-scaling configurations
- [ ] Infrastructure monitoring and logging
- [ ] CI/CD pipeline integration
- [ ] Disaster recovery setups

---

## 🔧 Structure

```
terraform-labs/
├── aws-vpc/              # Core VPC networking
│   └── main.tf
├── README.md            # This file
└── [Additional sections...]
```

---

## 📝 Notes

- Each section is self-contained and can be deployed independently
- Resources created in AWS may incur charges — always review `terraform plan` output
- It's recommended to use separate AWS accounts or namespaces for different environments
- Terraform state files contain sensitive information — handle with care

---

## 🔄 Ongoing Updates

This repository is a living document and will be continuously updated with:
- New infrastructure patterns and use cases
- Enhanced configurations and optimizations
- Additional AWS services and integrations
- Performance improvements and best practices

---


**Last Updated:** March 2026
