function [ap]=exemplarRerank(exemData, data, label, method)
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
%  output:
%     ap         --- the average percision
%
%  update:
%    2014-06-06  Aborn Jiang (aborn.jiang@foxmail.com)
%--------------------------------------------------------------------------
    score = zeros(size(label,1), 2);
    score(:, 2) = label;
    for i = 1:size(data, 1)
        sample = data(i, :);
        score(i, 1) = getDistance(exemData, sample, method);
    end
    sortScore = sortrows(score, 1);
    ap = calAP(sortScore(:, 2));
end


function distance = getDistance(exemData, sample, method)
% get the distance between a sample and exemData
    distVect = zeros(size(exemData, 1), 1);
    for i=1:size(exemData, 1)
        distVect(i,1) = sum((exemData(i,:) - sample).^2)^0.5;
    end
    
    switch method
      case 'min'
        distance = min(distVect);
      case 'mean'
        distance = mean(distVect);
      case 'max'
        distance = max(distVect);
    end
end
