# 🌱 智能盆栽养护系统

## 📋 项目信息

| 项目 | 说明 |
|------|------|
| 项目名称 | 融合视觉与传感器的智能盆栽养护系统 |
| 作者 | 赵尧瑶 |
| 班级 | 网工2201 |
| 学号 | 2022011246 |
| 指导教师 | 焦健 |

## 🐳 Docker 镜像信息

| 属性 | 说明 |
|------|------|
| 镜像名称 | `smart-plant:v1.0-20250309` |
| 基础镜像 | `arm64v8/python:3.9-slim` |
| 大小 | 1.18 GB |
| 架构 | ARM64 (适配飞腾派) |
| Python版本 | 3.9 |

## 📦 已安装的依赖

| 包名 | 版本 | 用途 |
|------|------|------|
| torch | 2.4.1 | 深度学习框架 |
| torchvision | 0.19.1 | 图像处理模型 |
| numpy | 1.24.3 | 科学计算 |
| Pillow | 9.5.0 | 图像处理 |
| Flask | 3.1.3 | Web服务框架 |
| smbus2 | 0.4.3 | I2C总线通信 |

## 📁 项目结构
.
├── data/ # 数据存储目录（挂载点）
├── models/ # 模型文件目录
│ └── densenet121.pth # DenseNet121 预训练模型
├── src/ # 源代码目录
│ ├── app.py # 主应用入口
│ ├── test_hardware.py # 硬件测试脚本
│ └── test_torch.py # PyTorch测试脚本
├── scripts/ # 工具脚本（可空）
├── Dockerfile # Docker构建文件
├── requirements.txt # Python依赖列表
└── README.md # 本文档

## 🚀 快速开始

### 1. 构建镜像（如果还没有）
```bash
docker build -t smart-plant:v1.0-20250309 .
```

### 2.运行测试

```
# 测试依赖安装

docker run --rm smart-plant:v1.0-20250309

# 测试 PyTorch 和模型

docker run --rm smart-plant:v1.0-20250309 python src/test_torch.py
```

### 3、挂载硬件运行（飞腾派）

```
# 访问 I2C、摄像头、GPIO 等硬件

docker run -it --rm \
  --privileged \
  -v /dev:/dev \
  -v $(pwd)/data:/app/data \
  -v $(pwd)/src:/app/src \
  smart-plant:v1.0-20250309 \
  /bin/bash
```

### 4、硬件检测

```
# 在容器内运行硬件检测脚本

python src/test_hardware.py
```

## 🔧 **开发指南**

### 添加新功能

```
在 src/ 目录下创建新的 Python 模块

修改 app.py 集成新功能

测试通过后更新镜像
```

### 实时开发（挂载源码）

```
# 修改代码后无需重新构建镜像

docker run -it --rm \
  -v $(pwd)/src:/app/src \
  smart-plant:v1.0-20250309 \
  /bin/bash
```

### 数据持久化

```
# 数据会保存在本地的 data/ 目录

docker run -d \
  --name smart-plant \
  -v $(pwd)/data:/app/data \
  smart-plant:v1.0-20250309
```



## ✅ **功能验证**

```
验证所有依赖

docker run --rm smart-plant:v1.0-20250309
预期输出：

智能盆栽系统 - 依赖测试
==================================================

PyTorch版本: 2.4.1
TorchVision版本: 0.19.1
NumPy版本: 1.24.3
Pillow版本: 9.5.0

Flask版本: 3.1.3
==================================================

✅ 所有依赖安装成功！
```

### 
验证模型加载

```
docker run --rm smart-plant:v1.0-20250309 python src/test_torch.py
```

## 📝 版本历史

| 版本名                  | 版本     | 用途                              |
| ----------------------- | -------- | --------------------------------- |
| v1.0-202503092025-03-09 | 初始版本 | 包含所有基础依赖和DenseNet121模型 |
|                         |          |                                   |

## 
🐛 常见问题

```
Q: 如何修改代码后立即生效？
A: 运行容器时挂载本地 src 目录：

-v $(pwd)/src:/app/src
```

```
Q: 如何保存容器内生成的数据？
A: 挂载本地 data 目录到容器：

-v $(pwd)/data:/app/data
```

```
Q: 硬件设备无法访问怎么办？
A: 确保使用 --privileged 参数并挂载 /dev 目录：

--privileged -v /dev:/dev
```

```
Q: 镜像太大如何备份？
A: 使用以下命令保存和加载：

# 保存
docker save smart-plant:v1.0-20250309 -o smart-plant.tar
gzip smart-plant.tar

# 加载
gunzip smart-plant.tar.gz
docker load -i smart-plant.tar
```



## 📞 联系方式

作者：赵尧瑶

指导教师：焦健

最后更新: 2025年3月9日













项目说明文档 | 包含：<br>• 项目基本信息<br>• 目录结构<br>• 安装和使用说明<br>• 功能验证方法<br>• 常见问题解答 |

### 📁 models/ 目录

| 文件                | 类型     | 大小  | 作用                  | 详细说明                                                     |
| ------------------- | -------- | ----- | --------------------- | ------------------------------------------------------------ |
| **densenet121.pth** | 模型文件 | ~31MB | DenseNet121预训练模型 | • PyTorch格式的模型权重文件<br>• 在ImageNet上预训练，可识别1000类物体<br>• 用于植物叶片图像的 feature extraction<br>• 后续可微调用于缺水/缺光分类 |

### 📁 src/ 目录（源代码）

| 文件                 | 类型       | 大小 | 作用            | 详细说明                                                     |
| -------------------- | ---------- | ---- | --------------- | ------------------------------------------------------------ |
| **app.py**           | Python脚本 | ~3KB | 主应用入口      | 当前是简化版本，后续会扩展为：<br>• Flask Web服务<br>• 传感器数据读取<br>• 图像采集和分析<br>• 自动控制逻辑<br>• API接口供小程序调用 |
| **test_hardware.py** | Python脚本 | ~2KB | 硬件测试脚本    | 检测飞腾派上的硬件设备：<br>• **I2C总线**：检查 `/dev/i2c-1` 是否存在，测试smbus2库<br>• **摄像头**：检查 `/dev/video0` 是否存在<br>• **GPIO**：检查 `/dev/gpiochip0` 是否存在<br>• 输出检测结果，帮助调试硬件连接 |
| **test_torch.py**    | Python脚本 | ~1KB | PyTorch测试脚本 | 验证深度学习环境：<br>• 检查PyTorch版本<br>• 加载DenseNet121模型<br>• 测试模型能否正常推理<br>• 输出模型信息 |

### 📁 data/ 目录

| 目录      | 作用         | 说明                                                         |
| --------- | ------------ | ------------------------------------------------------------ |
| **data/** | 数据存储目录 | 运行时生成的数据会保存在这里：<br>• 传感器历史数据<br>• 拍摄的植物照片<br>• 系统日志文件<br>• 数据库文件（SQLite）<br>• 当前为空，运行时自动创建 |

### 📁 scripts/ 目录

| 目录         | 作用         | 说明                                                         |
| ------------ | ------------ | ------------------------------------------------------------ |
| **scripts/** | 工具脚本目录 | 用于存放辅助脚本：<br>• 数据备份脚本<br>• 模型训练脚本<br>• 系统维护脚本<br>• **当前为空**，可按需添加 |

## 🔄 文件之间的关系

Dockerfile
├── 使用 requirements.txt 安装Python包
├── 复制 models/densenet121.pth 到镜像
└── 复制 src/ 目录下所有代码到镜像

src/app.py
├── 可能调用 test_hardware.py 检测硬件
├── 可能调用 test_torch.py 验证模型
└── 数据保存到 data/ 目录

运行时：
Docker容器
├── 读取 models/densenet121.pth (只读)
├── 执行 src/ 下的代码
└── 写入数据到 data/ 目录 (持久化)

## 🎯 每个文件的用途总结

| 文件                     | 当前用途     | 未来扩展             |
| ------------------------ | ------------ | -------------------- |
| `Dockerfile`             | 构建基础镜像 | 添加更多系统依赖     |
| `requirements.txt`       | 记录依赖     | 添加新功能所需的包   |
| `models/densenet121.pth` | 预训练模型   | 微调后的植物分类模型 |
| `src/app.py`             | 简单测试     | 完整的主程序         |
| `src/test_hardware.py`   | 硬件检测     | 传感器驱动库         |
| `src/test_torch.py`      | 环境验证     | 图像识别模块         |
| `data/`                  | 空目录       | 存储历史数据         |
| `scripts/`               | 空目录       | 维护脚本             |
| `README.md`              | 文档         | 更新使用说明         |

## 📝 如何扩展每个文件

1. **app.py 后续要添加的功能**

- Flask Web服务器
- 传感器定时读取
- 图像采集和分析
- 自动浇水控制
- REST API接口

2. **test_hardware.py 可扩展为**

- 具体的传感器驱动类
- I2C设备扫描工具
- 摄像头拍照功能
- GPIO控制函数

3. **test_torch.py 可扩展为**

- 植物叶片分类器
- 模型微调代码
- 图像预处理函数
- 推理结果分析

