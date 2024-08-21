# ECR CREATING

``` Shell
# Create "ECR Repositories":

aws ecr create-repository --repository-name app-api
aws ecr create-repository --repository-name app-web
```

``` Shell
# Get "URI" of Repositories:

API_REPO=$(aws ecr describe-repositories --repository-names app-api --query 'repositories[0].repositoryUri' --output text)
WEB_REPO=$(aws ecr describe-repositories --repository-names app-web --query 'repositories[0].repositoryUri' --output text)
```

``` Shell
# Authenticate in "ECR":

aws ecr get-login-password --region us-east-2 | sudo docker login --username AWS --password-stdin ${API_REPO%/*}
```

``` Shell
# Build and deployment process for "API Application":

sudo docker buildx build --platform linux/amd64 -t ${API_REPO}:latest .
sudo docker push ${API_REPO}:latest
```

``` Shell
# Build and deployment process for "WEB Application":

sudo docker buildx build --platform linux/amd64 -t ${WEB_REPO}:latest .
sudo docker push ${WEB_REPO}:latest
```
