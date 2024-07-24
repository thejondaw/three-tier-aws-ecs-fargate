![Diagram of Project](Images/diagram.gif)

# Toptal - Project

- **Three-Tier Application** on `AWS`, using `Terraform`
- Application based on `Node.js`
    - API
    - WEB
- Database based on `PostgreSQL`

## Diagram

``` MD
ПРОДАМ ГАРАЖ !!! Азерот, Восточные Королевства, г. Штормград, Ул. Магов, д. 42.

6.000 Голды, /wisper Вариан Ринн, ТОРГ НЕУМЕСТЕН !
```

## Applications

API works on 3000 PORT
WEB works on 4000 PORT

## Modules

> ### **VPC Module:**
> <details>
> <summary>Click to expand</summary>
>
> - VPC (aws_vpc)
>    - Main Virtual Private Cloud for the infrastructure
> 
> - Subnets
>    - Public Subnet #1: For Web servers
>    - Public Subnet #2: For Application Load Balancer
>    - Private Subnet #3: For API servers
>    - Private Subnet #4: For Database servers
> 
> - Internet Gateway
>    - Allows communication between VPC and the internet
> 
> - NAT Gateway
>    - Enables private subnets to access internet while remaining private
> 
> - Route Tables
>    - Public: Routes traffic for public subnets
>    - Private: Routes traffic for private subnets
> 
> - Security Group
>    - Controls inbound and outbound traffic for VPC resources
>    - Allows HTTP (80), HTTPS (443), and SSH (22) inbound traffic
> 
> - Elastic IP
>    - Static public IP address for NAT Gateway
> 
> - Route Table Associations
>    - Links subnets with appropriate route tables
>
> </details>



> ### **RDS Module:**
> <details>
> <summary>Click to expand</summary>
>
> - **AWS DB Subnet Group**
>   - Created using private subnets for database isolation
> 
> - **AWS Security Group for Database**
>   - Allows PostgreSQL database access
>   - Ingress rule for port 3000
>   - Egress rule for all outbound traffic
> 
> - **AWS Secrets Manager**
>   - Stores database credentials securely
>   - Includes randomly generated username and password
> 
> - **AWS RDS (Relational Database Service)**
>   - PostgreSQL database instance
>   - Configured with:
>     - Subnet group for network placement
>     - Allocated storage
>     - Engine version
>     - Instance class
>     - Security group
>     - Parameter group
>
> </details>



> **ECS Module:**
> <details>
> <summary>Click to expand</summary>
>
>   - *1*
>   - *2*
>   - *3*
>
> </details>

### Variables

``` HCL
Variable 1
Variable 2
Variable 3
```

### Automation

- GitHub Actions - Workflow
- Makefile