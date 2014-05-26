% call Metric Learning Train
% 2014-04-21

clear all;
close all;
trainData = 'data/train/m.mat';

% load training data
load(trainData);
mLMNNPath = '/home/aborn/research/code/mlearn/mLMNN2.4';
addpath(genpath(mLMNNPath));
cPath = pwd;
workPath = cd(mLMNNPath);
setpaths;

dim = size(xTr, 1);
[L, ~] = lmnn2(xTr, yTr, 'maxiter', 1000,'quiet',1,'outdim',dim,...
              'mu',0.5,'validation',0,'earlystopping',25);

% change to current work path
cd(workPath);