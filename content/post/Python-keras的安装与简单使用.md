---
title: "Python Keras的安装与简单使用"
date: 2023-08-30T16:50:39+08:00
lastmod: 2023-08-30T16:50:39+08:00
keywords: ["Python", "keras"]
tags: ["Python", "keras"]
categories: ["Python", "keras"]

comment: true
toc: true
autoCollapseToc: true
reward: true
mathjax: false

---

<!--more-->

## Python Keras安装

keras 基于tensorflow框架之上，关于arm架构下tensorflow安装见[链接](https://ksnowlv.github.io/post/macos-arm64芯片下如何安装tensorflow)

### 1.问题
如果遇见引用tenssorflow时，遇见**have 'arm64', need 'x86_64'**错误，在arm架构设备上，直接安装arm版本的tensorflow，但是，因为tenssorflow的新版本还不支持arm架构，需要使用miniforge虚拟支持。


```shell
ImportError: dlopen(/Users/lvwei/Documents/python_projects/hellokeras/venv/lib/python3.11/site-packages/tensorflow/python/platform/_pywrap_cpu_feature_guard.so, 0x0002): tried: '/Users/lvwei/Documents/python_projects/hellokeras/venv/lib/python3.11/site-packages/tensorflow/python/platform/_pywrap_cpu_feature_guard.so' (mach-o file, but is an incompatible architecture (have 'arm64', need 'x86_64')), '/System/Volumes/Preboot/Cryptexes/OS/Users/lvwei/Documents/python_projects/hellokeras/venv/lib/python3.11/site-packages/tensorflow/python/platform/_pywrap_cpu_feature_guard.so' (no such file), '/Users/lvwei/Documents/python_projects/hellokeras/venv/lib/python3.11/site-packages/tensorflow/python/platform/_pywrap_cpu_feature_guard.so' (mach-o file, but is an incompatible architecture (have 'arm64', need 'x86_64'))

```

### 2.Keras的使用示例

#### 深度学习算法的训练过程

* 1.加载数据集
* 2.数据预处理
* 3.构建神经网络模型
* 4.编译模型
* 5.训练模型
* 6.评估模型

#### 深度学习算法示例
以TensorFlow的Keras API构建了一个简单的神经网络模型模块为例，在 MNIST手写数字数据集上进行了训练和评估。


```python
import tensorflow as tf
from tensorflow import keras

def main():
    print("TensorFlow version:", tf.__version__)
    #print("Keras version:", keras.__version__)

    # 1.加载数据集：
    #  构建了一个简单的神经网络模型，加载内置的 MNIST 手写数字数据集，并在 MNIST 手写数字数据集上进行了训练和评估
    mnist = keras.datasets.mnist
    # 将数据集分为训练集和测试集，并分别存储为 train_images、train_labels、test_images 和 test_labels。
    (train_images, train_labels), (test_images, test_labels) = mnist.load_data()

    # 2.数据预处理
    # 通过将像素值除以 255 来缩放图片的像素值，将像素值转换为范围在 0 到 1 之间，以便更好地适应神经网络模型。
    train_images = train_images / 255.0
    test_images = test_images / 255.0

    # 3.构建神经网络模型
    # 这个模型使用了一个扁平化层 Flatten和两个全连接层 Dense 。
    # 扁平化层将输入的二维图像数据（28x28）转换为一维数组，然后经过两个全连接层进行特征提取和分类。最后一层使用 softmax 激活函数进行多类别分类。
    model = keras.Sequential([
        keras.layers.Flatten(input_shape=(28, 28)),
        keras.layers.Dense(128, activation='relu'),
        keras.layers.Dense(10, activation='softmax')
    ])

    # 4.编译模型：
    # 在编译模型时，选择了优化器为adam，损失函数为稀疏分类交叉熵（适用于整数标签），评估指标为准确率
    model.compile(optimizer='adam',
                  loss='sparse_categorical_crossentropy',
                  metrics=['accuracy'])

    # 5.训练模型
    # 通过调用 fit 方法，在训练集上对模型进行拟合。这里选择了 5 个训练周期（epochs）进行训练
    model.fit(train_images, train_labels, epochs=5)

    # 6.评估模型
    # 在测试集上评估模型性能:使用 evaluate 方法，在测试集上评估模型的性能，并打印出测试集上的准确率。
    test_loss, test_acc = model.evaluate(test_images, test_labels)
    print('Test accuracy:', test_acc)



# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    main()
```


### 3.Keras的示例效果


```python

TensorFlow version: 2.13.0
Downloading data from https://storage.googleapis.com/tensorflow/tf-keras-datasets/mnist.npz
11490434/11490434 [==============================] - 34s 3us/step
2023-09-01 17:37:39.464157: I metal_plugin/src/device/metal_device.cc:1154] Metal device set to: Apple M1 Pro
2023-09-01 17:37:39.464178: I metal_plugin/src/device/metal_device.cc:296] systemMemory: 16.00 GB
2023-09-01 17:37:39.464184: I metal_plugin/src/device/metal_device.cc:313] maxCacheSize: 5.33 GB
2023-09-01 17:37:39.464579: I tensorflow/core/common_runtime/pluggable_device/pluggable_device_factory.cc:303] Could not identify NUMA node of platform GPU ID 0, defaulting to 0. Your kernel may not have been built with NUMA support.
2023-09-01 17:37:39.464896: I tensorflow/core/common_runtime/pluggable_device/pluggable_device_factory.cc:269] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 0 MB memory) -> physical PluggableDevice (device: 0, name: METAL, pci bus id: <undefined>)
Epoch 1/5
2023-09-01 17:37:40.176850: I tensorflow/core/grappler/optimizers/custom_graph_optimizer_registry.cc:114] Plugin optimizer for device_type GPU is enabled.
2023-09-01 17:37:40.196613: E tensorflow/core/grappler/optimizers/meta_optimizer.cc:954] model_pruner failed: INVALID_ARGUMENT: Graph does not contain terminal node Adam/AssignAddVariableOp.
1875/1875 [==============================] - 9s 4ms/step - loss: 0.3651 - accuracy: 0.8974
Epoch 2/5
1875/1875 [==============================] - 9s 5ms/step - loss: 0.3105 - accuracy: 0.9146
Epoch 3/5
1875/1875 [==============================] - 9s 5ms/step - loss: 0.3171 - accuracy: 0.9139
Epoch 4/5
1875/1875 [==============================] - 8s 4ms/step - loss: 0.3261 - accuracy: 0.9106
Epoch 5/5
1875/1875 [==============================] - 8s 4ms/step - loss: 0.3355 - accuracy: 0.9091
2023-09-01 17:38:22.615540: I tensorflow/core/grappler/optimizers/custom_graph_optimizer_registry.cc:114] Plugin optimizer for device_type GPU is enabled.
313/313 [==============================] - 1s 4ms/step - loss: 0.3513 - accuracy: 0.9079
Test accuracy: 0.9078999757766724


```


