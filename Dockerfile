FROM golang:1.17 as backend

RUN go install github.com/open-policy-agent/opa@v0.36.1

RUN opa build \
		--target wasm \
		--entrypoint authz \
		--ignore \*_test.rego \
		internal/policy/rego/ && \
	tar -xzf \
		./bundle.tar.gz \
		--directory=ui/public \
		/policy.wasm

FROM node:17.3-stretch as frontend

WORKDIR /ui

COPY ui .
COPY --from=backend ui/public/policy.wasm ui/public

RUN npm install && \
    npm run build

FROM backend

WORKDIR /app

COPY . .

ENV CGO_ENABLED=0
ENV GO111MODULE=on
ENV GOFLAGS=-mod=vendor

ARG GIT_TAG
ARG GIT_COMMIT
ARG GIT_BRANCH
ARG BUILD_TIME

RUN go build \
    -o dndmachine \
    -ldflags "\
        -s -w \
        -X 'github.com/SebastiaanPasterkamp/dndmachine/internal/build.Version=${GIT_TAG}' \
        -X 'github.com/SebastiaanPasterkamp/dndmachine/internal/build.Commit=${GIT_COMMIT}' \
        -X 'github.com/SebastiaanPasterkamp/dndmachine/internal/build.Branch=${GIT_BRANCH}' \
        -X 'github.com/SebastiaanPasterkamp/dndmachine/internal/build.Timestamp=${BUILD_TIME}' \
    " \
    cmd/dndmachine/main.go

FROM alpine AS nonroot

ENV USER=dndmachine
ENV UID=1000
ENV GID=1000

RUN addgroup \
        -g "$GID" \
        -S \
        $USER \
    && adduser \
        -S \
        -D \
        -g "" \
        -G "$USER" \
        -H \
        -u "$UID" \
        "$USER"

FROM scratch

EXPOSE 9090

ARG GIT_TAG
ARG GIT_COMMIT
ARG GIT_BRANCH
ARG BUILD_TIME

LABEL maintainer="dungeons.dragons.machine@gmail.com"
LABEL version=${GIT_TAG}
LABEL build.time=${BUILD_TIME}
LABEL build.branch=${GIT_BRANCH}
LABEL build.sha=${GIT_COMMIT}

COPY --from=nonroot /etc/passwd /etc/passwd
COPY --from=backend /app/schema /app/LICENSE /app/dndmachine /app/
COPY --from=frontend /ui/build /app/public/

EXPOSE 8080

ENTRYPOINT [ "/app/dndmachine" ]

CMD ["serve", "--public-path", "/app/public"]