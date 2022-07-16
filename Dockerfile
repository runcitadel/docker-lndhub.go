ARG VERSION=0.9.0

FROM ghcr.io/runcitadel/go:main as builder

ARG VERSION

RUN apk add git gcc musl-dev

# Move to working directory /build
WORKDIR /build

# Download lndhub.go
RUN git clone https://github.com/getAlby/lndhub.go .

# Copy and download dependency using go mod
RUN go mod download

# Build the application
RUN go build -o main

# Start a new, final image to reduce size.
FROM alpine:edge as final

# Copy the binaries and entrypoint from the builder image.
COPY --from=builder /build/main /bin/lndhub

ENTRYPOINT [ "/bin/lndhub" ]
