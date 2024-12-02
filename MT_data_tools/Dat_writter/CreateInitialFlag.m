function [dataflag] = CreateInitialFlag(data,idnum)
%CREATEINITIALFLAG 此处显示有关此函数的摘要
%   此处显示详细说明
n_site = size(data,1)
n_per = size(data{1,5},2)
for i = 1:n_site
    for j = 1:idnum
        dataflag{i,j} = ones(1,n_per);
    end
end
end

