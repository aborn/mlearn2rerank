function [rs] = checkAssumption(dataSetName, queryNo, feature, topN, scale)
%--------------------------------------------------------------------------
%  check whether the assumption is satisfied
%  2014-05-13 Aborn Jiang
%--------------------------------------------------------------------------

    rs = false;
    if scale 
        matName=[feature,'scale', num2str(queryNo)];
    else
        matName=[feature, num2str(queryNo)];
    end    
    
    loadName=sprintf('./data/%s/%s/%s.mat',dataSetName , feature, matName);
    load(loadName);
    
    % whether the positive number is more then negative
    if sum(label(1:topN,:)) > topN/2
        rs = true;
    end
end