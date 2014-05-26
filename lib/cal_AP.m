function ap = cal_AP(list)
% 函数调用：ap = cal_AP(list)
% 函数功能：对排好序号的list求一次ap (average precision)
% 函数输入：list--n行1列的向量
% 函数输出：ap----average precision
% 求ap的方法： 如果得到 list = [1;0;1;0;1;0;0;1];  ap=(1/1 + 2/3 + 3/5 + 4/8)/4
% 函数历史：v0.1 @ 2011-12-15 update by Aborn
%          v0.2 @ 2012-02-19 updated by Aborn

for i=1:size(list,1)
    if list(i,1)~=0          % 非0标志为1，表示与query相关
        list(i,1)=1;
    end
end

trueNo = 0;
totalNo = 0;

non_zero_no = 0;              % 正样本数目,list中为1的样本
for i=1:size(list,1)
    if list(i,1) == 1
        non_zero_no = non_zero_no + 1;
    end
end

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

if ap>1||ap<0 
   disp(['ap=',num2str(ap)]);
end
