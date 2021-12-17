FROM golang:1.17 as build

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

COPY --from=build /app/dndmachine /app/dndmachine
COPY --from=nonroot /etc/passwd /etc/passwd

ENTRYPOINT [ "/app/dndmachine" ]