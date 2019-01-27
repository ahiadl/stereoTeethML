close all;
clear all;
clc;


for i=1:216
    disp(['Image Number: ' num2str(i)]);
    calcDisp = imread(['./results/augmentedTestSet/',num2str(i),'_calc.png']);
    calcDisp = ((double(calcDisp)-2^15)/2^16)*2^8;

    gt = imread(['./data/augmentedData/GT/',num2str(i),'.png']);
    gt_disp = ((double(gt)-2^15)/2^16)*2^8;
    
    L1Error(i) = (1/numel(calcDisp)) * sum(sum(abs(gt_disp - calcDisp)));
    
    h=figure();
    subplot(1,3,1)
    imshow(calcDisp,[-60 60])
    title('Calculated Disparity')
    subplot(1,3,2)
    imshow(gt_disp,[-60 60])
    title('Ground Truth')
    subplot(1,3,3)
    
    imagesc(abs(gt_disp - calcDisp))
    colorbar
    set(gca,'dataAspectRatio',[1.25 1.25 1.25])
    title(['L1 Error, Mean Error: ', num2str(L1Error(i))])
    disp(['L1 Error: ', num2str(L1Error(i))]); 
    savefig(h,['./results/augmentedTestSet/Results-',num2str(i),'.fig'])
    close(h)
end

disp(['Total set Error: ' num2str(mean(L1Error))]);