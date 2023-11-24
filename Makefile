APP=$(shell basename $(shell git remote get-url origin))
REGESTRY=ghcr.io/aldans
VERSION=$(shell git describe --abbrev=0 --tags)-$(shell git rev-parse --short HEAD)
TARGETOS=$(shell go env GOOS)
TARGETARCH=${shell go env GOARCH}
# TARGETOS=linux
# TARGETARCH=arm64

format:
	gofmt -s -w ./

lint:
	golangci-lint run

test:
	go test -v

get:
	go get
	
build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH}	go build -v -o kbot -ldflags "-X="github.com/Aldans/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGESTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGESTRY}/${APP}:${VERSION}-${TARGETARCH}

dive: image 
	dive --ci --lowestEfficiency=0.99 $(shell docker images -q | head -n 1)
	
clean:
	rm -rf kbot
