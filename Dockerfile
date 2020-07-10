# Builder image
FROM golang:alpine3.10 AS builder

# set vegeta build args
ARG VEGETA_SRC=github.com/tsenart/vegeta
ARG VEGETA_VERS=v12.7.0

# build vegeta
RUN apk --no-cache add build-base git bzr mercurial gcc && \
    go get -u -d ${VEGETA_SRC} && \
    cd /go/src/${VEGETA_SRC} && \
    git checkout -b ${VEGETA_VERS} && \
    echo "building vegeta version: ${VEGETA_VERS}" && \
    go install ${VEGETA_SRC}

# Production image
FROM alpine:3.10 AS final

# copy from builder
COPY --from=builder /go/bin/vegeta /usr/bin/vegeta
