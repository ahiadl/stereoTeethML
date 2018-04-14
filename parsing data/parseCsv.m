close all;
clear all;
clc;

% -------------------------------
% Parsing The CSV files to Images
%--------------------------------

mkdir ./Temp/GT
cd ./Temp/GT_csv
imagesStruct = dir('*.csv');
numOfImages = numel(imagesStruct);
prefix = 'GT_';
suffix = '.csv';
bias = 128;

% for i = 0:numOfImages-1
%     origGT = csvread([prefix num2str(i) suffix]);
%     idx = pad(num2str(i),5,'left','0');
%     curGT = uint16((origGT/16 + bias)*256);
%     imwrite(curGT, ['../GT/GT_',idx,'.png']);
% end
cd ..

origPath = pwd;
imagesDir = '../../rawData/woPowder/Corrected/';
cd (imagesDir)

imagesStruct = dir('*.png');
cd (origPath)
gtStruct = dir('./GT/*.png');
numOfImages = 543; %to change to size(gtTruct,1)

mkdir('./training')
mkdir('./testing')
mkdir('./training/Left')
mkdir('./training/Right')
mkdir('./training/GT')
mkdir('./testing/Left')
mkdir('./testing/Right')
mkdir('./testing/GT')

training_set_idx = randperm(numOfImages, floor(numOfImages*0.1));
num_of_testings =1;
num_of_training =1;

% for i = 1:2:(2*numOfImages-1)
%    leftIm    = imread([imagesDir imagesStruct(i).name]);
%    rightIm   = imread([imagesDir imagesStruct(i+1).name]);
%    gtIm      = imread(['./GT/' gtStruct(floor((i+1)/2)).name]);
%    
%    % have to make sure can be fully divided by 16:
%    [row, col] = size(leftIm);
%    rowChopFactor = mod(row,16);
%    colChopFactor = mod(col,16);
%    
%    leftIm=leftIm(1:end-rowChopFactor, 1:(end-colChopFactor));
%    rightIm=rightIm(1:end-rowChopFactor, 1:(end-colChopFactor));
%    gtIm=gtIm(1:end-rowChopFactor, 1:(end-colChopFactor));
%    
% %    figure()
% %    subplot(2,2,1)
% %    imshow(leftIm)
% %    subplot(2,2,2)
% %    imshow(gtIm,[])
% %    subplot(2,1,2)
% %    imshow(rightIm)
%    
%    if (sum(training_set_idx == floor((i+1)/2)))
%        imwrite(gtIm, ['testing/GT/', num2str(num_of_testings),'.png']);
%        imwrite(leftIm, ['testing/Left/', num2str(num_of_testings),'.png']);
%        imwrite(rightIm,['testing/Right/',num2str(num_of_testings),'.png']);
%        
%        num_of_testings = num_of_testings+1;
%    else
%        imwrite(gtIm, ['training/GT/',   num2str(num_of_training),'.png']);
%        imwrite(leftIm,   ['training/Left/', num2str(num_of_training),'.png']);
%        imwrite(rightIm,  ['training/Right/',num2str(num_of_training),'.png']);
% 
%        num_of_training = num_of_training+1;
%    end
% end

copyfile training ../../mc-cnn/data.teeth/training
copyfile testing ../../mc-cnn/data.teeth/testing

copyfile training ../../PSMNet/data/training
copyfile testing ../../PSMNet/data/testing



