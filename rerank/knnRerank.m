function [rdata, rlabel] = knnRerank(k,data,label)
%--------------------------------------------------------------------------
% function [rdata, rlabel] = knnRerank(k,data,label)
%        using knn to rerank the initial ranking images.
% input: k  -- k nearest neighboor
%        data -- m-by-n test sample data  (defalut)
%                       m -- sample number, n -- dim
%        label -- m-by-1   test sample label.
% output: 
%        rdata  -- the reranking sample data  m-by-n
%        rlabel -- the reranking sample label info m-by-1
% update:
%   2014-06-13 Aborn Jiang (aborn.jiang@foxmail.com)
%--------------------------------------------------------------------------
    m = size(data, 1); n = size(data, 2);
    distM = getDistanceMatrix(data);              % distance matrix
    scoreM = zeros(m, n+2); 
    scoreM(:, 3:end) = data;                      % data information        
    for i = 1:m
        cRow = distM(i, :);
        cRowSort = sort(cRow);
        scoreM(i, 1) = sum(cRowSort(1, 1:k))/k;   % score information
        scoreM(i, 2) = label(i,1);                % label information
    end
    sortScoreM = sortrows(scoreM, 1);
    rdata = sortScoreM(:, 3:end);
    rlabel = sortScoreM(:, 2);
end
