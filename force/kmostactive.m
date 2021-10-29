function loc=kmostactive(data,k)
% k largest number location in a matrix
% loc{k}:(x,y): k-th actived trial and channel in a session
% x:chn,y:trial

for i=[1:k]
    [max_num, max_idx]=max(data(:));
    [X,Y]=ind2sub(size(data),max_idx);
    data(X,Y)=0;
    loc{i}=[X,Y];
end

end

% test kmostactive
% B=ones(5,4);B(3,3)=10;B(4,4)=100;B(5,4)=10;
% a=kmostactive(B,3)

