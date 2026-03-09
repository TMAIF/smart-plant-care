#!/usr/bin/env python3
import torch
import torchvision.models as models
import sys

print("="*50)
print("智能盆栽系统 - PyTorch 测试")
print("="*50)

# 检查 PyTorch 版本
print(f"PyTorch 版本: {torch.__version__}")
print(f"Python 版本: {sys.version}")

# 尝试加载模型
try:
    print("\n正在加载 DenseNet121 模型...")
    model = models.densenet121(weights=None)
    model.load_state_dict(torch.load('models/densenet121.pth', map_location='cpu'))
    print("✅ 模型加载成功！")
    print(f"模型类型: DenseNet121")
    print(f"分类层输出: {model.classifier.out_features} 类")
except Exception as e:
    print(f"❌ 模型加载失败: {e}")

print("="*50)
