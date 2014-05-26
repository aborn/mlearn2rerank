function tdata = transform(data, L)
% map the transformation original data to new space 
% using the trained metric transformation L
% input: data  -- origin data
%        data = samplesno*olddim
%        L     -- the trained metric transformation
%        L = newdim*olddim
% output: tdata -- the transformation result data
%         tdata sampleno*newdim
% date: 2014-04-22 
% author: Aborn Jiang (aborn.jiang@foxmail.com)
    data = data';
    if size(data,1) ~= size(L,2)
        disp('dim match error, pls check.');
        return;
    end
    
    tdata = L*data;
    tdata = tdata';
    
    