# docker-ecr - Use docker in docker with AWS ECR repository

Uses [Docker in Docker](https://hub.docker.com/_/docker) combined with [amazon-ecr-credential-helper](https://github.com/awslabs/amazon-ecr-credential-helper) .

For information about setting AWS credentials see [here .](https://github.com/awslabs/amazon-ecr-credential-helper#aws-credentials)

##  Example
The following example shows how to pull a docker image by setting the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY as an environment variables:
```shell
  docker run -v /var/run:/var/run -e AWS_ACCESS_KEY_ID=AKIAXXXXXXXXXXXXXXXX -e AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX hesleo/docker-ecr:latest docker pull 311111111111.dkr.ecr.us-east-1.amazonaws.com/my-repo:1.2.3
```
