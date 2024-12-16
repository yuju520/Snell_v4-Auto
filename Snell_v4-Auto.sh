#!/bin/bash

# 检查是否以 root 权限运行
if [ "$EUID" -ne 0 ]; then
    echo "请使用 sudo 权限运行此脚本"
    exit 1
fi

# 预装必要软件
apt update && apt upgrade -y
apt install -y wget unzip vim

# 检测系统架构
ARCH=$(uname -m)

# 根据系统架构选择下载链接
if [[ "$ARCH" == "x86_64" ]]; then
    DOWNLOAD_URL="https://dl.nssurge.com/snell/snell-server-v4.1.1-linux-amd64.zip"
    ZIP_FILE="snell-server-v4.1.1-linux-amd64.zip"
elif [[ "$ARCH" == "aarch64" ]]; then
    DOWNLOAD_URL="https://dl.nssurge.com/snell/snell-server-v4.1.1-linux-aarch64.zip"
    ZIP_FILE="snell-server-v4.1.1-linux-aarch64.zip"
else
    echo "不支持的系统架构: $ARCH"
    exit 1
fi

# 下载 Snell Server
wget "$DOWNLOAD_URL" -O "$ZIP_FILE"

# 创建安装目录并解压
mkdir -p /usr/local/bin
unzip -o "$ZIP_FILE" -d /usr/local/bin

# 赋予执行权限
chmod +x /usr/local/bin/snell-server

# 创建配置目录
mkdir -p /etc/snell

# 交互式配置
echo "请配置 Snell Server："
read -p "请输入监听端口 (默认 11807): " PORT
PORT=${PORT:-11807}

read -p "请输入 PSK (留空将生成随机密钥): " PSK
if [ -z "$PSK" ]; then
    PSK=$(openssl rand -hex 16)
fi

read -p "是否启用 IPv6? (true/false, 默认 false): " IPV6
IPV6=${IPV6:-false}

# 写入配置文件
cat > /etc/snell/snell-server.conf << EOL
[snell-server]
listen = 0.0.0.0:$PORT
psk = $PSK
ipv6 = $IPV6
EOL

# 配置 Systemd 服务文件
cat > /lib/systemd/system/snell.service << EOL
[Unit]
Description=Snell Proxy Service
After=network.target

[Service]
Type=simple
User=nobody
Group=nogroup
LimitNOFILE=32768
ExecStart=/usr/local/bin/snell-server -c /etc/snell/snell-server.conf
AmbientCapabilities=CAP_NET_BIND_SERVICE
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=snell-server

[Install]
WantedBy=multi-user.target
EOL

# 重载服务并启动
systemctl daemon-reload
systemctl enable snell
systemctl start snell

# 清理下载的压缩文件
rm "$ZIP_FILE"

echo "Snell Server 安装完成！"
echo "端口: $PORT"
echo "PSK: $PSK"
echo "IPv6: $IPV6"
