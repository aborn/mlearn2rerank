function [rs] = queryRerank(data, label, MetricModel, varargin)
%--------------------------------------------------------------------------
% function [rs] = queryRerank(queryNo, varargin)
%   this function do reranking for each query.
% input:
%   data  -- the visual feature data m-by-n  m samples number, n dim
%            note the value must larger than topN
%   label -- the label of data, m-by-1
%   MetricModel = (default E), the transform matrix
%
% parameters:
%   k = (default 5) k-nn (the k-nearest neighboor) value
%   topN = (default 50) choose topN iamges for test reranking
%   method = (default 'mean') exemplarRerank method
%            can be 'mean', 'min', 'max'
%
% output:
%   rs.status         status = true if success.
%   rs.good  = true  if the number of positive samep more then negitn in topN
%   rs.x.topNrankAP
%       .topNrerankAp
%       .rankAP
%       .rerankAP
%       .exemplarAP
%                            x metric or nonmetric
%
% update:
%   2014-06-07 Aborn Jiang (aborn.jiang@foxmail.com)
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
    pars.k    = 5;
    pars.topN = 50;
    pars.method  = 'mean';
    pars    = extractpars(varargin,pars);     % extract parameters.
    rs.pars = pars;
    topN    = pars.topN;
    exemNo = floor(pars.topN/2);
    method  = pars.method;

    %% whether the positive number is more then negative
    if sum(label(1:topN,:)) > topN/2
        rs.good = true;
    end

    %% 1. compute the reranking without metric. (knn reranking)
    [rdata, rlabel] = knnRerank(pars.k, data(1:topN,:), label(1:topN,:));
    rs.nonmetric.topNrankAP = calAP(label(1:exemNo, 1));
    rs.nonmetric.topNrerankAP = calAP(rlabel(1:exemNo, 1));

    [rdata, rlabel] = knnRerank(pars.k, data, label);
    rs.nonmetric.rankAP = calAP(label);
    rs.nonmetric.rerankAP = calAP(rlabel);
    
    [rdata, rlabel] = exemplarRerank(rdata(1:exemNo,:), ...
                                     data, label, method);
    rs.nonmetric.exemplarAP = calAP(rlabel);

    %% 2. reraning with metric with specific model
    labelNew = label;
    dataNew = transform(data, MetricModel);
    [rdata, rlabel] = knnRerank(pars.k, dataNew(1:topN,:), labelNew(1:topN,:));
    rs.metric.topNrankAP = calAP(labelNew(1:exemNo, 1));
    rs.metric.topNrerankAP = calAP(rlabel(1:exemNo, 1));

    [rdata, rlabel] = knnRerank(pars.k, dataNew, labelNew);
    rs.metric.rankAP = calAP(labelNew);
    rs.metric.rerankAP = calAP(rlabel);
    
    [rdata, rlabel] = exemplarRerank(rdata(1:exemNo,:), dataNew, ...
                                     labelNew, method);
    rs.metric.exemplarAP = calAP(rlabel);
    rs.status = true;
end
