<p align="center">
  <img src="Images/diagram.gif" alt="Diagram of Project">
  <br>
</p>

# Toptal - Project

- **Three-Tier Application** on `AWS`, using `Terraform`
- Application based on `Node.js`
    - API
    - WEB
- Database based on `Aurora PostgreSQL 15.3 (Serverless v2)`

### Diagram

```
              +----------------------------------------------------+
              |                         VPC                        |
              | +------------------------------------------------+ |
              | |               (2 Private Subnets)              | |
              | |   +----------------------------------------+   | |
              | |   |             Tier 1: DATABASE           |   | |
              | |   +----------------------------------------+   | |
              | |       |           |          |         |       | |
              | |       |           |          |         |       | |
              | |    DB_NAME     DB_PORT     USER      PASSWD    | |
              | |       |           |          |         |       | |
              | |       |           |          |         |       | |
              | |       V           V          V         V       | |
              | |   +----------------------------------------+   | |
              | |   |              Tier 2: API               |   | |
              | |   +----------------------------------------+   | |
              | |                       |                        | |
              | |              +--------+--------+               | |
              | |              |                 |               | |
              | |              |                 |               | |
              | |          API_HOST          API_PORT            | |
              | +--------------|-----------------|---------------+ |
              |                |                 |                 |
              | +--------------V-----------------V---------------+ |
              | |              (2 Public Subnets)                | |
              | |   +----------------------------------------+   | |
              | |   |              Tier 3: WEB               |   | |
              | |   +----------------------------------------+   | |
              | |                                                | |
              | +------------------------------------------------+ |
              +----------------------------------------------------+
```

### Applications

- Database works on 5432 PORT
- API works on 3000 PORT
- WEB works on 80 PORT

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
> - TEST
>
> </details>



> <details>
> <summary>RDS Module</summary>
>
> - TEST
>
> </details>



> <details>
> <summary>ECS Module</summary>
>
>  - TEST
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

``` Shell
# "AWS Region"
region = "us-east-2" # Ohio

# IP Range of "VPC"
vpc_cidr = "10.0.0.0/16"

# "Public Subnets"  "WEB"
subnet_web_1_cidr = "10.0.1.0/24"
subnet_web_2_cidr = "10.0.2.0/24"

# "Private Subnets" "DB"
subnet_db_1_cidr = "10.0.11.0/24"
subnet_db_2_cidr = "10.0.12.0/24"

# RDS variables
db_name            = "DB_NAME"
db_username        = "DB_USER"
db_password        = "DB_PASSWORD"
aurora_secret_name = "SECRET_NAME"
```

### Automation

- GitHub Actions - Workflow
- Makefile
