# Terraform Advanced Lab - terra-func1

This Terraform project demonstrates advanced Terraform concepts and best practices for managing AWS infrastructure. It creates a complete VPC setup with public/private subnets, EC2 instances, security groups, and provisioners.

---

## 📚 Topics Covered

### 1. **LOCALS** ✅
**File:** `local.tf`, `main.tf`

**Definition:** Locals are constant values that can be referenced throughout your Terraform configuration. They help maintain consistency and reduce repetition.

**Key Points:**
- Defined in `local.tf` block with key-value pairs
- Referenced using `local.<key>` syntax
- Commonly used for repeated tag values, computed values, and naming conventions
- Evaluated at configuration load time (not dynamic)

**Example:**
```hcl
locals {
  owner      = "necromonger"
  costcenter = "asia-pacific-01"
  Teamdl     = "necromonger@gmail.com"
}

# Usage in tags
tags = {
  Owner = local.owner
}
```

**Used In:** Tags throughout all resources for consistent metadata

---

### 2. **MAP** ✅
**File:** `variables.tf`, `terraform.tfvars`

**Definition:** Maps are key-value pair collections in Terraform. They allow you to store related data and retrieve values based on keys.

**Key Points:**
- Defined as `type = map(...)` in variables
- Populated in `.tfvars` files
- Useful for region-to-AMI mappings, environment-specific configs, etc.
- Accessed using bracket notation: `map["key"]`

**Example:**
```hcl
# In variables.tf
variable "ami_id" {
  type = map(string)
}

# In terraform.tfvars
ami_id = {
  us-east-1 = "ami-0ec10929233384c7f"
  us-east-2 = "ami-07062e2a343acc423"
}

# Accessing the map
ami = lookup(var.ami_id, var.aws_region, var.ami_id["us-east-1"])
```

**Used In:** Region-specific AMI selection for EC2 instances

---

### 3. **FOR_EACH** (using COUNT) ✅
**File:** `subnet.tf`, `rt.tf`, `public_ec2.tf`, `private_ec2.tf`

**Definition:** A meta-argument that creates multiple instances of a resource. Similar to `for_each` but using numeric indexing rather than key-based iteration.

**Key Comparison:**
```
COUNT:    Numeric iteration (0, 1, 2...)  → Use when order matters, like subnets, instances
FOR_EACH: Key-based iteration              → Use with maps, better for dynamic collections
```

**Key Points:**
- `count = <number>` determines how many resources to create
- `count.index` provides current iteration number (0-based)
- `count.each` is used in dynamic blocks
- Resources referenced as `resource_type.name[count.index]`

**Example in Subnets:**
```hcl
resource "aws_subnet" "public-subnet" {
  count = length(var.public_cidr_block)  # Creates N subnets
  cidr_block = element(var.public_cidr_block, count.index)
  subnet_id = aws_subnet.public-subnet[count.index].id  # Reference specific instance
}
```

**Used In:**
- Creating multiple subnets (public & private)
- Creating multiple EC2 instances
- Creating route table associations
- Provisioning multiple servers

---

### 4. **LOOKUP** ✅
**File:** `public_ec2.tf`, `private_ec2.tf`

**Definition:** A function that retrieves a value from a map based on a key. Returns a default value if the key doesn't exist.

**Syntax:**
```hcl
lookup(map, key, default_value)
```

**Key Points:**
- Safe way to access map values with fallback
- Returns default if key not found (prevents errors)
- Useful for region-specific values
- Alternative to direct bracket notation: `map["key"]`

**Example:**
```hcl
# Retrieves AMI by region, defaults to us-east-1 if not found
ami = lookup(var.ami_id, var.aws_region, var.ami_id["us-east-1"])

# vs direct access (less safe)
ami = var.ami_id[var.aws_region]  # Errors if key doesn't exist
```

**Used In:** AMI selection for both public and private EC2 instances

---

### 5. **CONDITION** (Ternary Operator) ✅
**File:** `public_ec2.tf`, `private_ec2.tf`, `provisioners.tf`

**Definition:** A conditional expression that evaluates to either a true or false value based on a condition.

**Syntax:**
```hcl
condition ? true_value : false_value
```

**Key Points:**
- Used to make resource creation conditional on variable values
- Commonly used with `count` to conditionally create resources
- Can evaluate any boolean expression
- Nested conditions possible but should be kept simple

**Example:**
```hcl
# Create 3 instances if environment=prod, otherwise 1
count = var.environment == "prod" ? length(var.public_cidr_block) : 1

# Other conditions
enable_this = var.enable_feature == true ? true : false
instance_count = contains(["prod", "staging"], var.environment) ? 3 : 1
```

**Used In:**
- Conditional instance creation based on environment
- Conditional provisioner execution

---

### 6. **PROVISIONER** ✅
**File:** `provisioners.tf`, `public_ec2.tf`

**Definition:** In-place provisioners that execute actions on resources during their creation or destruction. Should be used as a last resort.

#### **6a. FILE Provisioner**

**Definition:** Copies files or inline content to a remote resource (usually EC2 instance).

**Two modes:**
- `source`: Copy a file from local machine to remote
- `content`: Copy inline content (from templatefile or string) to remote

**Example:**
```hcl
provisioner "file" {
  # Option 1: Copy local file
  source      = "local/path/file.txt"
  destination = "/tmp/file.txt"
  
  # Option 2: Copy inline content
  content     = "Hello, World!"
  destination = "/tmp/hello.txt"
}
```

**Used In:** Uploading setup scripts (`user-data.sh.tftpl`) to EC2 instances

#### **6b. REMOTE-EXEC Provisioner**

**Definition:** Executes commands on a remote resource via SSH or WinRM.

**Two modes:**
- `inline`: Array of commands to execute
- `scripts`: Path to local scripts to execute remotely

**Example:**
```hcl
provisioner "remote-exec" {
  # Execute inline commands
  inline = [
    "chmod +x /tmp/user-data.sh",
    "sudo /tmp/user-data.sh",
  ]
  
  # Or execute a script file
  scripts = ["${path.module}/setup.sh"]
}
```

**Used In:** Making copied scripts executable and running them on instances

#### **6c. LOCAL-EXEC Provisioner** (Not used in this project)

**Definition:** Executes commands on the machine running Terraform (not on remote resource).

**Example:**
```hcl
provisioner "local-exec" {
  command = "aws s3 cp ${local_file.path} s3://my-bucket/"
}
```

---

### 7. **LIST** ✅
**File:** `variables.tf`, `terraform.tfvars`

**Definition:** An ordered collection of values of the same type.

**Key Points:**
- Defined as `type = list(string)` or `type = list(number)`, etc.
- Zero-indexed (first item at index 0)
- Iterable with `for_each` in dynamic blocks
- Accessed via bracket notation: `list[0]`, `list[1]`
- Length obtained with `length(list)`

**Example:**
```hcl
# In variables.tf
variable "public_cidr_block" {
  type = list(string)
}

variable "ingress_ports" {
  type = list(number)
}

# In terraform.tfvars
public_cidr_block = ["172.18.1.0/24", "172.18.2.0/24", "172.18.3.0/24"]
ingress_ports = [22, 80, 443, 3306, 5432]

# Access first CIDR block
public_cidr_block[0]  # "172.18.1.0/24"

# Use with for_each
dynamic "ingress" {
  for_each = var.ingress_ports  # Iterate over list
  content {
    from_port = ingress.value  # Current list element
  }
}
```

**Used In:**
- CIDR blocks for subnets
- Availability zones
- Ingress ports for security groups

---

### 8. **ELEMENT Function** ✅
**File:** `subnet.tf`

**Definition:** Retrieves a single element from a list at a specified index. Equivalent to bracket notation but more explicit.

**Syntax:**
```hcl
element(list, index)
```

**Key Points:**
- Alternative to bracket notation: `element(list, 0)` vs `list[0]`
- Wraps around if index exceeds list length (modulo behavior)
- Useful for distributing resources across multiple values

**Example:**
```hcl
# Get CIDR block for this subnet
cidr_block = element(var.public_cidr_block, count.index)

# Get matching availability zone
availability_zone = element(var.azs, count.index)

# Wraps around
element([1, 2, 3], 5)  # Returns 3 (5 % 3 = 2, so element[2])
```

**Used In:** Matching subnets to their respective CIDR blocks and availability zones

---

### 9. **DYNAMIC BLOCKS** ✅
**File:** `sg.tf`

**Definition:** A way to dynamically generate nested blocks (like `ingress`, `egress`) using a loop-like syntax. Similar to `for_each` but specifically for generating nested blocks.

**Key Points:**
- Used when you need to create multiple similar nested blocks
- `for_each` iterates over the collection
- `content` block defines the structure of generated blocks
- Iterator name (default: block name) used to reference current value

**Example:**
```hcl
dynamic "ingress" {
  for_each = var.ingress_ports
  content {
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

**Used In:** Creating security group ingress rules from a list of ports

---

### 10. **TEMPLATEFILE** ✅
**File:** `public_ec2.tf`, `provisioners.tf`

**Definition:** A function that renders a local file as a template, replacing `${...}` placeholders with provided variable values.

**Syntax:**
```hcl
templatefile(path, variables_map)
```

**Key Points:**
- Template file should use `.tftpl` extension
- Variables referenced with `${variable_name}` syntax in template
- Returns the rendered content as a string
- Used with `user_data` or provisioner file blocks

**Example:**
```hcl
# In terraform code
user_data = templatefile("${path.module}/user-data.sh.tftpl", {
  vpc_name       = var.vpc_name
  instance_index = count.index + 1
})

# In user-data.sh.tftpl
#!/bin/bash
echo "VPC Name: ${vpc_name}"
echo "Instance: ${instance_index}"
```

**Used In:** Customizing user data and provisioner scripts with Terraform variables

---

### 11. **SPLAT SYNTAX** ✅
**File:** `rt.tf`

**Definition:** A shorthand for referencing all instances of a resource created with `count`.

**Syntax:**
```hcl
resource_type.name.*.attribute  # Gets list of all attribute values
```

**Key Points:**
- `*` represents "all instances"
- Creates a list of values from all resource instances
- Used to reference all IDs, IPs, DNS names, etc.
- Combined with `length()` to determine count for dependent resources

**Example:**
```hcl
# Get all public subnet IDs
aws_subnet.public-subnet.*.id  # [subnet-123, subnet-456, subnet-789]

# Use in dependent resource count
count = length(aws_subnet.public-subnet.*.id)  # Creates 3 associations

# Reference specific ID
aws_subnet.public-subnet[count.index].id
```

**Used In:** Creating the right number of route table associations

---

### 12. **INDEX** (via count.index) ✅
**File:** `subnet.tf`, `rt.tf`, `public_ec2.tf`, `private_ec2.tf`

**Definition:** The zero-based iteration counter provided by the `count` meta-argument.

**Key Points:**
- Starts at 0 for first resource
- Increments by 1 for each subsequent resource
- Used to select corresponding values from lists
- Can be manipulated: `count.index + 1` for 1-based indexing

**Example:**
```hcl
count              = length(var.public_cidr_block)  # 3 resources
# Iteration 0: count.index = 0
# Iteration 1: count.index = 1
# Iteration 2: count.index = 2

# Using index to select values
cidr_block = element(var.public_cidr_block, count.index)
subnet_id  = aws_subnet.public-subnet[count.index].id
```

**Used In:** All resources using `count` to select appropriate values from lists

---

## 🏗️ Project Structure

```
terra-func1/
├── main.tf                 # Core VPC, IGW, Route tables (LOCALS, CONDITION)
├── variables.tf            # Variable definitions (LIST, MAP)
├── terraform.tfvars        # Variable values (LIST, MAP data)
├── local.tf               # Local values (LOCALS)
├── subnet.tf              # Public/Private subnets (COUNT, ELEMENT, LIST)
├── sg.tf                  # Security groups (DYNAMIC, FOR_EACH, LIST)
├── rt.tf                  # Route table associations (COUNT, INDEX, SPLAT)
├── public_ec2.tf          # Public EC2 instances (CONDITION, LOOKUP, COUNT, TEMPLATEFILE)
├── private_ec2.tf         # Private EC2 instances (CONDITION, LOOKUP, COUNT)
├── provisioners.tf        # Provisioners (FILE, REMOTE-EXEC, CONDITION, TRIGGERS)
├── user-data.sh.tftpl     # User data template (TEMPLATEFILE)
├── .terraform.lock.hcl    # Terraform lock file
└── README.md             # This file
```

---

## 🚀 How to Run

### Prerequisites
- Terraform >= 1.0
- AWS credentials configured
- EC2 key pair: `dev-mentor-keypair`

### Initialize
```bash
terraform init
```

### Plan
```bash
terraform plan
```

### Apply
```bash
terraform apply
```

### Destroy
```bash
terraform destroy
```

---

## 📝 Key Concepts Summary

| Topic | Type | Use Case | File |
|-------|------|----------|------|
| **LOCALS** | Static values | Consistent tags, repeated values | `local.tf` |
| **MAP** | Key-value pairs | Region-specific configs, lookups | `variables.tf` |
| **FOR_EACH (COUNT)** | Iteration | Multiple subnets, instances | `subnet.tf`, `public_ec2.tf` |
| **LOOKUP** | Map retrieval | Safe value lookup with default | `public_ec2.tf` |
| **CONDITION** | Boolean expression | Conditional resource creation | `public_ec2.tf` |
| **PROVISIONER (FILE)** | Remote file copy | Upload scripts to instances | `provisioners.tf` |
| **PROVISIONER (REMOTE-EXEC)** | Remote execution | Run commands on instances | `provisioners.tf` |
| **LIST** | Collection | CIDR blocks, ports, AZs | `variables.tf` |
| **ELEMENT** | List indexing | Safe list access | `subnet.tf` |
| **DYNAMIC** | Block generation | Create multiple nested blocks | `sg.tf` |
| **TEMPLATEFILE** | Template rendering | Customize scripts with variables | `public_ec2.tf` |
| **SPLAT SYNTAX** | All resources | Get all IDs from count resources | `rt.tf` |
| **INDEX** | Iteration counter | Select corresponding list values | `subnet.tf` |

---

## 🎯 Learning Outcomes

After studying this project, you will understand:
- How to use locals for consistent configuration management
- Working with maps for flexible data structures
- Creating multiple resources efficiently with count
- Safe map value retrieval with lookup
- Conditional resource creation with expressions
- Remote provisioning with file and remote-exec provisioners
- Dynamic block generation for repetitive resource configurations
- Template rendering for configuration customization
- List operations and element functions
- Resource referencing techniques (splat, index notation)

---

## ⚠️ Important Notes

1. **Provisioners as Last Resort:** The provisioners in this project should ideally be replaced with `user_data` scripts. Provisioners are considered a last resort in Terraform best practices.

2. **SSH Requirements:** Provisioners require SSH access to instances and proper security group configuration (port 22 open).

3. **Environment Variable:** The `environment` variable controls resource quantity:
   - `prod`: Creates 3 instances (one per CIDR block)
   - Other values: Creates 1 instance

---

## 📚 References

- [Terraform Locals Documentation](https://www.terraform.io/language/values/locals)
- [Terraform Map Type](https://www.terraform.io/language/types/map)
- [Terraform Count Documentation](https://www.terraform.io/language/meta-arguments/count)
- [Terraform Lookup Function](https://www.terraform.io/language/functions/lookup)
- [Terraform Conditionals](https://www.terraform.io/language/expressions/conditionals)
- [Terraform Provisioners](https://www.terraform.io/language/resources/provisioners/syntax)
- [Terraform Dynamic Blocks](https://www.terraform.io/language/expressions/dynamic)
- [Terraform Templatefile](https://www.terraform.io/language/functions/templatefile)

---

**Author:** Terraform Learning Lab
**Last Updated:** March 2026
