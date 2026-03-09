#!/usr/bin/env python3
import os
import sys

print("="*50)
print("智能盆栽系统 - 硬件检测")
print("="*50)

# 检查 I2C 设备
print("\n--- I2C 总线检测 ---")
if os.path.exists('/dev/i2c-1'):
    print("✅ I2C 设备存在 (/dev/i2c-1)")
    try:
        import smbus2
        print("✅ smbus2 模块可用")
        bus = smbus2.SMBus(1)
        print("✅ I2C 总线可访问")
    except Exception as e:
        print(f"❌ I2C 访问失败: {e}")
else:
    print("⚠️ I2C 设备未找到（如果没连接硬件，这是正常的）")

# 检查摄像头
print("\n--- 摄像头检测 ---")
if os.path.exists('/dev/video0'):
    print("✅ 摄像头设备存在 (/dev/video0)")
    try:
        import cv2
        print(f"✅ OpenCV 版本: {cv2.__version__}")
    except ImportError:
        print("⚠️ OpenCV 未安装")
else:
    print("⚠️ 摄像头设备未找到（如果没连接，这是正常的）")

# 检查 GPIO
print("\n--- GPIO 检测 ---")
if os.path.exists('/dev/gpiochip0'):
    print("✅ GPIO 设备存在")
else:
    print("⚠️ GPIO 设备未找到")

print("\n" + "="*50)
