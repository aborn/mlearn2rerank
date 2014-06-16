% showResult.m show the result information
% update
%   2014-06-13  Aborn Jiang (aborn.jiang@foxmail.com)

clc;
clear;

testFlag = false;
%testFlag = true;
topN = 40;
for kq=1:4
    if kq==1
        feature = 'CLD';
    elseif kq==2
        feature = 'SCD';
    elseif kq==3
        feature = 'gist';
    elseif kq==4
        feature = 'EHD';
    end
    if testFlag
        testSelectMetric(feature, topN);
    end
    loadName=['testSelectMetric_',feature,'.mat'];
    load(loadName);

    abc = zeros(size(apALL,1), 2);
    abc(:,1)=apALL(:,1);
    for i=2:size(apALL, 2)
        if i==2
            disp('rank result:');
        elseif i==3
            disp('rerank non-metric:');
        elseif i==4
            disp('rerank metric:');
        elseif i==5
            disp('rerank metric exemplar:');
        end
        abc(:,2)=apALL(:,i);
        calMAP(abc);
    end

    for i=1:2
        if i==1
            ap = nonmetricAP;
            name = 'non-metric:';
        else
            ap = metricAP;
            name = 'metric:';
        end
        apNew = [];
        for j=1:size(ap,1)
            if ap(j,1) ~=0
                apNew = [apNew; ap(j,:)];
            end
        end
        
        disp('  ');
        disp('-------------------------------');
        disp(['feature:', feature, '  ', name,' map info:']);
        abc = zeros(size(apNew,1), 2);
        abc(:,1) = apNew(:,1);
        for k=2:size(apNew,2)
            abc(:,2) = apNew(:,k);
            calMAP(abc);
        end
    end

end