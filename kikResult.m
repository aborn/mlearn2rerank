% kikResult.m
% dealing with the result, and print more useful info.
% Note: the best result comes form the function
%       doMetricRerank.m say more in this file.
% Warning: run this function after  doMetricRerank.m finished.
% 2014-05-10

clc;
clear;

dataSet = 'webquery';
featureName = 'gist';
scale = true;

if scale
    bestResult=['mat/',dataSet,'_',featureName,'_scale.mat'];
else
    bestResult=['mat/',dataSet,'_',featureName,'.mat'];
end

load(bestResult);

tic;
map = rs.map;
rsRerank = rs.rsRerank;
bsRerank = rs.bestRerank;

queryNo = size(rsRerank, 1);
metricNo= size(rsRerank, 2) - 2;

delta = zeros(queryNo, metricNo);
tag = delta;
promoted = zeros(queryNo, 1);
improtop3 = zeros(1, 4);

aproNo = 0;
for i = 1:size(rsRerank)
    delta(i,:) = rsRerank(i,3:end) - rsRerank(i, 2);
    tmpData = [map; delta(i,:)];
    tmpdataSort = (sortrows(tmpData', -2))';
    tag(i,:) = delta(i, :) > 0;    % indicator whether or not improved.
    promoted(i,1) = sum(tag(i,:));
    if promoted(i,1) > 0
        disp(['i=', num2str(i), ' best=', num2str(tmpdataSort(2,1)),...
              ' second=', num2str(tmpdataSort(2,2)), ...
              ' third=', num2str(tmpdataSort(2,3)), ...
              ' promoted=', num2str(promoted(i,1))]);
        improtop3(1, 1) = improtop3(1, 1) + tmpdataSort(2,1);  % top 1
        improtop3(1, 2) = improtop3(1, 2) + tmpdataSort(2,2);  % top 2
        improtop3(1, 3) = improtop3(1, 3) + tmpdataSort(2,3);  % top 3
        improtop3(1, 4) = improtop3(1, 4) + promoted(i,1);     % improve no.
        aproNo = aproNo + 1;
        pause(1);
    end
end

improtop3 = improtop3/aproNo;

if scale
    saveName = ['./mat/delta', dataSet,'_',featureName,'_scale.mat'];
else 
    saveName = ['./mat/delta', dataSet,'_',featureName,'.mat'];
end

save(saveName, 'delta', 'map');
