import torch
import torch.utils
import torch.utils.cpp_extension

print("torch_version: ", torch.__version__)

print("torch_version_cuda: ", torch.version.cuda)
print("torch_cuda_available: ", torch.cuda.is_available())