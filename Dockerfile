FROM --platform=${BUILDPLATFORM} cromrots/opa:0.41 as opa

COPY internal/policy/rego rego

RUN /opa build \
        --target wasm \
        --output /data/bundle.tar.gz \
        --entrypoint authz/auth/allow \
        --entrypoint authz/character/allow \
        --entrypoint authz/pages/allow \
        --entrypoint authz/user/allow \
        --ignore \\*_test.rego \
        rego

FROM --platform=${BUILDPLATFORM} node:17.9-stretch as frontend

WORKDIR /app

COPY ui/package.json ui/package-lock.json ./

RUN npm install

COPY ui .

RUN npm run build

COPY --from=opa /data/bundle.tar.gz .

RUN tar \
    --to-stdout \
        -xzf ./bundle.tar.gz \
        /policy.wasm \
    > public/policy.wasm

FROM --platform=${BUILDPLATFORM} golang:1.18 as backend

WORKDIR /build

ARG TARGETOS
ARG TARGETARCH

ENV CGO_ENABLED=0
ENV GO111MODULE=on
ENV GOFLAGS=-mod=vendor
ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}

ARG GIT_TAG
ARG GIT_COMMIT
ARG GIT_BRANCH

RUN --mount=target=. \
    BUILD_TIME=$(date -Iseconds) \
    go build \
    -o /app/dndmachine \
    -ldflags "\
        -s -w \
        -X 'github.com/SebastiaanPasterkamp/dndmachine/internal/build.Version=${GIT_TAG}' \
        -X 'github.com/SebastiaanPasterkamp/dndmachine/internal/build.Commit=${GIT_COMMIT}' \
        -X 'github.com/SebastiaanPasterkamp/dndmachine/internal/build.Branch=${GIT_BRANCH}' \
        -X 'github.com/SebastiaanPasterkamp/dndmachine/internal/build.Timestamp=${BUILD_TIME}' \
    " \
    cmd/dndmachine/main.go

FROM --platform=${BUILDPLATFORM} alpine:3.12 AS security

RUN apk add --no-cache \
    ca-certificates

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

FROM --platform=${TARGETPLATFORM} scratch

EXPOSE 9090

ARG GIT_TAG
ARG GIT_COMMIT
ARG GIT_BRANCH

LABEL maintainer="dungeons.dragons.machine@gmail.com"
LABEL version=${GIT_TAG}
LABEL build.branch=${GIT_BRANCH}
LABEL build.sha=${GIT_COMMIT}

COPY LICENSE /app/
COPY schema/ /app/schema/

COPY --from=security /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=security /etc/passwd /etc/passwd
COPY --from=frontend /app/build/ /app/public/
COPY --from=backend /app/dndmachine /app/

EXPOSE 8080

ENTRYPOINT [ "/app/dndmachine" ]

CMD ["serve", "--public-path", "/app/public"]
