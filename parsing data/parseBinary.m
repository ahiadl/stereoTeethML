%parse binary script


fileID = fopen('/home/ahiadlevi/Desktop/TeethData/rawData/with Powder/LowResDisp/LowResDisp_00000.bin');
A = fread(fileID,[330 370],'int16');
A = fread(fileID,precision);