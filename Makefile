BINARY_NAME=dndmachine
PWD=$(shell pwd)
UID=$(shell id -u)
GID=$(shell id -g)
GIT_TAG=$(shell git describe master --tags 2> /dev/null || echo -n "v2.0.0")
GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD)
GIT_COMMIT=$(shell git rev-parse --short HEAD)
BUILD_TIME=$(shell date -Iseconds)

update: go-update ui-update

test: opa-test go-test ui-test

coverage: opa-coverage go-coverage ui-coverage

build: opa-build go-build ui-build

opa-build:
	mkdir -p ${PWD}/build
	docker run \
		--rm -it \
		--user ${UID}:${GID} \
		-v ${PWD}/internal/policy/rego:/rego \
		-v ${PWD}/build:/build \
		cromrots/opa:0.50.1 \
		build \
			--target wasm \
			--entrypoint authz/auth/allow \
			--entrypoint authz/character/allow \
			--entrypoint authz/pages/allow \
			--entrypoint authz/user/allow \
			--entrypoint authz \
			--ignore \*_test.rego \
			--output /build/bundle.tar.gz \
			/rego
	tar -xzvf \
		build/bundle.tar.gz \
		--directory=ui/public \
		/policy.wasm
	rm build/bundle.tar.gz
	cp -v ui/public/policy.wasm ui/src/testdata

opa-test:
	opa test --verbose internal/policy/rego
	opa test --verbose internal/policy/testdata

opa-coverage:
	opa test --coverage --verbose internal/policy/rego

dev: opa-build
	USER=${UID}:${GID} \
	docker-compose up \
		--build \
		--renew-anon-volumes \
		--force-recreate \
		--abort-on-container-exit

go-update:
	go get -u all
	go mod tidy
	go mod vendor

go-coverage:
	go test -coverprofile cover.out ./cmd/... ./internal/...
	go tool cover -html=cover.out

lint:
	golangci-lint run -v

format:
	gofmt -s -w cmd
	gofmt -s -w internal

go-test:
	go test -race -count 10 -v ./cmd/... ./internal/...

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
		--build-arg GIT_BRANCH="$(GIT_BRANCH)" \
		--build-arg GIT_COMMIT="$(GIT_COMMIT)" \
		--build-arg GIT_TAG="$(GIT_TAG)" \
		--tag $(BINARY_NAME) \
		.

docker-run: docker
	docker volume create $(BINARY_NAME)
	docker run \
		-v $(BINARY_NAME):/database \
		-e DNDMACHINE_DSN=sqlite:///database/machine.db \
		$(BINARY_NAME) \
		storage upgrade
	docker run \
		-v $(BINARY_NAME):/database \
		-e DNDMACHINE_DSN=sqlite:///database/machine.db \
		-p 8080:8080 \
		$(BINARY_NAME)

clean:
	rm \
		$(BINARY_NAME) \
		cover.out \
		ui/build \
		ui/public/policy.wasm
	docker volume rm $(BINARY_NAME)

npm-install:
	docker run \
		--rm -it \
		-u ${UID}:${GID} \
		-v ${PWD}/ui:/project \
		-w /project \
		node:17.9-stretch \
			npm install --no-save npm-check-updates

serve-ui: npm-install
	docker run \
		--rm -it \
		-p 3000:3000 \
		-u ${UID}:${GID} \
		-v ${PWD}/ui:/project \
		-w /project \
		node:17.9-stretch \
			npm start

ui-test-watch: opa-build npm-install
	docker run \
		--rm -it \
		-u ${UID}:${GID} \
		-v ${PWD}/ui:/project \
		-w /project \
		node:17.9-stretch \
			 npm test

ui-test: opa-build npm-install
	docker run \
		--rm -it \
		-u ${UID}:${GID} \
		-v ${PWD}/ui:/project \
		-w /project \
		node:17.9-stretch \
			npm test -- --all --watchAll=false

ui-coverage: npm-install
	docker run \
		--rm -it \
		-u ${UID}:${GID} \
		-v ${PWD}/ui:/project \
		-w /project \
		node:17.9-stretch \
			npm test -- --all --watchAll=false --coverage

ui-build: npm-install
	docker run \
		--rm -it \
		-u ${UID}:${GID} \
		-v ${PWD}/ui:/project \
		-w /project \
		node:17.9-stretch \
			npm run build

ui-shell: npm-install
	docker run \
		--rm -it \
		-u ${UID}:${GID} \
		-v ${PWD}/ui:/project \
		-w /project \
		node:17.9-stretch \
			/bin/bash

ui-update: npm-install
	docker run \
		--rm -it \
		-u ${UID}:${GID} \
		-v ${PWD}/ui:/project \
		-w /project \
		node:17.9-stretch /bin/bash -c '\
			./node_modules/.bin/ncu -u ; \
			npm update ; \
		'

