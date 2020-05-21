FROM golang:1.14 as ecr-login-builder
ARG GOARCH=amd64

# Build Amazon ECR credential helper
RUN go get -u github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login
RUN make -C /go/src/github.com/awslabs/amazon-ecr-credential-helper linux-amd64

# Used to later configure the Docker daemon to use the credential helper for all Amazon ECR registries
RUN echo '{"credsStore": "ecr-login"}' > /tmp/use-ecr-creds-on-login.json

FROM docker
COPY --from=ecr-login-builder /go/src/github.com/awslabs/amazon-ecr-credential-helper/bin/linux-amd64/docker-credential-ecr-login /usr/local/bin/
COPY --from=ecr-login-builder /tmp/use-ecr-creds-on-login.json /root/.docker/config.json