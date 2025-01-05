<p align="center">
  <img src="Images/logo.gif" alt="Logo of Project">
  <br>
</p>

# Three-Tier on AWS ECS Fargate

- **Three-Tier Application** on `AWS`, using `Terraform`
- Application based on `Node.js`
  - API
  - WEB
- Database based on `Aurora PostgreSQL 15.3 (Serverless v2)`

## Diagram

``` MD
                +----------------------------------------------------+
                |                         VPC                        |
                | +------------------------------------------------+ |
                | |               (3 Private Subnets)              | |
                | |   +----------------------------------------+   | |
                | |   |             Tier 1: DATABASE           |   | |
                | |   +---+----------+----------+----------+---+   | |
                | |       |          |          |          |       | |
                | |       |          |          |          |       | |
                | |    DB_NAME    DB_PORT    DB_USER    DB_PASS    | |
                | |       |          |          |          |       | |
                | |       v          v          v          v       | |
                | |   +---+----------+----------+----------+---+   | |
                | |   |              Tier 2: API               |   | |
                | |   +-------+-----------------------+--------+   | |
                | |           ^                       ^            | |
                | |           |                       |            | |
                | +-----------|-----------------------|------------+ |
                |             |                       |              |
                |         API_HOST                API_PORT           |
                |             |                       |              |
                | +-----------|-----------------------|------------+ |
                | |           |  (3 Public Subnets)   |            | |
                | |   +-------+-----------------------+--------+   | |
                | |   |              Tier 3: WEB               |   | |
                | |   +-------------------+--------------------+   | |
                | |                       |                        | |
                | +---------------------+ | +----------------------+ |
                |                       | | |                        |
                +-----------------------+ | +------------------------+
                                          v
                                        CLIENT
```

## Applications

- Database works on **5432** PORT
- API works on **3000** PORT
- WEB works on **80** PORT

## Docker

``` Shell
sudo rm -rf ~/.docker/config.json
sudo systemctl restart docker
sudo docker login -u USER -p PASSWORD
sudo docker image prune -a

sudo docker buildx build --platform linux/amd64 -t jondaw/app-api:latest .
sudo docker tag jondaw/app-api:latest app-api:latest
sudo docker push jondaw/app-api:latest

sudo docker buildx build --platform linux/amd64 -t jondaw/app-web:latest .
sudo docker tag jondaw/app-web:latest app-web:latest
sudo docker push jondaw/app-web:latest
```

## Automation

- GitHub Actions - Workflow
- Makefile
