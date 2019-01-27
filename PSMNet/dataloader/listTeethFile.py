import torch.utils.data as data

from PIL import Image
import os
import os.path
import random
import math
import numpy as np

IMG_EXTENSIONS = [
    '.jpg', '.JPG', '.jpeg', '.JPEG',
    '.png', '.PNG', '.ppm', '.PPM', '.bmp', '.BMP',
]


# Loading data without changing it from the file system and create overall containing tensors
def is_image_file(filename):
    return any(filename.endswith(extension) for extension in IMG_EXTENSIONS)


def dataloader(filepath):
  left_fold = '/Left/'
  right_fold = '/Right/'
  disp = '/GT/'

  numOfImages = len(os.listdir(filepath + left_fold))  # TODO: verify that numOfImages get correct value
  image = [img for img in os.listdir(filepath+left_fold)]
  idxs = [x for x in range(0, numOfImages)]
  random.shuffle(idxs)
  trainNum = int(math.floor(0.9*numOfImages))
  train = [image[x] for x in idxs[:trainNum]]
  val = [image[x] for x in idxs[trainNum:]]

  left_train   = [filepath+left_fold+img for img in train]
  right_train  = [filepath+right_fold+img for img in train]
  disp_train_L = [filepath+disp+img for img in train]

  left_val   = [filepath+left_fold+img for img in val]
  right_val  = [filepath+right_fold+img for img in val]
  disp_val_L = [filepath+disp+img for img in val]

  return left_train, right_train, disp_train_L, left_val, right_val, disp_val_L
