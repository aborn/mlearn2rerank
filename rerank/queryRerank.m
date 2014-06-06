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
%
% output:
%   rs.status         status = true if success.
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

%% setting default parameters.
rs.status = false;
rs.good   = false;

pars.k = 5;
pars.topN = 50;
pars.method  = 'rankorder';
pars = extractpars(varargin,pars);     % extract parameters.
rs.pars = pars;
topN  = pars.topN;

%% whether the positive number is more then negative
if sum(label(1:topN,:)) > topN/2
    rs.good = true;
end

%% 1. compute the reranking without metric. (knn reranking)
[ap, rd] = knnRerank(pars.k, data(1:topN,:), label(1:topN,:), true);

rs.topNrankAP = ap.rankAP;
rs.topNknnAP = ap.rerankAP;
rerankData = rd.data;
rerankLabel = rd.label;

[rs.rankAP, rs.knnAP] = knnRerank(pars.k, data, label);

%% 2. reraning with metric with specific model
labelNew = label(1:topN,:);
dataNew = transform(data(1:topN,:), MetricModel);
[~, rs.topNmetricAP] = knnRerank(pars.k, dataNew, labelNew);

dataNew = transform(data, MetricModel);   % all data for reranking
labelNew = label;
[~, rs.metricAP] = knnRerank(pars.k, dataNew, labelNew);
rs.status = true;
