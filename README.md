# 🌱 智能盆栽养护系统

## 📋 项目信息

| 项目     | 说明                               |
| -------- | ---------------------------------- |
| 项目名称 | 融合视觉与传感器的智能盆栽养护系统 |
| 作者     | 赵尧瑶                             |
| 班级     | 网工2201                           |
| 学号     | 2022011246                         |
| 指导教师 | 焦健                               |



```markdown
# 智能盆栽养护系统 - 飞腾派后端

基于飞腾派的智能盆栽养护系统，集成了 I2C 传感器（BH1750 光照、AHT10 温湿度、PCF8591 土壤湿度）、USB 摄像头拍照、ONNX 模型图片分析、水泵控制等功能。

## 功能特性

- 🌡️ **环境监测**：实时读取光照、温度、湿度、土壤湿度
- 📷 **拍照识别**：USB 摄像头拍照，ONNX 模型分析叶片健康状态
- 💧 **自动浇水**：通过 GPIO 控制水泵，支持手动/自动浇水
- 📊 **规则引擎**：多因子综合判断盆栽健康状态
- 🌐 **HTTP API**：提供 RESTful API 供微信小程序调用

## 文件结构

```

smart-plant-care/
├── src/
│   ├── camera_server          # 编译后的可执行文件
│   └── camera_server.c        # C 语言主程序源码
├── models/
│   └── leaf_classifier.onnx   # ONNX 模型文件
├── photos/                    # 照片存储目录
│   ├── latest.jpg             # 最新照片
│   └── 20260501_*.jpg         # 按时间命名的历史照片
├── analyze.py                 # 图片分析脚本（调用 ONNX 模型）
├── utils/
│   └── image_analyzer.py      # 图像分析模块（备用）
└── requirements.txt           # Python 依赖

```
## 硬件接线

### I2C 传感器（SDA 接脚27，SCL 接脚28）

| 传感器 | 地址 | VCC | GND | SDA | SCL |
|--------|------|-----|-----|-----|-----|
| BH1750 | 0x23 | 3.3V | GND | 脚27 | 脚28 |
| AHT10 | 0x38 | 3.3V | GND | 脚27 | 脚28 |
| PCF8591 | 0x48 | 3.3V | GND | 脚27 | 脚28 |

### 水泵控制（L9110S 驱动模块）

| 模块引脚 | 飞腾派引脚 | 说明 |
|----------|-----------|------|
| IA | 脚11 (GPIO449) | 控制信号 A |
| IB | 脚13 (GPIO492) | 控制信号 B |
| VCC | 5V | 模块供电 |
| GND | GND | 共地 |
| OA/OB | 水泵正负极 | 电机输出 |

### 模拟土壤湿度传感器

| 传感器引脚 | 连接 |
|-----------|------|
| VCC | 3.3V |
| GND | GND |
| AO | PCF8591 AIN0 |

## 编译与运行

### 1. 编译 C 服务

```bash
cd /home/user/smart-plant-care/src
gcc -o camera_server camera_server.c
```

### 2. 运行服务

```bash
sudo ./camera_server
```

### 3. 查看日志

服务启动后会显示：

```
========================================
  飞腾派 I2C 传感器 HTTP 服务 v3.0
  监听端口: 8000
  照片目录: /home/user/smart-plant-care/photos
  浇水时长: 2 秒
========================================
```

## API 接口

| 方法 | 路径                      | 说明                      |
| ---- | ------------------------- | ------------------------- |
| GET  | `/api/plant/status`       | 获取传感器数据 + 健康状态 |
| GET  | `/api/plant/latest-image` | 获取最新照片              |
| GET  | `/api/plant/photos`       | 获取历史照片列表          |
| GET  | `/api/plant/photo/{name}` | 获取指定照片              |
| POST | `/api/plant/capture`      | 手动拍照                  |
| POST | `/api/plant/water`        | 浇水控制                  |
| GET  | `/api/plant/health`       | 健康检查                  |

## API 返回示例

### GET /api/plant/status

```json
{
  "light": 8500,
  "light_status": "光照充足",
  "temperature": 25.0,
  "temp_status": "温度适宜",
  "humidity": 60.0,
  "hum_status": "湿度适宜",
  "soil_moisture": 74,
  "soil_raw": 67,
  "plant_status": "healthy",
  "health_score": 92,
  "advice": "✅ 植物状态良好。土壤湿度: 74%，光照: 8500 lux，温度: 25.0°C，湿度: 60.0%",
  "image_status": "healthy",
  "image_confidence": 1.00,
  "timestamp": "2026-05-01 15:45:21"
}
```

## 规则引擎 - 健康评分权重

| 因子     | 权重 | 理想范围         |
| -------- | ---- | ---------------- |
| 土壤湿度 | 40%  | 40% - 70%        |
| 光照强度 | 25%  | 5000 - 30000 lux |
| 环境温度 | 15%  | 18°C - 28°C      |
| 空气湿度 | 10%  | 40% - 70%        |
| 图像识别 | 10%  | healthy          |

### 健康状态分级

| 评分   | 状态      | 颜色 |
| ------ | --------- | ---- |
| 90-100 | excellent | 深绿 |
| 75-89  | healthy   | 绿   |
| 60-74  | warning   | 黄绿 |
| 40-59  | critical  | 橙   |
| 0-39   | danger    | 红   |

## 测试命令

```bash
# 测试状态接口
curl http://localhost:8000/api/plant/status

# 测试拍照
curl -X POST http://localhost:8000/api/plant/capture

# 测试浇水
curl -X POST http://localhost:8000/api/plant/water

# 获取最新照片
curl http://localhost:8000/api/plant/latest-image -o test.jpg

# 健康检查
curl http://localhost:8000/api/plant/health
```

## 开机自启动（可选）

创建 systemd 服务：

```bash
sudo nano /etc/systemd/system/plant-care.service
```

```ini
[Unit]
Description=Smart Plant Care Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/home/user/smart-plant-care/src
ExecStart=/home/user/smart-plant-care/src/camera_server
Restart=always

[Install]
WantedBy=multi-user.target
```

启用服务：

```bash
sudo systemctl daemon-reload
sudo systemctl enable plant-care
sudo systemctl start plant-care
sudo systemctl status plant-care
```

## 常见问题

### 1. I2C 设备检测不到

```bash
sudo i2cdetect -y 2
```

检查接线和地址。

### 2. 摄像头拍照失败

```bash
# 测试摄像头
ffmpeg -f v4l2 -i /dev/video0 -frames 1 test.jpg -y
```

### 3. 水泵不工作

```bash
# 手动测试 GPIO
echo 449 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio449/direction
echo 1 > /sys/class/gpio/gpio449/value
```

## 备份与恢复

### 备份

```bash
cd /home/user
tar -czvf smart_plant_backup.tar.gz \
    smart-plant-care/src/camera_server.c \
    smart-plant-care/analyze.py \
    smart-plant-care/models/leaf_classifier.onnx \
    smart-plant-care/photos/
```

### 恢复

```bash
cd /home/user
tar -xzvf smart_plant_backup.tar.gz
```

## 依赖安装

### C 编译依赖

```bash
sudo apt install build-essential
```

### Python 依赖（图片分析）

```bash
pip3 install onnxruntime opencv-python numpy
```

## 版本历史

- v3.0 (2026-05-01) - 添加规则引擎，优化健康评分
- v2.0 (2026-04-30) - 添加摄像头拍照、图片分析
- v1.0 (2026-04-25) - 基础 I2C 传感器读取

## 作者

植物养护系统毕设项目

## 许可证

仅供学习研究使用

```
## 保存到飞腾派

cd /home/user/smart-plant-care
nano README.md
```

