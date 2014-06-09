function [bestMetric, bestDistM] = selectMetric(MetricPath, data, varargin)
%--------------------------------------------------------------------------
% function [bestMetric, bestDistM] = selectMetric(MetricPath, data, varargin)
% select prefer metric for reranking.
% input: data -- sampleno-by-dim    sampleno must larger then k
%        MetricPath --the trained metric model
%
% parameters:
%   k = (default 5) k-nn (the k-nearest neighboor) value
%   scale = (default false) wether or not use scale model.
%   method = (default 'std') adapt which kind of chosen method.
%            can be 'mean', 'std', 'normalize', 'rankorder'
%   negtag = (default false) the last half data as true negative samples
%            if negtag is true
%
% output: bestMetric  -- the best metric model
%          bestDistM   -- the distance matrix when using best metric model.
%
% update:
%       2014-05-11   Aborn Jiang(aborn.jiang@foxmail.com)
%--------------------------------------------------------------------------

    if nargin == 0
        help selectMetric;
        return;
    end
    
    % setting default parameters.
    pars.k = 5;
    pars.scale = false;
    pars.method = 'std';  % standard method.
    pars.negtag = false;
    pars = extractpars(varargin, pars);
    
    % get model name list
    [s, nameC] = getModelNameList(MetricPath, pars.scale);
    if size(nameC, 1) == 0
        disp('Warning: no exist model in function selectMetric.');
        return;      % no exist model.
    end
    
    ModelNo = size(nameC, 1);
    for i = 1:ModelNo
        MetricNumber  = getModelNumber(nameC{i,1}, 'number');
        if MetricNumber == -1
            disp('This is a bug in seek modual number');
            pause(10000000000);
        end
        % load the model file
        loadName = [MetricPath, nameC{i,1}];
        load(loadName);

        dataNew = transform(data, L);
        distM = getDistanceMatrix(dataNew);
        currentScore = getMetricScore(distM, pars.method, pars.k, pars.negtag);
        if i == 1
            bestScore = currentScore;
            bestMetric = MetricNumber;
            bestDistM = distM;
        else
            if bestScore > currentScore
                bestScore = currentScore;
                bestMetric = MetricNumber;
                bestDistM = distM;
            end
        end
    end
    
    disp(['  best metric = ', num2str(bestMetric), ...
          ' best score = ', num2str(bestScore), ...
         ' method = ', pars.method]);
end

%% get the metric score
function score = getMetricScore(distM, method, k, negtag)
%--------------------------------------------------------------------------
% the method can be 'std', 'mean', 'normalize', 'rankorder'
% the smaller the score, the better the metric.
% the last half samples are true negative if negtag is true
%--------------------------------------------------------------------------
    NO = size(distM, 1);    % sample number
    scoreList = zeros(NO, 1);
    for j = 1:NO
        cRow = distM(j, :);
        [cRowSort, index] = sort(cRow);
        if strcmp(method, 'rankorder') == 1
            scoreList(j, 1) = sum(index(1, 1:k))/k;     % base on order info
        else
            scoreList(j, 1) = sum(cRowSort(1, 1:k))/k;  % base on distance
        end
    end
    
    [sortScoreList, index]= sort(scoreList);
    if strcmp(method, 'std') == 1
        score = std(sortScoreList);
    elseif strcmp(method, 'mean') == 1
        score = mean(sortScoreList);
    elseif strcmp(method, 'normalize') == 1
        maxVal = sortScoreList(NO, 1);
        minVal = sortScoreList(1, 1);
        sortScoreList = (sortScoreList - minVal)./(maxVal - minVal);
        score = sum(sortScoreList);
    elseif strcmp(method, 'rankorder') == 1
        score = sum(sortScoreList);
    end
    
    if negtag      % last half is negative samples
                   % posNumber = NO;               %% count all sample index
        posNumber = NO/2;    %% not count the last 50 index
        score = 0;
        for i=1:posNumber
            if index(i, 1) > 50
                score = score + (1/log2(i + 1));
            end
        end
        score = 1/(1 + score);
        %        disp('use negative for experiments.')
    end
end
