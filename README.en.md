<div align="center">

  # AiProxy

  ### 🚀 Enterprise-Grade AI API Proxy Service

  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
  [![Go Version](https://img.shields.io/badge/Go-1.25+-00ADD8?logo=go)](https://golang.org/)
  [![Vue Version](https://img.shields.io/badge/Vue-3.4+-4FC08D?logo=vue.js)](https://vuejs.org/)
  [![GitHub Stars](https://img.shields.io/github/stars/rebecca554owen/aiproxy?style=social)](https://github.com/rebecca554owen/aiproxy/stargazers)
  [![GitHub Forks](https://img.shields.io/github/forks/rebecca554owen/aiproxy?style=social)](https://github.com/rebecca554owen/aiproxy/network/members)

  **A unified API gateway for multiple AI platforms** - Claude, OpenAI, Gemini, and more

  [Features](#-features) • [Quick Start](#-quick-start) • [Screenshots](#-screenshots) • [Documentation](#-documentation)

  [**简体中文**](README.md) | **English**

</div>

---

## 📞 Contact & Community

- **Author WeChat**: suiyue_creation
- **QQ Group**: [Join go-proxy-pro](https://qm.qq.com/q/iJ4bHLlMEa)
- **GitHub Issues**: [Submit issues](https://github.com/rebecca554owen/aiproxy/issues)
- **GitHub Discussions**: [Join discussions](https://github.com/rebecca554owen/aiproxy/discussions)

---

## ✨ Features

### 🎯 Multi-Platform Support
- **Claude**: Official, Console, CCR, Bedrock
- **OpenAI**: API, Azure, Responses API
- **Gemini**: OAuth & API Key modes

### 🔧 Powerful Features
- **Account Pool Management**: Load balancing, failover, rotation
- **User API Keys**: Generate dedicated API keys for users
- **Permission Control**: Platform and model-level access control
- **Usage Statistics**: Request count, token consumption, cost tracking
- **OpenAI Responses API**: Support for Codex CLI and Claude Code
- **Health Monitoring**: Automatic account health checks and recovery

### 🛡️ Enterprise Ready
- JWT authentication for admin panel
- API key authentication for proxy API
- Request logging and audit trails
- Rate limiting and concurrency control
- HTTPS/SSL support with Nginx

---

## 🎸 Screenshots

### Login Page
![Login Page](screenshots/screenshot-01.png)

### System Monitoring
![System Monitoring](screenshots/screenshot-02.png)

### Account Management
![Account Management](screenshots/screenshot-03.png)

### Model Management
![Model Management](screenshots/screenshot-04.png)

### User Management
![User Management](screenshots/screenshot-05.png)

### API Key Management
![API Key Management](screenshots/screenshot-06.png)

### Request Logs
![Request Logs](screenshots/screenshot-07.png)

### Usage Statistics
![Usage Statistics](screenshots/screenshot-08.png)

👉 [View More Screenshots](screenshots/)

---

## 🚀 Quick Start

### Prerequisites

- **Go** 1.25+
- **MySQL** 8.0+
- **Node.js** 22+ (for frontend development)

### Option 1: Docker Deploy (Recommended)

```bash
# Clone the repository
git clone https://github.com/rebecca554owen/aiproxy.git
cd aiproxy

# Build image
docker build -t aiproxy:latest .

# Run container (requires MySQL running first)
docker run -d \
  --name aiproxy \
  --restart unless-stopped \
  -p 8080:8080 \
  -e DB_HOST=host.docker.internal \
  -e DB_PORT=3306 \
  -e DB_USER=root \
  -e DB_PASSWORD=your_password \
  -e DB_NAME=aiproxy \
  aiproxy:latest
```

**Access**:
- 🌐 Web UI: http://localhost:8080
- 📊 API: http://localhost:8080/api/v1/

**Default Admin Account**:
- Username: `admin`
- Password: `admin123`

⚠️ **Change the default password after first login!**

### Option 2: Build from Source

```bash
# Build backend
go build -o aiproxy ./cmd/server

# Run
./aiproxy
```

The service listens on port `8080` by default.

---

## 📚 API Usage

### Base URLs

| Platform | Base URL | Example Endpoint |
|----------|----------|------------------|
| Claude | `http://domain/claude/` | `/claude/v1/messages` |
| OpenAI | `http://domain/openai/` | `/openai/v1/chat/completions` |
| Gemini | `http://domain/gemini/` | `/gemini/v1/chat` |

### Example: Claude API

```bash
curl http://localhost:8080/claude/v1/messages \
  -H "x-api-key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-sonnet-4-20250514",
    "messages": [{"role": "user", "content": "Hello!"}],
    "max_tokens": 1024
  }'
```

### Example: OpenAI API

```bash
curl http://localhost:8080/openai/v1/chat/completions \
  -H "x-api-key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

### Example: OpenAI Responses API (Codex CLI)

```bash
curl http://localhost:8080/responses \
  -H "x-api-key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-5.1-codex-max",
    "input": "Write a hello world function"
  }'
```

---

## 📁 Project Structure

```
AiProxy/
├── cmd/server/          # Application entry point
├── internal/
│   ├── handler/         # HTTP handlers
│   ├── middleware/      # JWT, API Key auth, etc.
│   ├── model/           # Data models
│   ├── repository/      # Data access layer
│   ├── service/         # Business logic
│   └── proxy/           # Proxy core
│       ├── adapter/     # Platform adapters
│       └── scheduler/   # Account scheduler
├── pkg/                 # Common utilities
└── web/                 # Vue 3 frontend
```

---

## 🛠️ Tech Stack

### Backend
- **Go** 1.25+ with **Gin** framework
- **MySQL** 8.0+ with **GORM**
- In-memory caching (sync.Map)
- JWT + API Key authentication

### Frontend
- **Vue** 3.4+ (Composition API)
- **Vite** 5.x
- **Element Plus** 2.6+
- **Alova** 3.x (HTTP client)
- **Font Awesome** 6.x

---

## 🔧 Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | `8080` | Service port |
| `DB_HOST` | `localhost` | MySQL host |
| `DB_PORT` | `3306` | MySQL port |
| `DB_USER` | `root` | MySQL username |
| `DB_PASSWORD` | - | MySQL password |
| `DB_NAME` | `aiproxy` | Database name |

### Docker Compose Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `MYSQL_ROOT_PASSWORD` | `aiproxy-root` | MySQL root password |
| `MYSQL_DATABASE` | `aiproxy` | Database name |
| `MYSQL_USER` | `aiproxy` | MySQL user |
| `MYSQL_PASSWORD` | `aiproxy-password` | MySQL password |
| `JWT_SECRET` | `change-in-production` | JWT secret key |

⚠️ **Change all default passwords in production!**

---

## 📖 Documentation

- [Development Guide](docs/README.md) - Development setup and guidelines
- [API Documentation](docs/接口文档/) - API reference
- [Architecture](docs/架构设计/) - System architecture
- [Troubleshooting](docs/故障排查手册.md) - Common issues and solutions

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## ⭐ Star History

If you find this project helpful, please consider giving it a star! ⭐

<div align="center">

  **Made with ❤️ by suiyuebaobao**

  **95% of this project was developed using GLM with Claude Code**

  [⬆ Back to Top](#AiProxy)

</div>
