APP=$(shell basename $(shell git remote get-url origin))
REGESTRY=ghcr.io/aldans
VERSION=$(shell git describe --abbrev=0 --tags)-$(shell git rev-parse --short HEAD)

TARGETOS=$(shell go env GOOS)
TARGETARCH=${shell go env GOARCH}

LINUX=linux
WINDOWS=windows
MACOS=darwin

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
	
build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH}	go build -v -o kbot -ldflags "-X="github.com/Aldans/kbot/cmd.appVersion=${VERSION}

linux-arm: format get
	CGO_ENABLED=0 GOOS=${LINUX} GOARCH=${ARM_ARCH} go build -v -o kbot -ldflags "-X="github.com/Aldans/kbot/cmd.appVersion=${VERSION}
	docker build --build-arg arch=${ARM_ARCH} --build-arg os=${LINUX} -t ${REGESTRY}/${APP}:${VERSION}-${LINUX}-${ARM_ARCH} .
	
linux: format get
	CGO_ENABLED=0 GOOS=${LINUX} GOARCH=${AMD_ARCH} go build -v -o kbot -ldflags "-X="github.com/Aldans/kbot/cmd.appVersion=${VERSION}
	docker build --build-arg arch=${AMD_ARCH} --build-arg os=${LINUX} -t ${REGESTRY}/${APP}:${VERSION}-${LINUX}-${AMD_ARCH} .

macos: format get
	CGO_ENABLED=0 GOOS=${MACOS} GOARCH=${ARM_ARCH} go build -v -o kbot -ldflags "-X="github.com/Aldans/kbot/cmd.appVersion=${VERSION}
	docker build --build-arg arch=${ARM_ARCH} --build-arg os=${MACOS} -t ${REGESTRY}/${APP}:${VERSION}-${MACOS}-${ARM_ARCH} .
	
windows: format get
	CGO_ENABLED=0 GOOS=${WINDOWS} GOARCH=${AMD_ARCH} go build -v -o kbot -ldflags "-X="github.com/Aldans/kbot/cmd.appVersion=${VERSION}
	docker build --build-arg arch=${AMD_ARCH} --build-arg os=${WINDOWS} -t ${REGESTRY}/${APP}:${VERSION}-${WINDOWS}-${AMD_ARCH} .

# all: windows linux macos
go: build dive clean
	
image:
	docker build -t ${REGESTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} .

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
	if [ -f kbot ]; then rm kbot; fi; \
	LAST_IMG=$$(docker images -q | head -n 1); \
	if [ -n "$${LAST_IMG}" ]; then docker rmi -f $${LAST_IMG}; else echo "Image not found"; fi 
