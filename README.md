gentoo-overlay
==============

My personal overlay for Gentoo on WSL.

Mainly maintained packages
--------------------------

- Pytorch
- Tensorflow
- Some NVIDIA SDKs, such as `cudnn`, `nccl`, `cusparselt` and `tensorrt`.
- and relative packages (`torchvision`, `pytorch-lightning`, ...)

Difference from offical overlay
-------------------------------

- `pytorch` and `tensorflow` are build with CUDA-12
- `pytorch` with NCCL and Magma support
- `tensorflow` with NCCL and TensorRT support
- In order to build tensorflow, `re2`, `grpcio`, `grpcio-tools`, `abseil-cpp`, `protobuf`, `protobuf-python` and `onnx` are built with C++17 here, whereas they are built with C++14 in offical overlay. See discussion in this [pull request](https://github.com/gentoo/gentoo/pull/32281).

