# Snell_v4-Auto

## 使用方法

### 下载并执行
```
curl -sS -O https://raw.githubusercontent.com/yuju520/Snell_v4-Auto/main/Snell_v4-Auto.sh && chmod +x Snell_v4-Auto.sh && ./Snell_v4-Auto.sh
```
或
```
wget -q https://raw.githubusercontent.com/yuju520/Snell_v4-Auto/main/Snell_v4-Auto.sh && chmod +x Snell_v4-Auto.sh && ./Snell_v4-Auto.sh
```

### Tips
1.脚本执行后会自动从大佬的仓库下载已经编译好的文件并进行安装。

2.脚本运行后，会提示输入自定义端口、密钥等信息。（当然可以像我一样偷懒地全部回车）

### 卸载
停止 Snell_v4 服务：
```
sudo systemctl stop snell
```

禁用 Snell_v4 服务自启动：
```
sudo systemctl disable snell
```

删除 Snell_v4 服务文件并重新加载 systemd 配置：
```
sudo rm /etc/systemd/system/snell.service
sudo systemctl daemon-reload
```

删除 Snell_v4 相关配置文件及目录和可执行文件：
```
sudo rm -rf /etc/snell
sudo rm /usr/local/bin/snell-server
```

## 项目参考
https://manual.nssurge.com/others/snell.html
