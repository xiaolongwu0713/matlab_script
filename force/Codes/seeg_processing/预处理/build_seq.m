function [seq]=build_seq(seq)
a=find(seq==1);
b=find(seq==2);
c=find(seq==3);
d=find(seq==4);
seq=zeros(4,10);
seq(1,:)=a;
seq(2,:)=b;
seq(3,:)=c;
seq(4,:)=d;
end