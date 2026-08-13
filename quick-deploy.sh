#!/bin/bash

# Adobe2API 一键部署脚本
# 使用方法：curl -fsSL https://raw.githubusercontent.com/zjaacmyx/adobe2api-master/main/quick-deploy.sh | bash

set -e

echo "====== Adobe2API Docker 一键部署 ======"

# 检查 Docker
if ! command -v docker &> /dev/null; then
    echo "安装 Docker..."
    curl -fsSL https://get.docker.com | sh
    systemctl start docker
    systemctl enable docker
fi

# 创建数据目录
mkdir -p /opt/adobe2api/{config,data}
cd /opt/adobe2api

# 创建 docker-compose.yml
cat > docker-compose.yml <<'EOF'
version: '3.8'

services:
  adobe2api:
    image: your-dockerhub-username/adobe2api:latest
    container_name: adobe2api
    ports:
      - "6001:6001"
    volumes:
      - ./config:/app/config
      - ./data:/app/data
    restart: always
    environment:
      - TZ=Asia/Shanghai
EOF

# 启动服务
docker compose pull
docker compose up -d

echo "====== 部署完成 ======"
echo "访问地址: http://$(curl -s ifconfig.me):6001"
echo "默认账号: admin"
echo "默认密码: admin"
echo ""
echo "管理命令："
echo "  查看状态: cd /opt/adobe2api && docker compose ps"
echo "  查看日志: cd /opt/adobe2api && docker compose logs -f"
echo "  重启服务: cd /opt/adobe2api && docker compose restart"
echo "  停止服务: cd /opt/adobe2api && docker compose down"
