<p align="center">
  <img src="Images/diagram.gif" alt="Diagram of Project">
  <br>
  <em>If HuXyЯ NeT</em>
</p>

# Toptal - Project

- **Three-Tier Application** on `AWS`, using `Terraform`
- Application based on `Node.js`
    - API
    - WEB
- Database based on `PostgreSQL`

### Diagram

``` MD
ПРОДАМ ГАРАЖ !!! Азерот, Восточные Королевства, г. Штормград, Ул. Магов, д. 42.

6.000 Голды, /wisper Вариан Ринн, ТОРГ НЕУМЕСТЕН !
```

### Applications

- API works on 3000 PORT
- WEB works on 4000 PORT

### Custom Modules

> <details>
> <summary>VPC Module</summary>
>
> - VPC
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



> <details>
> <summary>RDS Module</summary>
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



> <details>
> <summary>ECS Module</summary>
>
>   - *1*
>   - *2*
>   - *3*
>
> </details>

<table>
  <tr>
    <td align="center" width="45%">
      <img src="Images/girl1.gif" alt="Girl 1" width="50%">
    </td>
    <td align="center" width="50%">
      <img src="Images/girl2.gif" alt="Girl 2" width="50%">
    </td>
  </tr>
</table>

### Variables

``` HCL
Variable 1
Variable 2
Variable 3
```

### Automation

- GitHub Actions - Workflow
- Makefile

