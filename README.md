gentoo-overlay
==============

My personal overlay for Gentoo on WSL.

Mainly maintained packages
--------------------------

- Pytorch
- Tensorflow
- Some NVIDIA SDKs, such as `cudnn`, `nccl`, `cusparselt` and `tensorrt`.
- and relative packages (`torchvision`, `lightning`, ...)

Difference from offical overlay
-------------------------------

- `pytorch` and `tensorflow` are built with CUDA-12
- `pytorch` is built with NCCL and Magma support
- `tensorflow` is built with NCCL and TensorRT support
- In order to build tensorflow, `re2`, `grpcio`, `grpcio-tools`, `abseil-cpp`, `protobuf`, `protobuf-python` and `onnx` are built with C++17 here, whereas they are built with C++14 in offical overlay. See discussion in this [pull request](https://github.com/gentoo/gentoo/pull/32281).

Notations about Tensorflow
--------------------------

There is something strange with tensorflow-2.14 and tensorflow-2.15, see [#62002](https://github.com/tensorflow/tensorflow/issues/62002) and [#62075](https://github.com/tensorflow/tensorflow/issues/62075). This will not prevent tensorflow from running, and seems not to be significant. But tensorboard starts really slow with version 2.15.0 due to this error. So the current suggestion is to stick to version 2.13 (with keras 2) or update to version 2.16 (with keras 3).
