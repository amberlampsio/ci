.DEFAULT_GOAL := help
.PHONY: *

help:
	echo "See Makefile for usage"

build:
	echo "Building Tag: $(TAG)"
	@docker build \
		--no-cache \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
		-t scriptor2k2/ci:$(TAG) \
		-f Dockerfile-$(TAG) .

test:
	echo "Testing Tag: $(TAG)"
	dgoss run -it scriptor2k2/ci:$(TAG)

build-all:
	make build TAG="8.0"
	make build TAG="8.1"

test-all:
	make test TAG="8.0"
	make test TAG="8.1"

push-all:
	docker push scriptor2k2/ci:8.0
	docker push scriptor2k2/ci:8.1


clean:
	docker ps -a -q | xargs docker rm -f
	docker images -q | xargs docker rmi -f
