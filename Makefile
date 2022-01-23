BINARY_NAME=dndmachine
PWD=$(shell pwd)
UID=$(shell id -u)
GID=$(shell id -g)
GIT_TAG=$(shell git describe master --tags 2> /dev/null || echo -n "v2.0.0")
GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD)
GIT_COMMIT=$(shell git rev-parse --short HEAD)
BUILD_TIME=$(shell date)

update: mod-update ui-update

test: opa-test go-test ui-test

build: opa-build go-build ui-build

opa-build:
	opa build \
		--target wasm \
		--entrypoint authz/auth/allow \
		--entrypoint authz/character/allow \
		--entrypoint authz/pages/allow \
		--entrypoint authz/user/allow \
		--entrypoint authz \
		--ignore \*_test.rego \
		internal/policy/rego/
	tar -xzvf \
		./bundle.tar.gz \
		--directory=ui/public \
		/policy.wasm
	rm bundle.tar.gz

opa-test:
	opa test -v internal/policy/rego
	opa test -v internal/policy/testdata

dev:
	USER=${UID}:${GID} \
	docker-compose up \
		--build \
		--renew-anon-volumes \
		--force-recreate \
		--abort-on-container-exit

mod-update:
	go mod tidy
	go mod vendor

go-coverage:
	go test -coverprofile cover.out ./...
	go tool cover -html=cover.out

lint:
	golangci-lint run -v

format:
	gofmt -s -w cmd
	gofmt -s -w internal

go-test:
	go test -race -count 10 -v ./...

go-build:
	CGO_ENABLED=0 \
	GO111MODULE=on \
	GOFLAGS=-mod=vendor \
	go build \
		-o $(BINARY_NAME) \
		-a \
		-ldflags "\
			-X 'github.com/SebastiaanPasterkamp/dndmachine/internal/build.Version=$(GIT_TAG)' \
			-X 'github.com/SebastiaanPasterkamp/dndmachine/internal/build.Commit=$(GIT_COMMIT)' \
			-X 'github.com/SebastiaanPasterkamp/dndmachine/internal/build.Branch=$(GIT_BRANCH)' \
			-X 'github.com/SebastiaanPasterkamp/dndmachine/internal/build.Timestamp=$(BUILD_TIME)' \
		" \
		cmd/$(BINARY_NAME)/main.go

docker:
	docker build \
		--no-cache \
		--build-arg GIT_BRANCH="$(GIT_BRANCH)" \
		--build-arg GIT_COMMIT="$(GIT_COMMIT)" \
		--build-arg GIT_TAG="$(GIT_TAG)" \
		--build-arg BUILD_TIME="$(BUILD_TIME)" \
		--tag $(BINARY_NAME) \
		.

clean:
	rm \
		$(BINARY_NAME) \
		cover.out \
		ui/build \
		ui/public/policy.wasm

serve-ui:
	docker run \
		--rm -it \
		-p 3000:3000 \
		-u ${UID}:${GID} \
		-v ${PWD}/ui:/project \
		-w /project \
		node:17.3-stretch \
			npm start

ui-test:
	docker run \
		--rm -it \
		-u ${UID}:${GID} \
		-v ${PWD}/ui:/project \
		-w /project \
		node:17.3-stretch \
			npm test

ui-build:
	docker run \
		--rm -it \
		-u ${UID}:${GID} \
		-v ${PWD}/ui:/project \
		-w /project \
		node:17.3-stretch \
			npm run build

ui-shell:
	docker run \
		--rm -it \
		-u ${UID}:${GID} \
		-v ${PWD}/ui:/project \
		-w /project \
		node:17.3-stretch \
			/bin/bash

ui-update:
	docker run \
		--rm -it \
		-u ${UID}:${GID} \
		-v ${PWD}/ui:/project \
		-w /project \
		node:17.3-stretch /bin/bash -c '\
			npm install --no-save npm-check-updates ; \
			./node_modules/.bin/ncu -u ; \
			npm update ; \
		'

