%--------------------------------------------------------------------------
% testSelectMetric.m
% test the performance of selectMetric function
% please run doMetricRerank.m before running
% update: 2014-06-05
%--------------------------------------------------------------------------

tic;
clc;
clear;

%% basic settings
disp('start to do select rerank.');
setpath;
dataSetName    = 'webquery';
dataSetNameNeg = 'msramm';
imgClass       = get_dataSetInfo(dataSetName, 'imgClass');

feature = 'gist';
% feature = 'SCD';
testrange='all';
% testrange='topN';
MetricPath = ['data/model/',feature,'/'];              
topN = 50;
scalevalue = true;
method = 'std';
k = 5;

%% load negative samples.
if scalevalue
    metricRerankRS = ['mat/',dataSetName,'_',feature,'_scale.mat'];
    loadName = ['./data/negative/',dataSetNameNeg,'_',feature,'_scale.mat'];
else
    metricRerankRS = ['mat/',dataSetName,'_',feature,'.mat'];
    loadName = ['./data/negative/',dataSetNameNeg,'_',feature,'.mat'];
end
load(metricRerankRS);    % reranking results
load(loadName);          % negative samples

rsRerank = rs.rsRerank;
improved = 0;
map   = rs.map;
expNO = 0;               % experiment number

totalAPrank = 0;         % use for calculate mAP
totalAPmetric = 0;
totalAPknn = 0;
%% do select best metric for reranking.
for i = 1:size(imgClass,1)            % for each query
    queryNo = imgClass(i,1);
    if scalevalue
        matName=[feature, 'scale', num2str(queryNo)];
    else
        matName=[feature, num2str(queryNo)];
    end
    loadName=sprintf('./data/%s/%s/%s.mat',dataSetName , feature, matName);
    if exist(loadName, 'file') == 0
        continue;
    end

    load(loadName);
    if size(data, 1) < topN          % if data is empty
        disp(['data is empty queryNo=',num2str(queryNo)]);
        disp(loadName);
        continue;
    end

    %% check whether the number of positive more then the negative.
    % if ~checkAssumption(dataSetName, queryNo, feature, topN, scalevalue)
    %     disp(['unsatisfied aussumption, i=',num2str(i)]);
    %     continue;    
    % end
    
    expNO = expNO + 1;
    %% get the negative number.
    rdix = randperm(size(dataSample, 1));
    dataNeg = dataSample(rdix(1:topN), :);

    %    [dataNeg, status] = getNegative(topN, feature, 'msramm', scalevalue); 
    dataExp = [data(1:topN,:); dataNeg];    % positive and negative samples.
    
    %% select the best metric
    [MetricModel, ~] = selectMetric(MetricPath, dataExp ,...
                                    'k', k, 'scale', scalevalue,...
                                    'method', method,...
                                    'negtag', true);
    %% do reranking with the best metric
    [rs] = queryRerank(dataSetName, queryNo, 'feature', feature, ...
                       'MetricModel', MetricModel, 'scale', scalevalue, ...
                       'range', testrange);
    index = find(map==MetricModel);
    metricAP = rsRerank(i, index + 2);
    
    if rs.metricAP ~= metricAP
        disp(['fatal error, metric AP doesnot match.'])
    end
    
    if metricAP > rsRerank(i, 2) && metricAP > rsRerank(i, 1)
        improved = improved + 1;
    end

    totalAPrank = totalAPrank + rsRerank(i, 1);
    totalAPknn = totalAPknn + rsRerank(i, 2);
    totalAPmetric = totalAPmetric + metricAP;
    
    disp(['***  mAP rank = ', num2str(totalAPrank/expNO), ...
          '*** mAP knn =', num2str(totalAPknn/expNO), ...
         '   *** mAP metric=', num2str(totalAPmetric/expNO)]);
    disp(['i=', num2str(i), '  left=', num2str(size(imgClass,1)-i), ...
          ' Model=', num2str(MetricModel)]);
    
    percent = improved / expNO;
    disp(['percent=', num2str(percent), '  improved=', num2str(improved), ...
     ' experiment number=', num2str(expNO)]);
    disp('++++++++++++++++++++++++++++++');
end

percent = improved / expNO;
disp(['percent=', num2str(percent), '  improved=', num2str(improved), ...
     ' experiment number=', num2str(expNO)]);