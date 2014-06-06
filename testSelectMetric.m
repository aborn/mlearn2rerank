%--------------------------------------------------------------------------
% testSelectMetric.m
% test the performance of selectMetric function
% please run doMetricRerank.m before running this program.
% update: 2014-06-05
%--------------------------------------------------------------------------

tic;
clc;
clear;

%% basic settings
disp('start to do select rerank.');
setInitial;
dataSetName    = 'webquery';
dataSetNameNeg = 'msramm';
imgClass       = get_dataSetInfo(dataSetName, 'imgClass');

%feature = 'gist';
feature = 'SCD';
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
apALL = zeros(size(imgClass,1), 4);

%% do select best metric for reranking.
for i = 1:size(imgClass,1)            % for each query
    queryNo = imgClass(i,1);
    [data, label] = getQueryData(dataSetName, ...
                                 queryNo, feature, scalevalue);
    if size(data, 1) < topN
        disp(['warning: query=',num2str(queryNo),' have not enough data!']);
        continue;
    end

    %% check whether the number of positive more then the negative.
    % if ~checkAssumption(dataSetName, queryNo, feature, topN, scalevalue)
    %     disp(['unsatisfied aussumption, i=',num2str(i)]);
    %     continue;    
    % end

    %% get the negative number.
    rdix = randperm(size(dataSample, 1));
    dataNeg = dataSample(rdix(1:topN), :);

    %    [dataNeg, status] = getNegative(topN, feature, 'msramm', scalevalue); 
    dataExp = [data(1:topN,:); dataNeg];    % positive and negative samples.
    
    %% select the best metric
    [MetricNo, ~] = selectMetric(MetricPath, dataExp ,...
                                 'k', k, 'scale', scalevalue,...
                                 'method', method,...
                                 'negtag', true);
    [MetricModel, status] = getTransModel(MetricNo, feature, scalevalue);
    if status == 1
        disp('fatel error, getTransModel error');
        continue;
    end
    expNO = expNO + 1;
    
    %% do reranking with the best metric
    [rs] = queryRerank(data, label, MetricModel,...
                       'range', testrange, ...
                       'topN', topN);
    index = find(map==MetricNo);
    metricAP = rsRerank(i, index + 2);
    
    % if rs.metricAP ~= metricAP
    %     disp(['fatal error, metric AP doesnot match.'])
    % end
    
    if rs.metricAP > rs.rankAP && rs.metricAP > rs.rerankAP
        improved = improved + 1;
    end

    apALL(expNO,1) = queryNo;
    apALL(expNO,2) = rs.rankAP;
    apALL(expNO,3) = rs.rerankAP;
    apALL(expNO,4) = rs.metricAP;
    totalAPrank = totalAPrank + rs.rankAP;
    totalAPknn = totalAPknn + rs.rerankAP;
    totalAPmetric = totalAPmetric + rs.metricAP;
    
    disp(['***  mAP rank = ', num2str(totalAPrank/expNO), ...
          '*** mAP knn =', num2str(totalAPknn/expNO), ...
          '   *** mAP metric=', num2str(totalAPmetric/expNO)]);
    disp(['i=', num2str(i), '  left=', num2str(size(imgClass,1)-i), ...
          ' Model=', num2str(MetricNo)]);
    
    percent = improved / expNO;
    disp(['percent=', num2str(percent), '  improved=', num2str(improved), ...
          ' experiment number=', num2str(expNO)]);
    disp('++++++++++++++++++++++++++++++');
end

percent = improved / expNO;
disp(['percent=', num2str(percent), '  improved=', num2str(improved), ...
      ' experiment number=', num2str(expNO)]);

disp(['total queries=',num2str(size(apALL,1))]);
apALL = apALL(1:expNO, :);
disp(['experimental queries=',num2str(size(apALL,1))]);

abc = zeros(size(apALL,1), 2);
abc(:,1)=apALL(:,1);
for i=2:4
    abc(:,2)=apALL(:,i);
    calMAP(abc);
end
