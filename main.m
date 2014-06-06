%main.m

%% basic setting
clc
clear all;
clean all;
setpars;
setpath;

%% extract visual feature of training images
trainDataFeatureExtraction

%% prepare train data
trainDataPre

%% train model 
trainModel

%% reranking data pre
testDataPre

%% do reranking
testSelectMetric
