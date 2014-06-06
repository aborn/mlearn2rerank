function [data, label] = getQueryData(dataSetName, queryNo, feature, scale)
%--------------------------------------------------------------------------
% function [data, label] = getQueryData(queryNo, feature, scale)
%    load the test query feature data.mat
% input:
%    dataSetName--- the dataset name
%    queryNo    --- the query number
%    feature    --- feature name
%    scale      --- scale or not (true or false)
% output:
%    data       --- the visual feature data m-by-n  m samples number, n dim
%    label      --- the label of data
% update:
%   2014-06-06 Aborn Jiang (aborn.jiang@foxmail.com)
%--------------------------------------------------------------------------
    if scale 
        matName=[feature,'scale', num2str(queryNo)];
    else
        matName=[feature, num2str(queryNo)];
    end    
    loadName=sprintf('./data/%s/%s/%s.mat',dataSetName ,feature, matName);
    if exist(loadName, 'file')
        load(loadName);
    else
        if pars.verbose
            disp(['warning: query=',num2str(queryNo),' doesnot exists!']);
        end
        data=-1;
        label=-1;
    end

end

