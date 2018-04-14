import os
import torch
import torch.utils.data as data
import torch
import torchvision.transforms as transforms
import random
from PIL import Image, ImageOps
import numpy as np
import preprocess 

IMG_EXTENSIONS = [
    '.jpg', '.JPG', '.jpeg', '.JPEG',
    '.png', '.PNG', '.ppm', '.PPM', '.bmp', '.BMP',
]


def is_image_file(filename):
    return any(filename.endswith(extension) for extension in IMG_EXTENSIONS)


def default_loader(path):
    return Image.open(path).convert('L')


def disparity_loader(path):
    return Image.open(path)


class myImageFloder(data.Dataset):
    def __init__(self, left, right, left_disparity, training, loader=default_loader, dploader= disparity_loader):
 
        self.left = left
        self.right = right
        self.disp_L = left_disparity
        self.loader = loader
        self.dploader = dploader
        self.training = training

    def __getitem__(self, index):
        left   = self.left[index]
        right  = self.right[index]
        disp_L = self.disp_L[index]

        left_img  = self.loader(left)  # TODO: converting to grayscale may cause issues with first layer of the net. should verify.
        right_img = self.loader(right)
        dataL     = self.dploader(disp_L)

        w, h = left_img.size

        dataL = ((np.ascontiguousarray(dataL,dtype=np.float32)-2**15)/2**8)

        processed = preprocess.get_transform(augment=False)
        left_img  = processed(left_img)   # make this image a tensor
        right_img = processed(right_img)  # make this image a tensor

        return left_img, right_img, dataL

    def __len__(self):
        return len(self.left)
