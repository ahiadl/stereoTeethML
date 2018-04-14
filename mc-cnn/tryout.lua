#! /usr/bin/env luajit
require 'image'
require 'nn'
require 'cutorch'
require 'libadcensus'

n_tr = 80 --Number of training sets
n_te = 13 --Number of testing sets
path = 'data.teeth'
image_0 = 'Left' --validate that image_2 is the left image
image_1 = 'Right' --same here
nchannel = 1
disp_noc = 'GT' --what is that for??

height = 338
width = 370

testVar = torch.FloatTensor(93, 1, 338, 370):zero()
print(testVar)