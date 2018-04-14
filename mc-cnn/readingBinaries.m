  clear all;
  close all;
  
  maxD = 60;
  
  left = memmapfile('left.bin', 'Format', 'single').Data;
  left = permute(reshape(left, [370 338 121]), [3 2 1]);
  right = memmapfile('right.bin', 'Format', 'single').Data;
  right = permute(reshape(right, [370 338 121]), [3 2 1]);
  disparity = memmapfile('disp.bin', 'Format', 'single').Data;
  disparity = reshape(disparity, [370 338])';
  
  %   range = 61:298;
  range = 1:370;
  disp = reshape(min(abs(left),[],1),338,370);
  origGT = imread('samples/input/23.png');
  GT= single(origGT)/256-128;
  err = abs(disparity(:,range)-GT(:,range)).^2;
  err(err>30)= -1;
  
  %-------------------------
  %--Stereo Method Analysis-
  %-------------------------
  mc = memmapfile('testLeft.bin', 'Format', 'single').Data;
  mc = permute(reshape(mc, [370 338 121]), [3 2 1]);
  [~,minMC] = min(mc,[],1);
  disparityMat =reshape(minMC, 338, 370,1);
  disparityMat(disparityMat > maxD+1) = disparityMat(disparityMat > maxD+1) - (maxD+1);
  
  cbca1 = memmapfile('CBCA1ahiad.bin', 'Format', 'single').Data;
  cbca1 = permute(reshape(cbca1, [370 338 121]), [3 2 1]);
  minValCBCA1 = min(min(min(cbca1)));
  [~,minCBCA1] = min(cbca1,[],1);
  cbca1Mat =reshape(minCBCA1, 338, 370,1);
  cbca1Mat(cbca1Mat > maxD+1) = cbca1Mat(cbca1Mat > maxD+1) - (maxD+1); 
  
  sgm = memmapfile('SGMahiad.bin', 'Format', 'single').Data;
  sgm = permute(reshape(sgm, [370 338 121]), [3 2 1]);
  minValSGM = min(min(min(sgm)));
  [~,minSGM] = min(abs(sgm),[],1);
  sgmMat =reshape(minSGM, 338, 370,1);
  sgmMat(sgmMat > maxD+1) = sgmMat(sgmMat > maxD+1) - (maxD+1);
  
  cbca2 = memmapfile('CBCA2ahiad.bin', 'Format', 'single').Data;
  cbca2 = permute(reshape(cbca2, [370 338 121]), [3 2 1]);
  minValCBCA2 = min(min(min(cbca2)));
  [~,minCBCA2] = min(abs(cbca2),[],1);
  cbca2Mat =reshape(minCBCA2, 338, 370,1);
  cbca2Mat(cbca2Mat > maxD+1) = cbca2Mat(cbca2Mat > maxD+1) - (maxD+1);
  
  errCBCA = abs(cbca2Mat(:,range)-GT(:,range)).^2;
  errCBCA(errCBCA>20)= 100;
  
  %--display stereo method levels
  figure(1)
  subplot(2,2,1)
  imshow(disparityMat, [] )
  title('Matching Cost')
  subplot(2,2,2)
  imshow(cbca1Mat, [] )
  title('CBCA1')
  subplot(2,2,3)
  imshow(sgmMat, [] )
  title('SGM')
  subplot(2,2,4)
  imshow(cbca2Mat, [] )
  title('CBCA2')
  
  %--compare with GT
  figure(2)
  subplot(2,2,1)
  imshow(cbca2Mat(:,range),[])
  title('Calculated Disparity')
  subplot(2,2,2)
  imshow(GT(:,range),[])
  title('GT')
  subplot(2,2,3)
  imagesc(errCBCA)
  colorbar
%   axis equal
  title('Square Error Map')
  subplot(2,2,4)
  imshow(imfuse(cbca2Mat(:,range),GT(:,range)))
  title('Images Fuse')
  
  %----------------------------------
  %--Disparity Construction Analysis-
  %----------------------------------
  
 
  %-------------------------
  %--Display Cutted Results-
  %-------------------------
%   figure(3)
%   subplot(2,2,1)
%   imshow(disparity(:,range),[])
%   title('Calculated Disparity')
%   subplot(2,2,2)
%   imshow(GT(:,range),[])
%   title('GT')
%   subplot(2,2,3)
%   imagesc(err)
%   colorbar
%   axis equal
%   title('Square Error Map')
%   subplot(2,2,4)
%   imshow(imfuse(disparity(:,range),GT(:,range)))
%   title('Images Fuse')
%   
%   figure(4)
%   subplot(1,2,1)
%   imshow(disp(:,:),[])
%   title('Calculated Disparity')
%   subplot(1,2,2)
%   imshow(GT,[])
%   title('Ground Truth')
 
  