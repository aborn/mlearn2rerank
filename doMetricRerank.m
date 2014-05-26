function [rs] = doMetricRerank(MetricPath, featureName, dataSetName, verbose)
%--------------------------------------------------------------------------
% function [rs] = doMetricRerank(MetricPath, featureName, dataSetName, verbose)
% search each query's best metric.
% input: MetricPath -- metric model path
%       dataSetName -- dataset name
%       verbose     -- (default false) whether or not print message.
% output:
%       rs.map = map;                 the order map 2 metric model number 
%       rs.rsRerank = rsRerank;       the all metric rerank result
%       rs.bestRerank = bestRerank;   the best metric result
% Note:
%       this function call once enough
%       all metric are saved in 
%              /home/aborn/research/code/mlearn/data/model
% Date: 2014-04-26 Aborn Jiang (aborn.jiang@foxmail.com)
% 2014-05-12 update by Aborn Jiang (aborn.jiang@foxmail.com)
%--------------------------------------------------------------------------

if nargin == 0 
    help bestMetric;
    return;
elseif nargin == 1
    featureName = 'gist';
    dataSetName = 'webquery';
    verbose = false;
elseif nargin == 2
    dataSetName = 'webquery';
    verbose = false;
elseif nargin == 3
    verbose = false;
end

if verbose
    disp('start to do metric rerank.');
    tic;
end

setpath;
[s, nameC] = getModelNameList(MetricPath, '.mat');
imgClass   = get_dataSetInfo(dataSetName, 'imgClass');
ModelNo    = size(nameC, 1);
rsRerank   = zeros(size(imgClass,1), ModelNo + 2);
map        = size(1, ModelNo);          % map 2 model number
scalevalue = true;

%% computer all metri's result
for i = 1:size(imgClass,1)            % for each query
    queryNo = imgClass(i,1);
    for MMi = 1:ModelNo;              % for each metric
        MetricModel  = getModelNumber(nameC{MMi,1}, 'number');
        map(1, MMi)  = MetricModel;
        if MetricModel == -1
            disp('fatel error, MetricModel not find');
            disp(['nameC{mmi,1}', nameC{MMi, 1}]);
            break;
            return;
        end
        
        [rs] = queryRerank(dataSetName, queryNo, 'feature', featureName, ...
                           'best', false, 'verbose', verbose, ...
                           'MetricModel', MetricModel, 'scale', scalevalue);
        if rs.status
            if verbose 
                disp(['rank=', num2str(rs.rankAP), '  rerank no metric=',...
                      num2str(rs.rerankAP), ' metric rerank=', num2str(rs.metricAP)]);
            end
            rsRerank(i, MMi+2) =  rs.metricAP;
            rsRerank(i, 1) =  rs.rankAP;
            rsRerank(i, 2) =  rs.rerankAP;
        else
            if verbose 
                disp(['warning: i=', num2str(i), ' skipped!']);
            end
        end
        if verbose
            disp(['i=', num2str(i), '  left=', num2str(size(imgClass,1)-i), ...
                  ' Model=', num2str(MetricModel)]);
            disp('++++++++++++++++++++++++++++++');
        end
    end
    disp(['i=',num2str(i), ' left=', num2str(size(imgClass,1)-i)]);
end


%% compute the best metric 
totalQueryNo = size(rsRerank, 1);
bestRerank = zeros(totalQueryNo, 4);
% column order: rank ap, no metric rerank ap, metric best ap, 
%               best MetricModel

for i=1:totalQueryNo
     [value,id] = max(rsRerank(i,3:end));
     bestRerank(i, 1:2) = rsRerank(i,1:2);
     bestRerank(i, 3) = value;
     bestRerank(i, 4) = map(1, id);
end

rs.map = map;
rs.rsRerank = rsRerank;
rs.bestRerank = bestRerank;

if scalevalue
    saveName = sprintf('mat/%s_%s_scale.mat', dataSetName, featureName);
else
    saveName = sprintf('mat/%s_%s.mat', dataSetName, featureName);
end

save(saveName, 'rs');

if verbose
    toc;
    disp('do metric rerank finished.');
end

