FROM node:22-alpine AS frontend-builder

WORKDIR /web

ADD web/package.json web/package-lock.json ./
RUN npm ci

COPY web/ ./
RUN npm run build


FROM golang:alpine AS backend-builder

ARG VERSION=1.0.0
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOCACHE=/root/.cache/go-build \
    GOMODCACHE=/go/pkg/mod

WORKDIR /build

ADD go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .

RUN go build -ldflags "-s -w -X main.Version=${VERSION}" -o aiproxy


FROM alpine:latest

RUN apk upgrade --no-cache \
    && apk add --no-cache ca-certificates tzdata wget \
    && update-ca-certificates \
    && rm -rf /var/cache/apk/*

WORKDIR /app

COPY --from=frontend-builder /web/dist ./web/dist
COPY --from=backend-builder /build/aiproxy .
RUN chmod +x aiproxy

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

ENTRYPOINT ["./aiproxy", "server"]
