function [ap, rd] = knnRerank(k,data,label)
%--------------------------------------------------------------------------
% using knn to rerank the initial ranking images.
% input: k  -- k nearest neighboor
%        data -- sampeleno*dim test sample data  (defalut)
%        data is bestDistM when tag equals 'best'
%        label -- sampleno*1   test sample label.
%        
% output: rankAP  -- original rank average precision
%         rerankAP -- the rerank average precision.
%
% update:
%   2014-06-06 Aborn Jiang (aborn.jiang@foxmail.com)
%--------------------------------------------------------------------------

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
    ap.rankAP = rankAP;
    ap.rerankAP = rerankAP;
    rd.
end
