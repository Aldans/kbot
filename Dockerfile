# ARG arch=amd64
ARG os=build
# ARG app=kbot
# ARG APP_NAME=${app}-${os}-${arch}

FROM quay.io/projectquay/golang:1.20 AS builder
WORKDIR /go/src/app
COPY . .
RUN make $os

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["/kbot"]
