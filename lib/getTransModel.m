function [MetricModel, status] = getTransModel(MetricNo, feature, scale)
% get the metric model based on model number
% input: 
%     MetricNo     --- metric number
%     feature      --- feature name
%     scale        --- scale or not (true or false)
% output:
%     MetricModel  --- the transform matrix
%     status = 0   --- if the model success obtain, =1 otherwise
% update:
%     2014-06-05  Aborn Jiang (aborn.jiang@foxmail.com)
    
    status = 1;
    MetricModel = -1;
    if scale
        modelname = [feature, 'scale', num2str(MetricNo),'.mat'];
    else
        modelname = [feature, num2str(MetricNo),'.mat'];
    end
    loadMode = ['./data/model/', feature,'/', modelname];
    if exist(loadMode, 'file')
        load(loadMode);
        MetricModel = L;
        status = 0;
    end
end