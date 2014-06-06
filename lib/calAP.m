function ap = calAP(list)
%--------------------------------------------------------------------------
% function ap = calAP(list)
%  calculate the average precision of list
% input:
%  list   --- n-by-1 vector, each entry only can be the value 0 or 1
%             1 means positive samples
%             0 means negative samples
% output:
%  ap     --- the average precision
% example:
%  list = [1;0;1;0;1;0;0;1];  ap=(1/1 + 2/3 + 3/5 + 4/8)/4
% update:
%   2014-06-06  Aborn Jiang (aborn.jiang@foxmail.com)
%--------------------------------------------------------------------------
    for i=1:size(list,1)
        if list(i,1)~=0             % if the entry not equal 0, force to 1
            list(i,1)=1;
        end
    end

    trueNo = 0;                     % positiv sample number
    totalNo = 0;                    % all number

    non_zero_no = sum(list(:,1));   % the number of positive (non-zero)
    if non_zero_no==0
        ap = 0;
        return;
    end

    precision = zeros(non_zero_no,1);
    order = 1;
    for i=1:size(list,1)
        totalNo = totalNo + 1;
        if list(i,1) == 1
            trueNo = trueNo + 1;
            precision(order,1) = trueNo/totalNo;
            order = order + 1;
        end
    end
    ap = sum(precision(:,1))/size(precision,1);
end


