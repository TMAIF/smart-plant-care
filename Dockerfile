# 使用本地已有的 ARM64 Python 镜像
FROM arm64v8/python:3.9-slim

WORKDIR /app

# 配置 pip 国内源
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 先升级 pip、setuptools 和 wheel
RUN pip install --no-cache-dir --upgrade pip setuptools==70.0.0 wheel

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    i2c-tools \
    && rm -rf /var/lib/apt/lists/*

# 分步安装 Python 包（先装 PyTorch）
RUN pip install --no-cache-dir \
    torch==2.4.1 \
    torchvision==0.19.1 \
    --index-url https://download.pytorch.org/whl/cpu

# 安装其他包（指定兼容版本）
RUN pip install --no-cache-dir \
    numpy==1.24.3 \
    Pillow==9.5.0 \
    smbus2 \
    Flask

# 复制项目文件
COPY models/ ./models/
COPY src/ ./src/

# 创建数据目录
RUN mkdir -p /app/data

# 创建测试脚本
RUN echo 'import torch' > /app/test.py && \
    echo 'import torchvision' >> /app/test.py && \
    echo 'import numpy' >> /app/test.py && \
    echo 'import PIL' >> /app/test.py && \
    echo 'import flask' >> /app/test.py && \
    echo 'print("="*50)' >> /app/test.py && \
    echo 'print("智能盆栽系统 - 依赖测试")' >> /app/test.py && \
    echo 'print("="*50)' >> /app/test.py && \
    echo 'print(f"PyTorch版本: {torch.__version__}")' >> /app/test.py && \
    echo 'print(f"TorchVision版本: {torchvision.__version__}")' >> /app/test.py && \
    echo 'print(f"NumPy版本: {numpy.__version__}")' >> /app/test.py && \
    echo 'print(f"Pillow版本: {PIL.__version__}")' >> /app/test.py && \
    echo 'print(f"Flask版本: {flask.__version__}")' >> /app/test.py && \
    echo 'print("="*50)' >> /app/test.py && \
    echo 'print("✅ 所有依赖安装成功！")' >> /app/test.py

CMD ["python", "/app/test.py"]
