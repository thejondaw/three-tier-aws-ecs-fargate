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
              | |                 Tier 1: Database               | |
              | |               (2 Private Subnets)              | |
              | |                 |            |                 | |
              | |    +------------+------------+------------+    | |
              | |    |            |            |            |    | |
              | |  DB NAME     DB PORT      DB USER    DB PASSWD | |
              | |    |            |            |            |    | |
              | |    |            |            |            |    | |
              | |    |            |            |            |    | |
              | +----+------------+------------+------------+----+ |
              |      |            |            |            |      |
              | +----V------------V------------V------------V----+ |
              | |                  Tier 2: API                   | |
              | |               (2 Private Subnets)              | |
              | |                       |                        | |
              | |              +--------+--------+               | |
              | |              |                 |               | |
              | |          API HOST          API PORT            | |
              | |              |                 |               | |
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

- Database works on 5432 PORT
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

``` HCL
Variable 1
Variable 2
Variable 3
```

### Automation

- GitHub Actions - Workflow
- Makefile
