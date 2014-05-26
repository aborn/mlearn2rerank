% this procedure use to test doMetricRerank function
% 2014-05-10

tic;
clc;
clear;
featureName = 'SCD';    % feature: gist, SCD
MetricPath = ['./data/model/',featureName,'/'];
dataSetName = 'webquery';
verbose = false;

[rs] = doMetricRerank(MetricPath, featureName, dataSetName, verbose);
toc;
