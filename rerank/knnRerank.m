function [ap, rd] = knnRerank(k,data,label, tag)
%--------------------------------------------------------------------------
% using knn to rerank the initial ranking images.
% input: k  -- k nearest neighboor
%        data -- sampeleno*dim test sample data  (defalut)
%        data is bestDistM when tag equals 'best'
%        label -- sampleno*1   test sample label.
%        tag (default false), tag = true if return the rerank data and label
% output: rankAP  -- original rank average precision
%         rerankAP -- the rerank average precision.
%
% update:
%   2014-06-06 Aborn Jiang (aborn.jiang@foxmail.com)
%--------------------------------------------------------------------------
    if nargin < 4
        tag = false;
    end
    
    rankAP = calAP(label);
    distM = getDistanceMatrix(data);  % distance matrix
    
    scoreM = zeros(size(data,1), 2);
    for i = 1:size(data,1)
        cRow = distM(i, :);
        cRowSort = sort(cRow);
        scoreM(i, 1) = sum(cRowSort(1, 1:k))/k;
        scoreM(i, 2) = label(i,1);
    end
    sortScoreM = sortrows(scoreM, 1);
    rerankAP = calAP(sortScoreM(:, 2));
    
    if tag
        sdata = zeros(size(data, 1), size(data, 2) + 1);
        sdata(:,1) = scoreM(:,1);
        sdata(:,2:end) = data(:,:);
        sortSdata = sortrows(sdata, 1);

        ap.rankAP = rankAP;
        ap.rerankAP = rerankAP;
        rd.label = sortScoreM(:, 2);
        rd.data = sortSdata(:,2:end);
    else
        ap = rankAP;
        rd = rerankAP;
    end
end
