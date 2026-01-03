# 版本号（默认 dev，可通过命令行传入：make build VERSION=v1.0.0）
VERSION ?= dev

.PHONY: web-deps web build all

# 前端依赖安装
web-deps:
	cd web && npm ci

# 前端构建
web:
	cd web && npm run build
	find web/dist/assets -type f \( -name '*.js' -o -name '*.css' \) -exec gzip -kf -9 {} \;

# 后端构建
build:
	go build -ldflags "-s -w -X main.Version=$(VERSION)" -o bin/server

# 完整构建（前端 + 后端）
all: web build
	@echo "Build complete: bin/server (Version: $(VERSION))"
