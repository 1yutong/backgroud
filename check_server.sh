#!/bin/bash

# 服务器连接检查脚本
# 用于诊断 HTTP 服务器无法访问的问题

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}=== 服务器连接诊断工具 ===${NC}"
echo ""

# 检查 HTTP 服务是否运行
echo -e "${BLUE}1. 检查 HTTP 服务状态...${NC}"
HTTP_PID=$(ps aux | grep "http.server" | grep -v grep | awk '{print $2}')
if [ -n "$HTTP_PID" ]; then
    echo -e "${GREEN}✓ HTTP 服务正在运行，PID: $HTTP_PID${NC}"
    
    # 显示监听地址和端口
    echo -e "${BLUE}   监听信息:${NC}"
    netstat -tlnp 2>/dev/null | grep "$HTTP_PID" || ss -tlnp 2>/dev/null | grep "$HTTP_PID" || echo "   无法获取监听信息"
else
    echo -e "${RED}✗ HTTP 服务未运行${NC}"
fi
echo ""

# 检查端口监听
echo -e "${BLUE}2. 检查端口 7999 监听状态...${NC}"
if command -v netstat &> /dev/null; then
    LISTEN_INFO=$(netstat -tlnp 2>/dev/null | grep ':7999')
    if [ -n "$LISTEN_INFO" ]; then
        echo -e "${GREEN}✓ 端口 7999 正在监听:${NC}"
        echo "   $LISTEN_INFO"
    else
        echo -e "${RED}✗ 端口 7999 未监听${NC}"
    fi
elif command -v ss &> /dev/null; then
    LISTEN_INFO=$(ss -tlnp 2>/dev/null | grep ':7999')
    if [ -n "$LISTEN_INFO" ]; then
        echo -e "${GREEN}✓ 端口 7999 正在监听:${NC}"
        echo "   $LISTEN_INFO"
    else
        echo -e "${RED}✗ 端口 7999 未监听${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  未找到 netstat 或 ss 命令${NC}"
fi
echo ""

# 检查防火墙状态
echo -e "${BLUE}3. 检查防火墙状态...${NC}"

# 检查 UFW
if command -v ufw &> /dev/null; then
    echo -e "${YELLOW}   UFW 防火墙状态:${NC}"
    ufw status verbose 2>/dev/null | head -20
    
    # 检查端口是否开放
    UFW_STATUS=$(ufw status | grep '7999')
    if [ -n "$UFW_STATUS" ]; then
        echo -e "${GREEN}   ✓ 端口 7999 已在 UFW 中配置${NC}"
    else
        echo -e "${RED}   ✗ 端口 7999 未在 UFW 中开放${NC}"
        echo -e "${YELLOW}   建议执行: sudo ufw allow 7999/tcp${NC}"
    fi
else
    echo -e "${YELLOW}   UFW 未安装${NC}"
fi

# 检查 iptables
if command -v iptables &> /dev/null; then
    echo -e "${YELLOW}   iptables 规则:${NC}"
    iptables -L -n 2>/dev/null | grep -E "(Chain|7999)" | head -10
fi
echo ""

# 检查 SELinux
echo -e "${BLUE}4. 检查 SELinux 状态...${NC}"
if command -v getenforce &> /dev/null; then
    SELINUX_STATUS=$(getenforce)
    echo -e "   SELinux 状态: $SELINUX_STATUS"
    if [ "$SELINUX_STATUS" = "Enforcing" ]; then
        echo -e "${YELLOW}   ⚠️  SELinux 可能阻止连接，建议临时禁用:${NC}"
        echo "      sudo setenforce 0"
    fi
else
    echo -e "${YELLOW}   SELinux 未启用或未安装${NC}"
fi
echo ""

# 本地测试
echo -e "${BLUE}5. 本地连接测试...${NC}"
if command -v curl &> /dev/null; then
    echo -e "   测试 localhost:7999..."
    curl -s -o /dev/null -w "   HTTP 状态码: %{http_code}, 响应时间: %{time_total}s\n" http://localhost:7999/ || echo -e "   ${RED}✗ 无法连接到 localhost:7999${NC}"
    
    echo -e "   测试 127.0.0.1:7999..."
    curl -s -o /dev/null -w "   HTTP 状态码: %{http_code}, 响应时间: %{time_total}s\n" http://127.0.0.1:7999/ || echo -e "   ${RED}✗ 无法连接到 127.0.0.1:7999${NC}"
else
    echo -e "${YELLOW}   curl 未安装，跳过本地测试${NC}"
fi
echo ""

# 获取服务器 IP
echo -e "${BLUE}6. 服务器网络信息...${NC}"
echo -e "   服务器 IP 地址:"
ip addr show 2>/dev/null | grep "inet " | awk '{print "   " $2}' | head -5

echo ""
echo -e "${GREEN}=== 诊断完成 ===${NC}"
echo ""
echo -e "${YELLOW}常见问题解决方案:${NC}"
echo "1. 如果防火墙阻止，执行: sudo ufw allow 7999/tcp"
echo "2. 如果是云服务器，检查安全组规则，开放 7999 端口"
echo "3. 如果 SELinux 阻止，执行: sudo setenforce 0"
echo "4. 重启服务: ./stop_services.sh && ./start_services.sh"
