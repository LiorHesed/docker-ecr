# docker-ecr - Use docker in docker with AWS ECR repository

Uses [Docker in Docker](https://hub.docker.com/_/docker) combined with [amazon-ecr-credential-helper](https://github.com/awslabs/amazon-ecr-credential-helper) .

For information about setting AWS credentials see [here .](https://github.com/awslabs/amazon-ecr-credential-helper#aws-credentials)

## Build the image
1. Clone the repos
2. _docker build_ it

or _pull_ it from [docker hub directly](https://hub.docker.com/repository/docker/hesleo/docker-ecr) (see example below)

##  Example
- The following example shows how to pull a docker image by setting the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY as an environment variables:
```shell
  docker run -v /var/run:/var/run -e AWS_ACCESS_KEY_ID=AKIAXXXXXXXXXXXXXXXX -e AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX hesleo/docker-ecr:latest docker pull 311111111111.dkr.ecr.us-east-1.amazonaws.com/my-repo:1.2.3
```

- A Kubernetes [Tekton](https://tekton.dev/) task with AWS credentials as a [secret](https://kubernetes.io/docs/concepts/configuration/secret) to push image to ECR
```yaml
apiVersion: v1
kind: ConfigMap
name: ecr-login-config
data:
  config.json: |-
    {
        "credsStore": "ecr-login"
    }
``` 
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: aws-dev-ecr-secret
data:
    AWS_ACCESS_KEY_ID: <base64 of your AWS_ACCESS_KEY_ID>
    AWS_SECRET_ACCESS_KEY: <base64 of your AWS_SECRET_ACCESS_KEY>
``` 
```yaml
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
  name: push-to-ecr-repo
spec:
  params:
  - name: imageToPush
    description: Image name in the format imageUrl:imageLabel
  steps:
    - name: push-to-ecr-repo
      image: hesleo/docker-ecr
      env:
      - name: DOCKER_CONFIG
        value: /tekton/home/.docker                
      - name: AWS_ACCESS_KEY_ID
        valueFrom:
          secretKeyRef:
            name: aws-dev-ecr-secret
            key: AWS_ACCESS_KEY_ID
      - name: AWS_SECRET_ACCESS_KEY
        valueFrom:
          secretKeyRef:
            name: aws-dev-ecr-secret
            key: AWS_SECRET_ACCESS_KEY
      script: |
        docker push $(params.imageToPush)
      volumeMounts:
        - name: docker
          mountPath: /var/run 
        - name: docker-config
          mountPath: /tekton/home/.docker          
  volumes:    
  - name: docker
    hostPath:
      path: /var/run
  - name: docker-config
    configMap:
      name: ecr-login-config
```
