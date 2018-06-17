imagesStruct = dir('*.png');
numOfImages = numel(imagesStruct);
mkdir('./training')
mkdir('./testing')
mkdir('.training/Left')
mkdir('.training/Right')
mkdir('.training/GT')
mkdir('.testing/Left')
mkdir('.testing/Right')
mkdir('.testing/GT')

testSeries = randi(544, floor(544*0.1),1);
testSeries = unique(testSeries);

for i = 1:2:numOfImages
    
    if(testSeries == i)
        copyfile(imagesStruct(i).name, ['.testing/Left/',num2str(testingNum) '.png'];
        copyfile(imagesStruct(i).name, ['.testing/Right/',num2str(testingNum) '.png'];
        copyfile(imagesStruct(i).name, ['.testing/GT/',num2str(testingNum) '.png'];
        testingNum = testingNum + 1;
    end
    
    copyfile(imagesStruct(i).name, ['./Left/', imagesStruct(i).name]);
    copyfile(imagesStruct(i+1).name, ['./Right/', imagesStruct(i+1).name]);
end