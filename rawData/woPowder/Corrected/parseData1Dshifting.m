close all;
clear all;
clc;

%-------Load The Images------%
imagesStruct = dir('*.png');
gtStruct = dir('./GT/*.png');
numOfImages = 543;

rows = 338;
cols = 370;

mkdir('extracted')
mkdir('extracted/training')
mkdir('extracted/testing')
mkdir('extracted/training/Left')
mkdir('extracted/training/Right')
mkdir('extracted/training/GT')
mkdir('extracted/testing/Left')
mkdir('extracted/testing/Right')
mkdir('extracted/testing/GT')

training_set_idx = randperm(numOfImages, floor(numOfImages*0.1));
num_of_testings =1;
num_of_training =1;

for i = 1:2:(2*numOfImages-1)
   leftIm    = imread(imagesStruct(i).name);
   rightIm   = imread(imagesStruct(i+1).name);
   gtIm      = imread(['./GT/' gtStruct(floor((i+1)/2)).name]);
   
   %have to make sure can be fully divided by 16:
   [row, col] = size(leftIm);
   rowChopFactor = mod(row,16);
   colChopFactor = mod(col,16);
   
   leftIm=leftIm(1:end-rowChopFactor, 1:colChopFactor);
   rightIm=rightIm(1:end-rowChopFactor, 1:colChopFactor);
   gtIm=gtIm(1:end-rowChopFactor, 1:colChopFactor);
   
%    figure()
%    subplot(2,2,1)
%    imshow(leftIm)
%    subplot(2,2,2)
%    imshow(gtIm,[])
%    subplot(2,1,2)
%    imshow(rightIm)
   
   cd('./extracted')
   if (sum(training_set_idx == floor((i+1)/2)))
       imwrite(gtIm, ['testing/GT/', num2str(num_of_testings),'.png']);
       imwrite(leftIm, ['testing/Left/', num2str(num_of_testings),'.png']);
       imwrite(rightIm,['testing/Right/',num2str(num_of_testings),'.png']);
       
       num_of_testings = num_of_testings+1;
   else
       imwrite(gtIm, ['training/GT/',   num2str(num_of_training),'.png']);
       imwrite(leftIm,   ['training/Left/', num2str(num_of_training),'.png']);
       imwrite(rightIm,  ['training/Right/',num2str(num_of_training),'.png']);

       num_of_training = num_of_training+1;
   end
   cd ('..')
end