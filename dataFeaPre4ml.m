% dataFeaPre4ml.m
% prepare images' visual feature for metric learning.
% this data only can be used for training.
% because it collect all positive samples from dataset
% 2014-04-07

disp('Start prepare feature data for metric learning.');
setpath;
dataSetName = 'msramm';
featureName = 'HTD';  %  DCD  HTD
imgClassNo = get_dataSetInfo(dataSetName,'imgClassNo');
imgClass = get_dataSetInfo(dataSetName, 'imgClass');
labels = get_dataSetInfo(dataSetName,'labels2');

b=labels(labels(:,1)==1);
for i=1:size(labels,1)
    if imgClassNo(i,1:2) ~= labels(i,1:2)
        disp('bad match');
    end
end

for i = 1:size(imgClass,1)
    iLabels = labels(labels(:,1)==i,:);
    featureI = [];
    for j = 1:size(iLabels,1)
        if iLabels(j,3) == 1
            imageI = get_imageName(iLabels(j,1), iLabels(j,2), ...
                                                 dataSetName);
            [fea, status] = get_feature(imageI, featureName);
            if status ~= 0 || size(fea,2) == 0
                continue;
            end
            featureI = [featureI; fea];
            disp(['i=', num2str(i), ' j=', num2str(j), '   left=', ...
                  num2str(size(iLabels,1) - j)])
        end
    end
    matName=[featureName, num2str(i)];
    data = featureI;
    saveName=sprintf('./data/%s/%s/%s.mat',dataSetName ,featureName, matName);
    save(saveName, 'data');
    disp(['i=',num2str(i), '  left=',num2str(size(imgClass,1)-i)]);
    clear data;
    clear featureI;
end
disp('prepare data finished.');
