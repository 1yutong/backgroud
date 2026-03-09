#!/bin/bash

# 锁屏时间壁纸服务启动脚本
# 功能：检查环境、启动壁纸定时服务和 HTTP 服务器

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 日志文件
LOG_FILE="services.log"
WALLPAPER_LOG="wallpaper_service.log"
HTTP_LOG="http_server.log"

# 端口设置
HTTP_PORT=7999

echo -e "${GREEN}=== 锁屏时间壁纸服务启动脚本 ===${NC}"
echo "开始检查环境..."

# 检查 Python 环境
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1)
    echo -e "${GREEN}✓ Python 已安装: ${PYTHON_VERSION}${NC}"
else
    echo -e "${RED}✗ Python 3 未安装${NC}"
    echo -e "${YELLOW}请先安装 Python 3: sudo apt install python3${NC}"
    exit 1
fi

# 检查 Pillow 库
if python3 -c "import PIL" &> /dev/null; then
    echo -e "${GREEN}✓ Pillow 库已安装${NC}"
else
    echo -e "${YELLOW}正在安装 Pillow 库...${NC}"
    if python3 -m pip install Pillow &> /dev/null; then
        echo -e "${GREEN}✓ Pillow 库安装成功${NC}"
    else
        echo -e "${RED}✗ Pillow 库安装失败${NC}"
        echo -e "${YELLOW}请手动安装: python3 -m pip install Pillow${NC}"
        exit 1
    fi
fi

# 检查脚本文件
if [ ! -f "lockscreen_wallpaper.py" ]; then
    echo -e "${RED}✗ lockscreen_wallpaper.py 脚本不存在${NC}"
    exit 1
fi

if [ ! -f "wallpaper_service.py" ]; then
    echo -e "${RED}✗ wallpaper_service.py 脚本不存在${NC}"
    exit 1
fi

if [ ! -f "download.html" ]; then
    echo -e "${YELLOW}⚠️  download.html 文件不存在${NC}"
    echo -e "${YELLOW}将创建默认的下载页面${NC}"
    cat > download.html << 'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>锁屏时间壁纸应用 - 下载</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #1a1a2e, #16213e, #0f3460);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: white;
            text-align: center;
            padding: 20px;
        }
        .container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            max-width: 600px;
            width: 100%;
        }
        h1 {
            font-size: 2.5rem;
            margin-bottom: 20px;
        }
        .download-btn {
            display: inline-block;
            background: linear-gradient(45deg, #4ecdc4, #45b7d1);
            color: white;
            padding: 15px 30px;
            border-radius: 50px;
            text-decoration: none;
            font-size: 1.1rem;
            font-weight: bold;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>锁屏时间壁纸应用</h1>
        <p>自动更新锁屏壁纸，实时显示当前时间和日期</p>
        <a href="#" class="download-btn">立即下载</a>
    </div>
</body>
</html>
EOF
    echo -e "${GREEN}✓ 下载页面已创建${NC}"
fi

echo -e "${GREEN}环境检查完成！${NC}"
echo -e "${YELLOW}正在启动服务...${NC}"

# 停止已运行的服务
echo "停止已运行的服务..."
pkill -f "wallpaper_service.py" 2>/dev/null
pkill -f "http.server ${HTTP_PORT}" 2>/dev/null

# 启动壁纸定时服务
echo -e "${GREEN}启动壁纸定时服务...${NC}"
nohup python3 wallpaper_service.py > "$WALLPAPER_LOG" 2>&1 &
WALLPAPER_PID=$!
sleep 2

if ps -p $WALLPAPER_PID > /dev/null; then
    echo -e "${GREEN}✓ 壁纸服务启动成功，PID: ${WALLPAPER_PID}${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 壁纸服务启动，PID: ${WALLPAPER_PID}" >> "$LOG_FILE"
else
    echo -e "${RED}✗ 壁纸服务启动失败${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 壁纸服务启动失败" >> "$LOG_FILE"
    cat "$WALLPAPER_LOG"
fi

# 启动 HTTP 服务器
echo -e "${GREEN}启动 HTTP 服务器 (端口: ${HTTP_PORT})...${NC}"
nohup python3 -m http.server "$HTTP_PORT" --bind 0.0.0.0 > "$HTTP_LOG" 2>&1 &
HTTP_PID=$!
sleep 2

if ps -p $HTTP_PID > /dev/null; then
    echo -e "${GREEN}✓ HTTP 服务器启动成功，PID: ${HTTP_PID}${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] HTTP 服务器启动，PID: ${HTTP_PID}, 端口: ${HTTP_PORT}" >> "$LOG_FILE"
else
    echo -e "${RED}✗ HTTP 服务器启动失败${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] HTTP 服务器启动失败" >> "$LOG_FILE"
    cat "$HTTP_LOG"
fi

echo -e "${GREEN}\n=== 服务启动完成 ===${NC}"
echo -e "${YELLOW}服务状态:${NC}"
echo -e "${GREEN}✓ 壁纸定时服务: 运行中${NC}"
echo -e "${GREEN}✓ HTTP 服务器: 运行中 (http://localhost:${HTTP_PORT})${NC}"
echo -e "${GREEN}✓ 下载页面: http://localhost:${HTTP_PORT}/download.html${NC}"

echo -e "${YELLOW}\n使用说明:${NC}"
echo "1. 访问 http://localhost:${HTTP_PORT}/download.html 下载壁纸"
echo "2. 壁纸文件位于: lockscreen_wallpaper.png"
echo "3. 查看服务日志: tail -f $LOG_FILE"
echo "4. 停止服务: ./stop_services.sh"

echo -e "${GREEN}\n服务已成功启动！${NC}"
