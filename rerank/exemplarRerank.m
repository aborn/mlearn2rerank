function [rdata, rlabel]=exemplarRerank(exemData, data, label, method)
%--------------------------------------------------------------------------
%  function exemplarRerank(exemData, data, label)
%     exemplar reranking method: choose the exemplar samples as positive
%     and other samples reranking based on the exemplars.
%  input:
%     exemData   ---  exemplar data, m-by-n , 
%                      m the number of exemplar, n dim
%     data       --- query data, m-by-n
%     label      --- query data label, m-by-1
%     method     --- the reranking method
%                can be value 'min' 'max' 'mean'
% output: 
%     rdata     --- the reranking sample data  m-by-n
%     rlabel    --- the reranking sample label info m-by-1
%  update:
%    2014-06-13  Aborn Jiang (aborn.jiang@foxmail.com)
%--------------------------------------------------------------------------
    if nargin < 4
        method = 'mean';
    end
    m = size(data, 1); n = size(data, 2);
    score = zeros(m, n+2);
    score(:, 2) = label;              % label information
    score(:, 3:end) = data;           % data information
    for i = 1:size(data, 1)
        sample = data(i, :);
        score(i, 1) = getDistance(exemData, sample, method);
    end
    sortScore = sortrows(score, 1);
    rdata = sortScore(:, 3:end);
    rlabel = sortScore(:, 2);
end

%% get the distance between a sample and exemData
function distance = getDistance(exemData, sample, method)
    distVect = zeros(size(exemData, 1), 1);
    for i=1:size(exemData, 1)
        distVect(i,1) = sum((exemData(i,:) - sample).^2)^0.5;
    end
    
    if strcmp(method, 'min')==1
        distance = min(distVect);
    elseif strcmp(method, 'mean')==1
        distance = mean(distVect);
    elseif strcmp(method, 'max')==1
        distance = max(distVect);
    else
        distance = -1;
    end
end
