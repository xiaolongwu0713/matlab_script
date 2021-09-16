function [odist]=edist(in1,in2);
%function [odist]=edist(in1,in2);
%this function calculates the euclidean distance between points 2 input variables,
%[in1/2]=(points x dimensions)

if size(in1)~=size(in2), error('badness, different size vectors','badness, different size vectors'),end

dim=size(in1,2);
ptlength=size(in1,1);

odist=zeros(ptlength,1);

for i=1:ptlength
    temp=0;
    for j=1:dim
        temp=temp+(in1(i,j)-in2(i,j))^2;
    end
    odist(i)=temp^.5;
end





