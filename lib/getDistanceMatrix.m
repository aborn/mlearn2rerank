function distM = getDistanceMatrix(data)
%--------------------------------------------------------------------------
% get the distance matrix (Euclidean distance)
% input: data  -- sampleno*dim 
% output: distM -- distance matrix
% date: 2014-04-22
%--------------------------------------------------------------------------
    
    distM = zeros(size(data,1), size(data, 1));  % distance matrix
    for i=1:size(data, 1)
        for j=1:size(data, 1)
            if i ~= j
                csub = data(i,:) - data(j,:);
                distM(i,j) = sum(csub.^2)^0.5;   % compute the distance
            end
        end
    end
    
end

