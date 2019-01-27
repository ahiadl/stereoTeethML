close all;
clear all;
clc;
k=1;
j=1;
logFile = importdata('trainingLog.log');
for i =1:length(logFile)
    line = logFile(i);
    C = strsplit(line{1});
    if strcmp(C(3),'training')
        data = C(6);
        globalLoss(k) = str2num(data{1});
        k=k+1;
    elseif strcmp(C(3),'total')
        data = C(7);
        epochsLoss(j) = str2num(data{1});
        j=j+1;
    end
end

figure()
subplot(1,2,1)
plot(globalLoss)
title('Loss function during All batches')
xlabel('Batch Number')
ylabel('Smooth_{L1} Loss')
subplot(1,2,2)
plot(epochsLoss)
title('Loss between Epochs')
xlabel('Epoch Number')
ylabel('Smooth_{L1} Loss')

