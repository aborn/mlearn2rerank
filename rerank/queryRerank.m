function [rs] = queryRerank(data, label, MetricModel, varargin)
%--------------------------------------------------------------------------
% function [rs] = queryRerank(queryNo, varargin)
%   this function do reranking for each query.
% input:
%   data  -- the visual feature data m-by-n  m samples number, n dim
%            note the value must larger than topN
%   label -- the label of data
%   MetricModel = (default E), the transform matrix
%
% parameters:
%   k = (default 5) k-nn (the k-nearest neighboor) value
%   topN = (default 50) choose topN iamges for test reranking

%   method = (default 'rankorder') the select metric method.
%            can be 'mean', 'std', 'normalize', 'rankorder'
%   range = (default 'topN) query image test range, default only test topN
%            can be 'all'      test all query images.
%
% output:
%   rs.status 
%   rs.good  = true  if the number of positive samep more then negitn in topN
%   rs.rankAP         rank average precision (AP)
%   rs.rerankAP       knn rerank (without metric) average precision (AP)
%   rs.metricAP       metric rerank average precision (AP)
%
% update:
%   2014-06-06 Aborn Jiang (aborn.jiang@foxmail.com)
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
rs.good   = false;

pars.k = 5;
pars.topN = 50;
pars.method  = 'rankorder';
pars.range   = 'topN';
pars = extractpars(varargin,pars);     % extract parameters.
rs.pars = pars;
topN  = pars.topN;

%% whether the positive number is more then negative
if sum(label(1:topN,:)) > topN/2
    rs.good = true;
end

%% 1. compute the reranking without metric. (knn reranking)
if strcmp(pars.range, 'topN') == 1
    [~, rs.rerankAP] = knnRerank(pars.k, data(1:topN,:), label(1:topN,:));
elseif strcmp(pars.range, 'all') == 1
    [~, rs.rerankAP] = knnRerank(pars.k, data(1:end,:), label(1:end,:));
else
    disp('pars.range can only be ''topN'' or ''all'' ');
    pause(1000000000000);
end

%% 2. reraning with metric with specific model
if strcmp(pars.range, 'topN') == 1
    labelNew = label(1:topN,:);
    dataNew = transform(data(1:topN,:), MetricModel);
elseif strcmp(pars.range, 'all') == 1
    dataNew = transform(data(:,:), MetricModel);   % all data for reranking
    labelNew = label(:,:);
end
[rs.rankAP, rs.metricAP] = knnRerank(pars.k, dataNew, labelNew);

rs.status = true;
