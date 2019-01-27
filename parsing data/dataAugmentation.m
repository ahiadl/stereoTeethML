close all;
clear all;
clc;

mkdir 'augmentedData'
mkdir './augmentedData/Left'
mkdir './augmentedData/Right'
mkdir './augmentedData/GT'

for i = 1:54

    left  = imread(['./Temp/testing/Left/',num2str(i),'.png']);
    right = imread(['./Temp/testing/Right/',num2str(i),'.png']);
    rawGT    = imread(['./Temp/testing/GT/',num2str(i),'.png']);
    GT    = ((double(rawGT)-2^15)/2^16)*2^8;
   
   
%    Original
    origLeft  = left;
    origRight = right;
    rawOrigGT = GT;

%    Vert
    vertLeft  = flip(left,1);
    vertRight = flip(right,1);
    rawVertGT = flip(GT,1);

%    Horiz
    horizRight = flip(left,2);
    horizLeft  = flip(right,2);
    rawHorizGT = flip(GT,2)*(1);

%    Vert+ Horiz
    vertHorizLeft  = flip(horizLeft,1);
    vertHorizRight = flip(horizRight,1);
    rawVertHorizGT = flip(rawHorizGT,1);

%     Convert GT Values:
    origGT      = ((rawOrigGT/2^8)*2^16)+2^15;
    vertGT      = ((rawVertGT/2^8)*2^16)+2^15;
    horizGT     = ((rawHorizGT/2^8)*2^16)+2^15;
    vertHorizGT = ((rawVertHorizGT/2^8)*2^16)+2^15;
    
%     Save
%     Orig
    imwrite(origLeft, ['augmentedData/Left/', num2str((i-1)*4+1),'.png']);
    imwrite(origRight,['augmentedData/Right/',num2str((i-1)*4+1),'.png']);
    imwrite(uint16(origGT), ['augmentedData/GT/', num2str((i-1)*4+1),'.png']);
    
%     Vert
    imwrite(vertLeft, ['augmentedData/Left/', num2str((i-1)*4+2),'.png']);
    imwrite(vertRight,['augmentedData/Right/',num2str((i-1)*4+2),'.png']);
    imwrite(uint16(vertGT), ['augmentedData/GT/', num2str((i-1)*4+2),'.png']);
    
%     Horiz
    imwrite(horizLeft, ['augmentedData/Left/', num2str((i-1)*4+3),'.png']);
    imwrite(horizRight,['augmentedData/Right/',num2str((i-1)*4+3),'.png']);
    imwrite(uint16(horizGT), ['augmentedData/GT/', num2str((i-1)*4+3),'.png']);

%     Horiz + Vert
    imwrite(vertHorizLeft, ['augmentedData/Left/', num2str((i-1)*4+4),'.png']);
    imwrite(vertHorizRight,['augmentedData/Right/',num2str((i-1)*4+4),'.png']);
    imwrite(uint16(vertHorizGT), ['augmentedData/GT/', num2str((i-1)*4+4),'.png']);

end