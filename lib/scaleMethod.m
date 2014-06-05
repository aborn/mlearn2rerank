function sdata = scaleMethod(data, method)
% -------------------------------------------------------------------
% function sdata = scaleMethod(data, method)
% data normalization 
% input: data -- dim-by-N   N samples, dim feature dimension
%        method  --which nomalization method, 'norm', 'zscore'
%                  method (default = 'norm')
% output: sdata -- dim-by-N  scale result data.
% date: 2014-05-09
% -------------------------------------------------------------------

if nargin == 0
    help scaleMethod;
    return;
elseif nargin == 1
    method = 'norm';
end

if strcmp(method, 'zscore')
    sdata = zscore(data);
end

tdata = data';
sdata = zeros(size(tdata));
if strcmp(method, 'norm')
    for i = 1:size(tdata,1)
        cRow = tdata(i,:);
        cRowScale = zeros(1, size(tdata,2));
        cRowScale(:) = 0.5;
        if max(cRow) ~= min(cRow)
            cRowScale = (cRow - min(cRow))./(max(cRow) - min(cRow));
        end
        sdata(i,:) = cRowScale;
    end
end
sdata = sdata';
