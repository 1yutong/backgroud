#!/bin/bash

# 锁屏时间壁纸服务停止脚本
# 功能：停止壁纸定时服务和 HTTP 服务器

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 日志文件
LOG_FILE="services.log"

echo -e "${GREEN}=== 锁屏时间壁纸服务停止脚本 ===${NC}"

# 停止壁纸服务
echo -e "${YELLOW}停止壁纸定时服务...${NC}"
WALLPAPER_PID=$(ps aux | grep "wallpaper_service.py" | grep -v grep | awk '{print $2}')
if [ -n "$WALLPAPER_PID" ]; then
    kill -9 $WALLPAPER_PID 2>/dev/null
    echo -e "${GREEN}✓ 壁纸服务已停止 (PID: $WALLPAPER_PID)${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 壁纸服务停止，PID: $WALLPAPER_PID" >> "$LOG_FILE"
else
    echo -e "${YELLOW}⚠️  壁纸服务未运行${NC}"
fi

# 停止 HTTP 服务器
echo -e "${YELLOW}停止 HTTP 服务器...${NC}"
HTTP_PID=$(ps aux | grep "http.server" | grep -v grep | awk '{print $2}')
if [ -n "$HTTP_PID" ]; then
    kill -9 $HTTP_PID 2>/dev/null
    echo -e "${GREEN}✓ HTTP 服务器已停止 (PID: $HTTP_PID)${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] HTTP 服务器停止，PID: $HTTP_PID" >> "$LOG_FILE"
else
    echo -e "${YELLOW}⚠️  HTTP 服务器未运行${NC}"
fi

echo -e "${GREEN}\n=== 服务停止完成 ===${NC}"
echo -e "${YELLOW}所有服务已停止${NC}"
echo -e "${GREEN}✓ 操作完成！${NC}"
