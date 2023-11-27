APP=$(shell basename $(shell git remote get-url origin))
REGESTRY=ghcr.io/aldans
VERSION=$(shell git describe --abbrev=0 --tags)-$(shell git rev-parse --short HEAD)
APP_BIN_NAME=kbot

TARGETOS=$(shell go env GOOS)
TARGETARCH=${shell go env GOARCH}

LINUX=linux
WINDOWS=windows
MACOS=darwin

LIN_ARM=linux-arm

ARM_ARCH=arm64
AMD_ARCH=amd64

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get
	
# common build golang app for os/arch 
 
## build: build golang app for current os and architecture
build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH}	go build -v -o ${APP_BIN_NAME} -ldflags "-X="github.com/Aldans/kbot/cmd.appVersion=${VERSION}

linux-arm: format get
	CGO_ENABLED=0 GOOS=${LINUX} GOARCH=${ARM_ARCH} go build -v -o ${APP_BIN_NAME} -ldflags "-X="github.com/Aldans/kbot/cmd.appVersion=${VERSION}
	
linux: format get
	CGO_ENABLED=0 GOOS=${LINUX} GOARCH=${AMD_ARCH} go build -v -o ${APP_BIN_NAME} -ldflags "-X="github.com/Aldans/kbot/cmd.appVersion=${VERSION}

macos: format get
	CGO_ENABLED=0 GOOS=${MACOS} GOARCH=${ARM_ARCH} go build -v -o ${APP_BIN_NAME} -ldflags "-X="github.com/Aldans/kbot/cmd.appVersion=${VERSION}
	
windows: format get
	CGO_ENABLED=0 GOOS=${WINDOWS} GOARCH=${AMD_ARCH} go build -v -o ${APP_BIN_NAME} -ldflags "-X="github.com/Aldans/kbot/cmd.appVersion=${VERSION}

go: build dive clean
	
# create docker images for os/arch
 
## image: create docker container for current os and architecture
image:
	docker build --build-arg arch_build=${TARGETOS} app_name=${APP_BIN_NAME} -t ${REGESTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} .

image-win:
	docker build --build-arg arch_build=${WINDOWS} -t ${REGESTRY}/${APP}:${VERSION}-${WINDOWS}-${AMD_ARCH} .

image-mac:
	docker build --build-arg arch_build=${MACOS} -t ${REGESTRY}/${APP}:${VERSION}-${MACOS}-${ARM_ARCH} .

image-lin:
	docker build --build-arg arch_build=${LINUX} -t ${REGESTRY}/${APP}:${VERSION}-${LINUX}-${AMD_ARCH} .

image-lin-arm:
	docker build --build-arg arch_build=${LIN_ARM} -t ${REGESTRY}/${APP}:${VERSION}-${LINUX}-${ARM_ARCH} .
	
	
# push docker images for os/arch
push:
	docker push ${REGESTRY}/${APP}:${VERSION}-${TARGETARCH}

push-win:
	docker push ${REGESTRY}/${APP}:${VERSION}-${WINDOWS}-${AMD_ARCH}
	
push-lin:
	docker push ${REGESTRY}/${APP}:${VERSION}-${LINUX}-${AMD_ARCH}
	
push-lin-arm:
	docker push ${REGESTRY}/${APP}:${VERSION}-${LINUX}-${ARM_ARCH}
	
push-mac:
	docker push ${REGESTRY}/${APP}:${VERSION}-${MACOS}-${ARM_ARCH}
	
dive: image 
	dive --ci --lowestEfficiency=0.99 $(shell docker images -q | head -n 1)
	
clean:
	@if [ -f "${APP_BIN_NAME}" ]; then rm "${APP_BIN_NAME}"; else echo " --> Log: File "${APP_BIN_NAME}" not found"; fi; \
	LAST_IMG=$$(docker images -q | head -n 1); \
	if [ -n "$${LAST_IMG}" ]; then docker rmi -f $${LAST_IMG}; else echo " --> Log: Image not found"; fi 
