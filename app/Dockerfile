FROM golang:1.24-alpine AS builder

ARG VERSION=dev
ARG COMMIT=unknown
ARG DATE=unknown

RUN apk add --no-cache git ca-certificates

WORKDIR /app

COPY src/go.mod src/go.sum ./

RUN go mod download

COPY src/ ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags="-w -s -X main.Version=${VERSION} -X main.Commit=${COMMIT} -X main.Date=${DATE}" \
    -a -installsuffix cgo \
    -o gatus \
    .

FROM alpine:3.19

RUN apk add --no-cache \
    ca-certificates \
    tzdata \
    curl

RUN mkdir -p /config && \
    chown -R nobody:nobody /config

COPY --from=builder /app/gatus /usr/local/bin/gatus
RUN chmod +x /usr/local/bin/gatus

COPY config.yaml /config/config.yaml
RUN chown nobody:nobody /config/config.yaml

USER nobody

EXPOSE 8080

ENV GATUS_CONFIG_PATH=/config/config.yaml

CMD ["/usr/local/bin/gatus"]
