DEBIAN ?= bullseye
TAG ?= bullseye
IMAGE ?= debian
REPO ?= docker.au-zone.com/maivin
PLATFORM ?= linux/arm64

all: build

build:
	docker build . --pull --no-cache \
		--platform $(PLATFORM) \
		--build-arg DEBIAN=$(DEBIAN) \
		--tag $(REPO)/$(IMAGE):$(TAG)

push: build
	docker push $(REPO)/$(IMAGE):$(TAG)
