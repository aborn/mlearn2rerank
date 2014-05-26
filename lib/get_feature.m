function [fea state]= get_feature(imageName, featureName, param)
%---------------------------------------------------------------
%-usage: [fea state]= get_feature(imageName, featureName, param)
%-        obtain the image's feature (linux-32)
%-input: imageName --- image name
%-       featureName-- feature name 'gist', 'sift', 'CSD',
%                      'SCD', 'CLD', 'DCD', 'HTD', 'EHD'
%-       par---------- parameter if necessy for some feature
%-output: fea -------- the feature
%-        state ------ the state of the program or the other rs
%-hist.: v0.0 @ 2013-05-12 created by aborn jiang 
%        v1.0 @ 2014-04-20 update by Aborn Jiang
%---------------------------------------------------------------
    addpath(genpath('~/research/code/feature/gistdescriptor'));
    addpath(genpath('/home/aborn/research/code/feature/Ncut_9'));
    fea = [];
    if nargin < 3        % GIST Parameters:
        clear param
        % number of orientations per scale (from HF to LF)
        param.orientationsPerScale = [8 8 8 8]; 
        param.numberBlocks = 4;
        param.fc_prefilt = 4;
        param.vis = 0;
    end
    switch featureName
      case 'gist'
        img = imread(imageName);
        [gist, param] = LMgist(img, '', param);
        fea = gist;
        state = 0;
        if 1 == param.vis         % Visualization
            figure          subplot(121);
            imshow(img);    title('Input image');
            subplot(122);
            showGist(gist, param);
            title('Descriptor');
        end
        if nargout < 2
            state = 1;
        end
        %        disp('Gist feature extracted successful!')
        return;
      case 'sift'
        [sift, siftxy] = get_sift(imageName);
        fea   =  sift;
        state = siftxy;
        disp('SIFT feature extracted successful!')
        return;
      case {'CSD', 'SCD', 'CLD', 'DCD', 'HTD', 'EHD'}
        addpath('/home/aborn/research/lib/lib.exe/mpeg7fexlin');
        [fea, state] = getMPEG7Fex(imageName, featureName);
        % disp([featureName, ' feature (dim=', num2str(size(fea,2)), ...
        %       ') extracted successful!']);
      otherwise
        disp(['##error: the ', featureName,' cannot extracted!!']);
        state = -1;
    end
end