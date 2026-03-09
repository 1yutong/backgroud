#!/usr/bin/env python3
"""
锁屏时间壁纸生成工具
生成带有当前时间和日期的壁纸图片
"""

import os
import datetime
from PIL import Image, ImageDraw, ImageFont

def generate_wallpaper(output_path='lockscreen_wallpaper.png', width=1080, height=1920):
    """
    生成带时间的锁屏壁纸
    
    Args:
        output_path: 输出图片路径
        width: 壁纸宽度
        height: 壁纸高度
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
        # 尝试使用系统字体
        font_large = ImageFont.truetype('Arial', 180)
        font_small = ImageFont.truetype('Arial', 48)
    except Exception:
        # 如果没有Arial字体，使用默认字体
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
    print(f"壁纸已生成：{output_path}")
    print(f"时间：{time_str}")
    print(f"日期：{date_str}")
    
    return output_path

def main():
    """
    主函数
    """
    print("=== 锁屏时间壁纸生成工具 ===")
    print("正在生成带时间的壁纸...")
    
    # 生成壁纸
    output_path = generate_wallpaper()
    
    # 显示生成的文件
    if os.path.exists(output_path):
        print(f"\n生成成功！文件位置：{os.path.abspath(output_path)}")
        print("\n使用说明：")
        print("1. 将生成的图片传输到手机")
        print("2. 在手机设置中选择该图片作为锁屏壁纸")
        print("3. 可以配合Tasker等工具定时运行此脚本更新壁纸")
    else:
        print("生成失败，请检查错误信息")

if __name__ == "__main__":
    main()
