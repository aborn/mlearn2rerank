function [data, status] = getNegative(ngNO, featureName, dataset, scale, except)
%--------------------------------------------------------------------------
% function [data] = getNegative(ngNO, featureName, dataset, except)
%  get the negative data
% ngNO  -------- how many negative data to get
% featureName -- the feature name (defaut: 'gist')
% dataset ------ the dataset which data from (default msramm) 
% scale   ------ scale or not (default false)
% except  ------ which query data should be ecepct.
%             no except query if except = -1 (default)
% 2014-05-11
% NOTE: pls do saveNegative.m before call this function
% Aborn Jiang (aborn.jiang@foxmail.com)
%--------------------------------------------------------------------------
    if nargin == 1
        dataset = 'msramm';
        except  = -1;
        scale = false;
        featureName = 'gist';
    elseif nargin == 2
        except  = -1;
        scale = false;
        dataset = 'msramm';
    elseif nargin == 3
        except = -1;
        scale = false;
    elseif nargin == 4
        scale = false;
    end
    
    data = [];
    status = -1;
    if scale
        loadName = ['./data/negative/',dataset,'_',featureName,'_scale.mat'];
    else
        loadName = ['./data/negative/',dataset,'_',featureName,'.mat'];
    end
    load(loadName);        
    if exist(loadName, 'file') == 0
        disp(['fatal error, not find the negative samples.']);
        status = -1;
        data = [];
        return;
    end

    if size(dataSample, 1) < ngNO
       disp(['fatal error, the negative in dataSample is not enough.']);
        status = -1;
        data = [];
        return;
    end
    
    rdix = randperm(size(dataSample, 1));
    data = dataSample(rdix(1:ngNO), :);
    if size(data, 1) == ngNO
        status = 0;
    end
end
