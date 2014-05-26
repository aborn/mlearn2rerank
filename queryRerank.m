function [rs] = queryRerank(dataSetName, queryNo, varargin)
%--------------------------------------------------------------------------
% function [rs] = queryRerank(dataSetName, queryNo, varargin)
% this function do reranking for each query.
% input: dataSetName -- dataset name, 'webquery' or 'MSRAMM'
%        queryNo     -- query number
%
% parameters:
%   k = (default 5) k-nn (the k-nearest neighboor) value
%   topN = (default 50) choose topN iamges for test reranking
%   MetricPath = (default './data/model/featurename') metric model path
%   MetricModel = (default 1) metric model number
%   best = (default false) whether to find the best metric from all metirc
%   feature = (default 'gist') feature name.
%   verbose = (default false) whether to display message output.
%   scale = (default false) whether to use nomalization data for rerank.
%   method = (default 'rankorder') the select metric method.
%            can be 'mean', 'std', 'normalize', 'rankorder'
%
% output:
%   rs.status 
%   rs.good  = true  if the number of positive samep more then negitn in topN
% version 1.0
%   2014-04-25 Aborn Jiang (aborn.jiang@foxmail.com)
%--------------------------------------------------------------------------

if nargin == 0
    help queryRerank;
    return;
elseif nargin ==1
    queryNo = 1;
end
setpath;

%% setting default parameters.
rs.status = false;
rs.good = false;
pars.k = 5;
pars.topN = 50;
pars.MetricPath = './data/model/';
pars.MetricModel = 1;
pars.best = false;
pars.feature = 'gist';  
pars.verbose = false;
pars.scale = false;
pars.method = 'rankorder';
pars=extractpars(varargin,pars);     % extract parameters.

if pars.verbose
    if pars.k == 5
        disp('warning, k not changed!');
    else
        disp([' k=', num2str(pars.k), ' method=', pars.method]);
    end
end

rs.pars = pars;
if pars.verbose 
    disp('------------------------------');
    disp(['  dataSet=',dataSetName,' query=',num2str(queryNo), ...
          ' reranking begin...']);
    if pars.scale
        disp(['this scale mode turn on.']);
    end
    %    pause(1);
end


%% load the test query feature data.mat.
topN = pars.topN;
if pars.scale 
    matName=[pars.feature,'scale', num2str(queryNo)];
else
    matName=[pars.feature, num2str(queryNo)];
end    

loadName=sprintf('./data/%s/%s/%s.mat',dataSetName ,pars.feature, matName);

if exist(loadName, 'file')
    load(loadName);
else
    if pars.verbose
        disp(['warning: query=',num2str(queryNo),' doesnot exists!']);
    end
end

% check whether or not enough data for experiments.
if size(data,1) < pars.topN 
    if pars.verbose
        disp(['warning: query=',num2str(queryNo),' have not enough data!']);
        disp(['topN = ', num2str(pars.topN), ' the query only has', ...
              num2str(size(data,1))])
    end
    return;
end

% whether the positive number is more then negative
if sum(label(1:topN,:)) > topN/2
    rs.good = true;
end

% compute the reranking without metric.
[~, rs.rerankAP] = knnRerank(pars.k, data(1:topN,:), label(1:topN,:));

% reraning with metric.
if pars.best 
    [rs.bestMetric, bestDistM] = selectMetric(pars.MetricPath, data(1:topN,:),...
                                              'k', pars.k, 'scale', pars.scale,...
                                              'method', pars.method);
    [rs.rankAP, rs.metricAP] = knnRerank(pars.k, bestDistM, ...
                                         label(1:topN,:), 'best');
    if pars.verbose
        disp(['  the best metric = ', num2str(rs.bestMetric)]);
    end
else
    % load specific model
    if pars.scale
        modelname = [pars.feature, 'scale', num2str(pars.MetricModel),'.mat'];
    else
        modelname = [pars.feature, num2str(pars.MetricModel),'.mat'];
    end
    loadMode = ['./data/model/', pars.feature,'/', modelname];
    if exist(loadMode, 'file')
        load(loadMode);
    else
        disp(['waring: ', loadMode, ' does not exist. skipped.' ]);
        return;
    end
    
    dataNew = transform(data(1:topN,:), L);
    [rs.rankAP, rs.metricAP] = knnRerank(pars.k, dataNew, label(1:topN,:));
    if pars.verbose
        disp(['  the current metric = ', num2str(pars.MetricModel)]);
    end
end

rs.status = true;
if pars.verbose 
    disp(['  dataSet=',dataSetName,' query=',num2str(queryNo), ...
          ' reranking finished.']);
    disp('------------------------------');
end
