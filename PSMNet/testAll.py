from __future__ import print_function
import os
import torch
import torch.nn as nn
from dataloader import teethLoader as DA
import skimage
import skimage.io
import skimage.transform
import skimage.exposure
from torch.autograd import Variable
from models import *

modelPath  = '/media/ahiadlevi/Elements/stereoTeethML/PSMNet/pretrainedModel/checkpoint_1000.tar'
leftDir    = '/media/ahiadlevi/Elements/stereoTeethML/PSMNet/data/testing/Left/'
rightDir   = '/media/ahiadlevi/Elements/stereoTeethML/PSMNet/data/testing/Right/'
gtDir      = '/media/ahiadlevi/Elements/stereoTeethML/PSMNet/data/testing/GT/'
resultsDir = '/media/ahiadlevi/Elements/stereoTeethML/PSMNet/results/'


class forwardTest():
     def __init__(self, modelPath, leftDir, rightDir, gtDir, resultsDir, maxDisp):
          self.modelPath = modelPath
          self.leftDir = leftDir
          self.rightDir = rightDir
          self.gtDir = gtDir
          self.resultsDir = resultsDir

          self.numIm = len(os.listdir(leftDir))

          self.leftList = [self.leftDir+img for img in os.listdir(leftDir)]
          self.rightList = [self.rightDir+img for img in os.listdir(rightDir)]
          self.gtList = [self.gtDir+img for img in os.listdir(gtDir)]

          self.testImgLoader = torch.utils.data.DataLoader(
               DA.myImageFloder(self.leftList, self.rightList, self.gtList, True),
               batch_size=1, shuffle=True, num_workers=8, drop_last=False)

          self.model = stackhourglass(maxDisp)
          state_dict = torch.load(modelPath)
          self.model.load_state_dict(state_dict['state_dict'])
          self.model = nn.DataParallel(self.model, device_ids=[0])
          self.model.cuda()

          print('Number of model parameters: {}'.format(sum([p.data.nelement() for p in self.model.parameters()])))

     def test(self):
          self.model.eval()
          i=1
          for batchIdx, (imgL, imgR, disp_GT) in enumerate(self.testImgLoader):
               imgL = torch.FloatTensor(imgL).cuda()
               imgR = torch.FloatTensor(imgR).cuda()

               imgL, imgR = Variable(imgL, volatile=True), Variable(imgR, volatile=True)

               output = self.model(imgL, imgR)
               output = torch.squeeze(output)

               pred_disp = output.data.cpu().numpy()
               print(['done Calculating image number' + i])
               save_scale = (pred_disp * 256) + (2**15)
               skimage.io.imsave(self.resultsDir + i +"_calc.png", save_scale.astype('uint16'))
               i = i+1


def main():
    runModel = forwardTest(modelPath, leftDir, rightDir, gtDir, resultsDir, 60)
    runModel.test()

if __name__ == '__main__':
    main()