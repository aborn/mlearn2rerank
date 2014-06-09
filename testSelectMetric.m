%--------------------------------------------------------------------------
% testSelectMetric.m
% test the performance of selectMetric function
% please run doMetricRerank.m before running this program.
% feature: SCD, EHD, gist, CLD,
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

%feature = 'CLD';
%feature = 'SCD';
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
%load(metricRerankRS);    % reranking results
load(loadName);          % negative samples

%rsRerank = rs.rsRerank;
improved = 0;
%map   = rs.map;
expNO = 0;               % experiment number

totalAPrank = 0;         % use for calculate mAP
totalAPmetric = 0;
totalAPknn = 0;
apALL = zeros(size(imgClass,1), 4);

nonmetricAP = zeros(size(imgClass,1), 6);
metricAP    = zeros(size(imgClass,1), 6);
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
    rerankmethod = 'min';
    [rs] = queryRerank(data, label, MetricModel, ...
                       'topN', topN, 'method', rerankmethod);
    metricAP(i,1) = queryNo;
    metricAP(i,2) = rs.metric.topNrankAP;
    metricAP(i,3) = rs.metric.topNrerankAP;
    metricAP(i,4) = rs.metric.rankAP;
    metricAP(i,5) = rs.metric.rerankAP;
    metricAP(i,6) = rs.metric.exemplarAP;

    nonmetricAP(i,1) = queryNo;
    nonmetricAP(i,2) = rs.nonmetric.topNrankAP;
    nonmetricAP(i,3) = rs.nonmetric.topNrerankAP;
    nonmetricAP(i,4) = rs.nonmetric.rankAP;
    nonmetricAP(i,5) = rs.nonmetric.rerankAP;
    nonmetricAP(i,6) = rs.nonmetric.exemplarAP;
    
    % index = find(map==MetricNo);
    % metricAP = rsRerank(i, index + 2);
    
    % if rs.metricAP ~= metricAP
    %     disp(['fatal error, metric AP doesnot match.'])
    % end
    
    if rs.metric.rerankAP > rs.metric.rankAP 
        improved = improved + 1;
    end

    apALL(expNO,1) = queryNo;
    apALL(expNO,2) = rs.metric.rankAP;
    apALL(expNO,3) = rs.metric.rerankAP;
    apALL(expNO,4) = rs.metric.exemplarAP;
    totalAPrank = totalAPrank + rs.metric.rankAP;
    totalAPknn = totalAPknn + rs.metric.rerankAP;
    totalAPmetric = totalAPmetric + rs.metric.exemplarAP;
    
    disp(['***  metric rank map = ', num2str(totalAPrank/expNO), ...
          '*** metric rerank map=', num2str(totalAPknn/expNO)])
    disp(['   *** metric exemplarAP map =', num2str(totalAPmetric/expNO)]);
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

saveName=['testSelectMetric_',feature,'.mat']
save(saveName);
toc;
