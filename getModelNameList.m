function [s, nameC] = getModelNameList(path, scale)
% function [s, nameC] = getModelNameList(path, scale)
% get all scale/nomal model name list from given path.
% input: path -- model path
%        scale  -- (default false) whether choose scale model
% output: s ------- the runing state of the program
%        nameC---- the name list, Cell data format
% Date: 2014-04-27 Aborn Jiang (aborn.jiang@foxmail.com)

    if nargin == 0
        help getModelNameList;
        return;
    elseif nargin == 1
        scale = false;
    end
    namelistfile = [path, '/namelist.txt'];

    if scale
        cmd  = sprintf('ls %s |grep scale  > %s',path, namelistfile);  
        %disp(['scale cmd=', cmd]);
    else
        cmd  = sprintf('ls %s |grep -v scale >%s',path, namelistfile);
        %disp(['scale cmd=', cmd]);
    end
    [s,r]= system(cmd);

    fileID = fopen(namelistfile);
    C = textscan(fileID,'%s');
    fclose(fileID);
    nameAll = C{1,1};
    order   = 1;
    nameC   = {};
    imageNo = 0;
    for i=1:size(nameAll,1)
        if length(nameAll{i,1})>3 && ...
                strcmpi(nameAll{i,1}(1,end-3:end), '.mat')==1       
            nameC{order,1} = nameAll{i,1};
            order = order + 1;
        end
    end
    if size(nameC, 1) == 0
        disp('no model exists!');
    end
end



