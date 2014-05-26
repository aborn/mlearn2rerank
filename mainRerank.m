% mainRerank.m
% main call procedure for image search reranking.
% Aborn Jiang
% 2014-04-22

clc;
clear all;
close all;
tic;
disp('start to do reranking.');
setpath;
dataSetName = 'webquery';
featureName = 'gist';  %  DCD  HTD
method = 'rankorder';  % 'mean', 'std', 'normalize', 'rankorder'
imgClass    = get_dataSetInfo(dataSetName, 'imgClass');
MetricPath = './data/model/gist/';
best = true;

k = 5;
improved = 0;
gimproved = 0;
gno = 0;
testNo   = 0;
map      = zeros(1,3);
MetricModel = 1;

for i = 1:size(imgClass,1)            % for each query
    queryNo = i;
    [rs] = queryRerank(dataSetName, queryNo, 'feature', featureName, ...
                       'best', best, 'verbose', false, ...
                       'MetricModel', MetricModel, 'method', method, ...
                       'MetricPath', MetricPath, 'k', k);
    if rs.status
        if rs.metricAP > rs.rerankAP
            improved = improved + 1;
            if rs.good 
                gimproved = gimproved + 1;
            end
        end

        testNo = testNo + 1;
        disp(['rank=', num2str(rs.rankAP), '  rerank without metric=',...
              num2str(rs.rerankAP), ' metric rerank=', num2str(rs.metricAP)]);
        disp(['imporved=', num2str(improved), ' ratio=', ...
              num2str(improved/testNo) ,' testNo=', num2str(testNo)]);
        map(1,1) = map(1,1) + rs.rankAP;
        map(1,2) = map(1,2) + rs.rerankAP;
        map(1,3) = map(1,3) + rs.metricAP;
        cmap = map./testNo;
        disp(['map rank=', num2str(cmap(1,1)),...
              ' map rerank without metric=', num2str(cmap(1,2)),...
              ' map metric rerank=', num2str(cmap(1,3))]);
    else
        disp(['warning: i=', num2str(i), ' skipped!']);
    end
    
    if rs.good 
        gno = gno + 1;
    end
    
    disp(['i=', num2str(i), '  left=', num2str(size(imgClass,1)-i), ...
          ' gimproved=', num2str(gimproved), ' gno=', num2str(gno), ...
          ' googratio=', num2str(gimproved/gno)]);
    disp('++++++++++++++++++++++++++++++');

end
disp('reranking finished.');
toc;