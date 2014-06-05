function NO=getModelNumber(modelName, featureName)
% function NO=getModelNumber(modelName, featureName)
% get model number based on model name
% the model name composed of like 'featureNamemodelNumber.mat'
% input: modelName  --- model name (not include path)
%        featureName -- feature name ,like 'gist' 'SCD' etc.
% output: model number
% Date: 2014-04-26 Aborn Jiang (aborn.jiang@foxmail.com) 
    
    if nargin ~= 2
        help getModelNumber;
        return;
    end
    NO = -1;    
    if strcmp(featureName, 'number')
        nameC =  regexp(modelName,'\d*','match');
        if size(nameC, 1) == 0 && size(nameC, 2) == 0
            disp(['Error, we can not find the ', modelName,' number']);
        else
            NO = str2double(nameC{1,1});
        end
        return;
    end

    feaLen = size(featureName, 2);    % feature length
    index = strfind(modelName,'.');
    if isempty(index) 
        disp(['Error, we can not find the ', modelName,' number']);
        return;
    end
    
    NO = str2double(modelName(1,feaLen+1:index-1));
    if isnan(NO)
        disp(['Error find the number']);
        NO = -1;
    end
    
end