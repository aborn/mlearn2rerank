% trainDataFeatureExtraction.m
% prepare images' visual feature for metric training.
% this data only can be used for training.
% because it collect all positive samples from dataset
% featureName CLD  CSD  DCD  EHD  HTD  SCD  gist
% 2014-06-06

setInitial;
disp('Start prepare feature data for metric training.');
dataSetName = 'msramm';
featureName = 'DCD';  %  DCD  HTD

%% basic settings.
imgClassNo = get_dataSetInfo(dataSetName,'imgClassNo');
imgClass = get_dataSetInfo(dataSetName, 'imgClass');
labels = get_dataSetInfo(dataSetName,'labels2');

b=labels(labels(:,1)==1);
for i=1:size(labels,1)       % check whether data is legal.
    if imgClassNo(i,1:2) ~= labels(i,1:2)
        disp('bad match');
    end
end

%% obtain the feature of iamges.
for i = 1:size(imgClass,1)
    iLabels = labels(labels(:,1)==i,:);
    featureI = [];
    for j = 1:size(iLabels,1)
        if iLabels(j,3) == 1
            queryNo = iLabels(j,1);
            imageNo = iLabels(j,2);
            imageI = get_imageName(queryNo, imageNo, dataSetName);
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
disp('preparing data finished.');
