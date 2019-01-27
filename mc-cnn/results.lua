#! /usr/bin/env luajit
require 'torch'
left = torch.FloatTensor(torch.FloatStorage('left.bin')):view(1, 60, 338, 370)
right = torch.FloatTensor(torch.FloatStorage('right.bin')):view(1, 60, 338, 370)
disp = torch.FloatTensor(torch.FloatStorage('disp.bin')):view(1, 1, 338, 370)
