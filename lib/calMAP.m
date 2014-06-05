function mAP=calMAP(apALL,dataSetName)
% 函数功能： 计算rerank以后的各组mAP
% 函数输入： apALL 所有rerank结束后query的ap结果, M-by-2
%           the first column means the queryNo, the second means ap
% 函数输出： mAP 五组concept的mAP (ALL, LP, HP, SEP, SEG)
% 函数历史：  v0.0 @ 2012-02-04
%            v0.1 @ 2014-06-05

if nargin < 2
    dataSetName = 'webquery';
end

mAP=zeros(1,5);
if strcmp(dataSetName,'webquery')
    rootPath = '/media/lab/research/Re-ranking/rerank_matlab';
    load([rootPath, '/mat/rerank/WebQueries/matALL/HP_kind.mat']);
    load([rootPath, '/mat/rerank/WebQueries/matALL/LP_kind.mat']);
    load([rootPath, '/mat/rerank/WebQueries/matALL/SEG_kind.mat']);
    load([rootPath, '/mat/rerank/WebQueries/matALL/SEP_kind.mat']);
    load([rootPath, '/mat/webquery/img/imgClass2.mat']);
    
    for feaNo=1:5
        switch feaNo
          case 1
            expKind = imgClass2;
          case 2
            expKind = LP_kind;
          case 3
            expKind = HP_kind;
          case 4
            expKind = SEP_kind;
          case 5 
            expKind = SEG_kind;
        end
        [tf,loc] = ismember(expKind, apALL(:,1));
        for i=1:size(tf,1)
            if tf(i,1) == 1
                    mAP(1, feaNo) = mAP(1, feaNo) + apALL(loc(i,1), 2);
            end
        end
        mAP(1, feaNo) = mAP(1, feaNo)/sum(tf(:,1));
    end
end

disp(['ALL map=', num2str(mAP(1, 1)), ' LP map=', num2str(mAP(1,2)), ...
     ' HP map=', num2str(mAP(1, 3)), ' SEP map=', num2str(mAP(1,4)),...
     ' SEG map=', num2str(mAP(1, 5))]);