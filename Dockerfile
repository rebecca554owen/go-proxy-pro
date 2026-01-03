# 构建阶段
FROM golang:alpine AS builder

WORKDIR /build

ARG VERSION=1.0.0
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOCACHE=/root/.cache/go-build \
    GOMODCACHE=/go/pkg/mod

# 先复制 go.mod 和 go.sum 以利用 Docker 缓存
COPY go.mod go.sum ./
RUN go mod download && go mod verify

# 复制源代码
COPY . .

# 复制预构建的前端资源（在 Actions 中构建）
COPY ./web/dist ./web/dist

# 构建后端（使用优化参数）
RUN go build -ldflags "-s -w" -o bin/server ./cmd/server

# 运行阶段
FROM alpine:latest

# 安装运行时依赖时使用缓存
RUN apk upgrade --no-cache \
    && apk add --no-cache ca-certificates tzdata wget \
    && update-ca-certificates \
    && rm -rf /var/cache/apk/*

WORKDIR /app

# 复制二进制文件并设置最小权限
COPY --from=builder /build/bin/server ./aiproxy
RUN chmod +x aiproxy

# 复制前端资源
COPY --from=builder /build/web/dist ./internal/handler/dist/

# 创建非 root 用户（安全增强）
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup && \
    chown -R appuser:appgroup /app

# 创建日志目录
RUN mkdir -p logs && chown -R appuser:appgroup logs

USER appuser

EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

ENTRYPOINT ["./aiproxy", "server"]
