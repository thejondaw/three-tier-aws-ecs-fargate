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

```
+----------------------------------------------------+
|                         VPC                        |
| +------------------------------------------------+ |
| |                 Tier 1: Database               | |
| |               (2 Private Subnets)              | |
| |                 |                              | |
| |    +------------+------------+------------+    | |
| |    |            |            |            |    | |
| |  DB NAME     DB PORT      DB USER    DB PASSWD | |
| |    |            |            |            |    | |
| |    |            |            |            |    | |
| |    |            |            |            |    | |
| +----+------------+------------+------------+----+ |
|      |            |            |            |    | |
| +----V------------V------------V------------V    | |
| |                  Tier 2: API              |    | |
| |               (2 Private Subnets)         |    | |
| |                       |                   |    | |
| |              +--------+--------+          |    | |
| |              |                 |          |    | |
| |          API HOST          API PORT       |    | |
| |              |                 |          |    | |
| +--------------+-----------------+---------------+ |
|                |                 |                 |
| +--------------V-----------------V---------------+ |
| |                  Tier 3: WEB                   | |
| |               (2 Public Subnets)               | |
| |                                                | |
| +------------------------------------------------+ |
+----------------------------------------------------+
```

### Applications

- API works on 3000 PORT
- WEB works on 4000 PORT

### Docker Hub

``` Shell
sudo rm -rf ~/.docker/config.json
sudo systemctl restart docker
sudo docker login -u USER -p PASSWORD

sudo docker buildx build --platform linux/amd64 -t jondaw/app-api:latest .
sudo docker tag jondaw/app-api:latest app-api:latest
sudo docker push jondaw/app-api:latest

sudo docker buildx build --platform linux/amd64 -t jondaw/app-web:latest .
sudo docker tag jondaw/app-web:latest app-web:latest
sudo docker push jondaw/app-web:latest
```

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


```
+----------------------------------------------------+
|                         VPC                        |
| +------------------------------------------------+ |
| |                 Tier 1: Database               | |
| |               (2 Private Subnets)              | |
| |                 |                              | |
| |    +------------+------------+------------+    | |
| |    |            |            |            |    | |
| |  DB NAME     DB PORT      DB USER    DB PASSWD | |
| |    |            |            |            |    | |
| |    |            |            |            |    | |
| |    |            |            |            |    | |
| +----+------------+------------+------------+----+ |
|      |            |            |            |    | |
| +----V------------V------------V------------V    | |
| |                  Tier 2: API              |    | |
| |               (2 Private Subnets)         |    | |
| |                       |                   |    | |
| |              +--------+--------+          |    | |
| |              |                 |          |    | |
| |          API HOST          API PORT       |    | |
| |              |                 |          |    | |
| +--------------+-----------------+---------------+ |
|                |                 |                 |
| +--------------V-----------------V---------------+ |
| |                  Tier 3: WEB                   | |
| |               (2 Public Subnets)               | |
| |                                                | |
| +------------------------------------------------+ |
+----------------------------------------------------+
```