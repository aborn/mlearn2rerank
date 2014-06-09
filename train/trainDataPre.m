% trainDataPre.m
% prepare training data for metric learning.
% all data are saved in ./data/dataSetName/featureName/

clear all;
close all;

setInitial;
dataSetName = 'msramm';
featureName = 'CLD';
scale = true;
imgClass = get_dataSetInfo(dataSetName, 'imgClass');
labels = get_dataSetInfo(dataSetName,'labels2');

ss = [];
dataOther = [];
labelOther = [];
% note: for the data normalization
eachOtherNumber = 10;    % for other kind, sample 10 each.
posSampleNumber = 500;
unadaptQueryNo = 0;

if scale 
    disp('start prepare scale training data.');
else
    disp('start prepare un-scale training data.');
end
tic;

for k = 1:2
    for i = 1:size(imgClass, 1)
        matName = [featureName, num2str(i)];
        loadName=sprintf('./data/%s/%s/%s.mat', dataSetName, featureName, ...
                         matName);
        load(loadName);
        if k == 1       % for other kind, sample 10 each
            dataOther = [dataOther; data(1:eachOtherNumber,:)];
            iLabels = zeros(eachOtherNumber, 1);
            iLabels(:,:) = i;
            labelOther = [labelOther; iLabels(1:eachOtherNumber,:)];
        end            % for positive kind.
        if k == 2 && size(data, 1) >= posSampleNumber
            label = zeros(size(data,1), 1);
            label(:,:) = i;
            xTr = [data(eachOtherNumber+1:end,:); dataOther];
            yTr = [label(eachOtherNumber+1:end,:); labelOther];
            xTr = double(xTr');
            yTr = double(yTr');
            if scale 
                xTr = scaleMethod(xTr);
                saveName = sprintf('./data/train/%sscale%d.mat', featureName, i);
            else
                saveName = sprintf('./data/train/%s%d.mat', featureName, i);
            end
            save(saveName, 'xTr', 'yTr');
        end
        
        if k == 2 && size(data, 1) < posSampleNumber
            disp(['pos sample number = ', num2str(size(data,1)), ...
                  '  less ', num2str(posSampleNumber)]);
            unadaptQueryNo = unadaptQueryNo + 1;
        end
    end
end

disp(['unadaptQueryNo = ', num2str(unadaptQueryNo)]);
toc;
disp('finished prepare training data.');
