DEBIAN ?= bullseye
TAG ?= bullseye
IMAGE ?= debian
REPO ?= docker.au-zone.com/maivin
PLATFORM ?= arm64v8

all: build

build:
	docker build . --pull --no-cache \
		--build-arg PLATFORM=$(PLATFORM) \
		--build-arg DEBIAN=$(DEBIAN) \
		--tag $(REPO)/$(IMAGE):$(TAG)

push: build
	docker push $(REPO)/$(IMAGE):$(TAG)
