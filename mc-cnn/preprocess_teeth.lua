#!/usr/bin/env luajit

require 'image'
require 'nn'
require 'cutorch'
require 'libadcensus'

for _, dataset in ipairs({2015}) do
    print(('dataset %d'):format(dataset))
    torch.manualSeed(42)
    n_tr =  489--Number of training sets
    n_te =  54--Number of testing sets
    path = 'data.teeth'
    image_0 = 'Left' --validate that image_2 is the left image
    image_1 = 'Right' --same here
    nchannel = 1
    disp_noc = 'GT' --what is that for??

--[==[
   elseif dataset == 2015 then
      n_tr = 200
      n_te = 200
      path = 'data.kitti2015'
      image_0 = 'image_2'
      image_1 = 'image_3'
      nchannel = 3
      disp_noc = 'disp_noc_0'
   end
]==]

   height = 338
   width = 370
   --print(x0)
   --create tensors for left image and right image and disparity of the test set.
   x0 = torch.FloatTensor(n_tr + n_te, 1, height, width):zero()
   --print(x0)
   x1 = torch.FloatTensor(n_tr + n_te, 1, height, width):zero()
   dispnoc = torch.FloatTensor(n_tr, 1, height, width):zero()
   --images charachteristics
   metadata = torch.IntTensor(n_tr + n_te, 3):zero()

   --create indexes vector sorted as: examples = [trainingIdx, testingIdx]
   examples = {}
   for i = 1,n_tr do
      examples[#examples + 1] = {dir='training', cnt=i}
   end

   for i = 1,n_te do
      examples[#examples + 1] = {dir='testing', cnt=i}
   end

   for i, arg in ipairs(examples) do
      -- Load the Images
      img_path = '%s/%s/%s/%s.png'
      img_0 = image.loadPNG(img_path:format(path, arg['dir'], image_0, arg['cnt']), nchannel, 'byte'):float()
      img_1 = image.loadPNG(img_path:format(path, arg['dir'], image_1, arg['cnt']), nchannel, 'byte'):float()

      --extract Image channel Y (out of YUV)
      --NOTE: Images are already on Grayscale. is there a change when converting to Y?
      --img_0 = image.rgb2y(img_0)
      --img_1 = image.rgb2y(img_1)

      -- crop
      img_height = img_0:size(2)
      img_width  = img_0:size(3)

      img_0 = img_0:narrow(2, img_height - height + 1, height)
      img_1 = img_1:narrow(2, img_height - height + 1, height)

      -- preprocess
      img_0:add(-img_0:mean()):div(img_0:std())
      img_1:add(-img_1:mean()):div(img_1:std())

      x0[{i,{},{},{1,img_width}}]:copy(img_0)
      x1[{i,{},{},{1,img_width}}]:copy(img_1)
--      print(i)
      if arg['dir'] == 'training' then
         img_disp = torch.FloatTensor(1, img_height, img_width)
         adcensus.readPNG16(img_disp, ('%s/training/%s/%s.png'):format(path, disp_noc, arg['cnt']))
         img_disp = img_disp:add(-128)
         --[==[for j=1, width do
             for k=1, height do
                 --print (img_disp[{1,k,j}], k, j)
                 if img_disp[{1,k,j}]<0 then
                    img_disp[{1,k,j}] = img_disp[{1,k,j}]+380
                 end
                -- print (img_disp[{1,k,j}], k, j)
             end
         end]==]
         print(img_disp)
         while 1 do
         end
         dispnoc[{i, 1}]:narrow(2, 1, img_width):copy(img_disp:narrow(2, img_height - height + 1, height))
      end
      --print('pass loading GT')
      metadata[{i, 1}] = img_height
      metadata[{i, 2}] = img_width
      metadata[{i, 3}] = arg['cnt'] - 1
      --print('pass updating metadata')
      collectgarbage()
   end
   print('Done Loading Data')
   -- split train and test
   perm = torch.randperm(n_tr):long()
   te = perm[{{1,48}}]:clone()
   tr = perm[{{49,n_tr}}]:clone()
   print('starting GT preprocessing')
   -- prepare tr dataset
   nnz_tr = torch.FloatTensor(28e6, 4) --what this number for?
   nnz_te = torch.FloatTensor(28e6, 4)
   nnz_tr_t = 0
   nnz_te_t = 0
   for i = 1,n_tr do
      local disp = dispnoc[{{i}}]:cuda()
      adcensus.remove_nonvisible(disp)
      adcensus.remove_occluded(disp)
      adcensus.remove_white(x0[{{i}}]:cuda(), disp)
      disp = disp:float()

      is_te = false
      for j = 1,te:nElement() do
         if i == te[j] then
            is_te = true
         end
      end

      if is_te then
         nnz_te_t = adcensus.make_dataset2(disp, nnz_te, i, nnz_te_t)
      else
         nnz_tr_t = adcensus.make_dataset2(disp, nnz_tr, i, nnz_tr_t)
      end
   end
   print(nnz_tr_t)
   nnz_tr = torch.FloatTensor(nnz_tr_t, 4):copy(nnz_tr[{{1,nnz_tr_t}}])
   nnz_te = torch.FloatTensor(nnz_te_t, 4):copy(nnz_te[{{1,nnz_te_t}}])

--[==[   function tofile(fname, x)
      tfile = torch.DiskFile(fname .. '.type', 'w')
      if x:type() == 'torch.FloatTensor' then
         tfile:writeString('float32')
         torch.DiskFile(fname, 'w'):binary():writeFloat(x:storage())
      elseif x:type() == 'torch.LongTensor' then
         tfile:writeString('int64')
         torch.DiskFile(fname, 'w'):binary():writeLong(x:storage())
      elseif x:type() == 'torch.IntTensor' then
         tfile:writeString('int32')
         torch.DiskFile(fname, 'w'):binary():writeInt(x:storage())
      end
      dimfile = torch.DiskFile(fname .. '.dim', 'w')
      for i = 1,x:dim() do
         dimfile:writeString(('%d\n'):format(x:size(i)))
      end
   end
   os.execute(('rm -f %s/*.{bin,dim,type}'):format(path))
   print('Done Preprocessing')
   tofile(('%s/x0.bin'):format(path), x0)
   tofile(('%s/x1.bin'):format(path), x1)
   tofile(('%s/dispnoc.bin'):format(path), dispnoc)
   tofile(('%s/metadata.bin'):format(path), metadata)
   tofile(('%s/tr.bin'):format(path), tr)
   tofile(('%s/te.bin'):format(path), te)
   tofile(('%s/nnz_tr.bin'):format(path), nnz_tr)
   tofile(('%s/nnz_te.bin'):format(path), nnz_te)]==]
function tofile(fname, x)
   tfile = torch.DiskFile(fname .. '.type', 'w')
   if x:type() == 'torch.FloatTensor' then                       
      print('saving float 32')
      tfile:writeString('float32')
      torch.DiskFile(fname, 'w'):binary():writeFloat(x:storage())
   elseif x:type() == 'torch.LongTensor' then
      print('saving int64')
      tfile:writeString('int64')
      torch.DiskFile(fname, 'w'):binary():writeLong(x:storage())
   elseif x:type() == 'torch.IntTensor' then
      print('saving int32')
      tfile:writeString('int32')
      torch.DiskFile(fname, 'w'):binary():writeInt(x:storage())
   end
   dimfile = torch.DiskFile(fname .. '.dim', 'w')
   for i = 1,x:dim() do
      dimfile:writeString(('%d\n'):format(x:size(i)))
   end
end
                                                                  
os.execute(('rm -f %s/*.{bin,dim,type}'):format(path))
print('saving x0')
tofile(('%s/x0.bin'):format(path), x0)
print('saving x1')
tofile(('%s/x1.bin'):format(path), x1)
print('saving dispnoc')
tofile(('%s/dispnoc.bin'):format(path), dispnoc)
print('saving metadata')
tofile(('%s/metadata.bin'):format(path), metadata)
print('saving tr')
tofile(('%s/tr.bin'):format(path), tr)
print('saving te')
tofile(('%s/te.bin'):format(path), te)
print('saving nnz_tr')
tofile(('%s/nnz_tr.bin'):format(path), nnz_tr)
print('saving nnz_te')
tofile(('%s/nnz_te.bin'):format(path), nnz_te)

end
