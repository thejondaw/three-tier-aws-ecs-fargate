![Diagram of Project](Images/diagram.gif)

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

API works on 3000 PORT
WEB works on 4000 PORT

### Modules

> **VPC Module:**
>   - VPC
>   - *Public Subnet - 1*
>   - *Private Subnets - 2*
>   - *Internet Gateway*
>   - *NAT Gateway*

> **RDS Module:**
>   - *1*
>   - *2*
>   - *3*

> **ECS Module:**
>   - *1*
>   - *2*
>   - *3*

### Variables

``` HCL
Variable 1
Variable 2
```

### Automation

- GitHub Actions - Workflow
- Makefile
