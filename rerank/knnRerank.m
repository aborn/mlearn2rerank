function [rankAP, rerankAP] = knnRerank(k,data,label,tag)
% using knn to rerank the initial ranking images.
% input: k  -- k nearest neighboor
%        data -- sampeleno*dim test sample data  (defalut)
%        data is bestDistM when tag equals 'best'
%        label -- sampleno*1   test sample label.
%        
% output: rankAP  -- original rank average precision
%         rerankAP -- the rerank average precision.
% Aborn Jiang (aborn.jiang@foxmail.com)
% 2014-04-22

    if nargin < 4
        tag = 'any';
    end
    rankAP = cal_AP(label);
    if strcmp(tag, 'best') == 1
        distM = data;
    else
        distM = get_distM(data);  % distance matrix
    end
    
    scoreM = zeros(size(data,1), 2);
    for i = 1:size(data,1)
        cRow = distM(i, :);
        cRowSort = sort(cRow);
        scoreM(i, 1) = sum(cRowSort(1, 1:k))/k;
        scoreM(i, 2) = label(i,1);
    end
    sortScoreM = sortrows(scoreM, 1);
    rerankAP = cal_AP(sortScoreM(:,2));