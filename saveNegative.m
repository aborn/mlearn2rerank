%--------------------------------------------------------------------------
% save the negative data to ./data/negative/
% save name format dataset_featureName[_scale].mat
% this function is util for getNegative.m
% 2014-05-12
% Aborn Jiang (aborn.jiang@foxmail.com)
%--------------------------------------------------------------------------

clc;
clear;
dataset = 'msramm';
except  = -1;
scale = true;
featureName = 'CLD';
queryNO = 68;          % only for 'msramm'

data = [];
status = -1;
dataSample = [];
noOfEachquery = 20*queryNO;

for i = 1:queryNO
    if scale
        loadName = sprintf('./data/train/%sscale%d.mat', featureName, i);
    else
        loadName = sprintf('./data/train/%s%d.mat', featureName, i);
    end
    if exist(loadName, 'file') == 0
        continue;
    end
    load(loadName);
    tmp = xTr';
    if size(tmp, 1) > noOfEachquery 
        dataSample = [dataSample; tmp(1:noOfEachquery,:)];
    end
end

if scale
    saveName = ['./data/negative/',dataset,'_',featureName,'_scale.mat'];
else
    saveName = ['./data/negative/',dataset,'_',featureName,'.mat'];
end

save(saveName, 'dataSample');
