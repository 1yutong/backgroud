#!/usr/bin/env python3
"""
锁屏时间壁纸定时服务
每分钟自动生成新的壁纸
"""

import os
import time
import datetime
from PIL import Image, ImageDraw, ImageFont
import threading

def generate_wallpaper(output_path='lockscreen_wallpaper.png', width=1080, height=1920):
    """
    生成带时间的锁屏壁纸
    """
    # 创建背景图片
    image = Image.new('RGB', (width, height), color='#1a1a2e')
    draw = ImageDraw.Draw(image)
    
    # 绘制渐变背景
    for y in range(height):
        r = int(26 - y * 10 / height)
        g = int(26 - y * 5 / height)
        b = int(46 + y * 30 / height)
        draw.line([(0, y), (width, y)], fill=(r, g, b))
    
    # 获取当前时间
    now = datetime.datetime.now()
    time_str = now.strftime('%H:%M')
    date_str = now.strftime('%Y年%m月%d日 %A')
    
    # 设置字体
    try:
        font_large = ImageFont.truetype('Arial', 180)
        font_small = ImageFont.truetype('Arial', 48)
    except Exception:
        font_large = ImageFont.load_default()
        font_small = ImageFont.load_default()
    
    # 计算文本位置
    time_bbox = draw.textbbox((0, 0), time_str, font=font_large)
    time_width = time_bbox[2] - time_bbox[0]
    time_height = time_bbox[3] - time_bbox[1]
    time_x = (width - time_width) // 2
    time_y = (height - time_height) // 2 - 50
    
    date_bbox = draw.textbbox((0, 0), date_str, font=font_small)
    date_width = date_bbox[2] - date_bbox[0]
    date_x = (width - date_width) // 2
    date_y = (height - date_bbox[3] + date_bbox[1]) // 2 + 100
    
    # 绘制时间和日期
    draw.text((time_x, time_y), time_str, font=font_large, fill='#FFFFFF')
    draw.text((date_x, date_y), date_str, font=font_small, fill='#CCCCCC')
    
    # 保存图片
    image.save(output_path)
    timestamp = now.strftime('%Y-%m-%d %H:%M:%S')
    print(f"[{timestamp}] 壁纸已更新：{output_path}")
    
    return output_path

def run_service(interval=60):
    """
    运行壁纸更新服务
    
    Args:
        interval: 更新间隔（秒）
    """
    print("=== 锁屏时间壁纸服务启动 ===")
    print(f"更新间隔：{interval}秒")
    print("按 Ctrl+C 停止服务")
    print("=" * 50)
    
    try:
        while True:
            generate_wallpaper()
            time.sleep(interval)
    except KeyboardInterrupt:
        print("\n=== 服务已停止 ===")

def main():
    """
    主函数
    """
    # 启动服务
    run_service()

if __name__ == "__main__":
    main()
