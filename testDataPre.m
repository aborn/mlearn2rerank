% testDataPre.m
% prepare test virsual data in the data of  webqueries 
% search reranking.
% 2014-05-09

clc;
clear all;
close all;
disp('Start testDataPre.m');

setpath;
dataSetName = 'webquery';
featureName = 'EHD';  %  DCD  HTD gist
imgClassNo = get_dataSetInfo(dataSetName, 'imgClassNo');
imgClass = get_dataSetInfo(dataSetName, 'imgClass');
labels = get_dataSetInfo(dataSetName,'labels2');
scale = true;
% make sure the labels' index is correct.
for i=1:size(labels,1)
    if imgClassNo(i,1:2) ~= labels(i, 1:2)
        disp('bad match');
    end
end

for i = 1:size(imgClass,1)              % for each query
    iLabels = labels(labels(:,1)==i,:);
    featureI = [];
    labelI = [];
    for j = 1:size(iLabels,1)           % for each image
        imageI = get_imageName(iLabels(j,1), iLabels(j,2), ...
                                             dataSetName);
        [fea, status] = get_feature(imageI, featureName);
        if status ~= 0 || size(fea,2) == 0
            continue;
        else
            featureI = [featureI; fea];
            labelI = [labelI; iLabels(j, 3)];
        end
    end
    matName=[featureName, num2str(imgClass(i,1))];
    data = featureI;
    label = labelI;
    saveName=sprintf('./data/%s/%s/%s.mat',dataSetName ,...
                     featureName, matName);
    save(saveName, 'data', 'label');
    
    if scale
        matName=[featureName,'scale' num2str(imgClass(i,1))];
        saveName=sprintf('./data/%s/%s/%s.mat',dataSetName ,featureName, ...
                         matName);
        data = (scaleMethod(data', 'norm'))';
        save(saveName, 'data', 'label');
    end
    
    disp(['i=',num2str(i), '  left=',num2str(size(imgClass,1)-i)]);
    clear data;
    clear featureI;
    clear labelI;
end

disp('prepare data finished.');
