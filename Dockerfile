FROM quay.io/projectquay/golang:1.20 AS builder
ARG arch_build=build
WORKDIR /go/src/app
COPY . .
RUN make $arch_build 

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["/kbot"]
