#! /usr/bin/env luajit
require 'cutorch'
require 'image'

d =121 
h =338 
w= 370

dReal = (d-1)/2

function fromfile(fname)
   local size = io.open(fname):seek('end')
   local x = torch.FloatTensor(torch.FloatStorage(fname, false, size / 4))
   local nan_mask = x:ne(x)
   x[nan_mask] = 1e38
   return x
end


print('Writing left.png')
left = fromfile('left.bin'):view(1, d, h, w)
_, left_ = left:min(2)
for i=1,w do
    for j=1, h do
        if left_[{1,1,j,i}]>0 then
          left_[{1,1,j,i}] = left_[{1,1,j,i}]-1
        end
        if left_[{1,1,j,i}]>= dReal+1 then
            left_[{1,1,j,i}]= (dReal+1)-left_[{1,1,j,i}]
        end
    end
end
print(left_)
image.save('left.png', left_[1]:float():div(dReal))

print('Writing right.png')
right = fromfile('right.bin'):view(1, d, h, w)
_, right_ = right:min(2)
image.save('right.png', right_[1]:float():div(dReal))

print('Writing disp.png')
disp = fromfile('disp.bin'):view(1, 1, h, w)
image.save('disp.png', disp[1]:div(dReal))
