bcode=0*d1;

a=ch1_st_pts(1+find(diff(ch1_st_pts)>800)); a=[ch1_st_pts(1) a];  a(end)=[];
b=ch1_inv_pts((find(diff(ch1_inv_pts)>800)));
for i=1:length(a), if abs(a(i)-b(i))>512, bcode(a(i):b(i))=1; end, end

a=ch2_st_pts(1+find(diff(ch2_st_pts)>800)); a=[ch2_st_pts(1) a];  a(end)=[];
b=ch2_inv_pts((find(diff(ch2_inv_pts)>800)));
for i=1:length(a), if abs(a(i)-b(i))>512, bcode(a(i):b(i))=2; end, end

a=ch3_st_pts(1+find(diff(ch3_st_pts)>800)); a=[ch3_st_pts(1) a];  a(end)=[];
b=ch3_inv_pts((find(diff(ch3_inv_pts)>800)));
for i=1:length(a), if abs(a(i)-b(i))>512, bcode(a(i):b(i))=3; end, end

a=ch4_st_pts(1+find(diff(ch4_st_pts)>800)); a=[ch4_st_pts(1) a];  a(end)=[];
b=ch4_inv_pts((find(diff(ch4_inv_pts)>800)));
for i=1:length(a), if abs(a(i)-b(i))>512, bcode(a(i):b(i))=4; end, end

a=ch5_st_pts(1+find(diff(ch5_st_pts)>800)); a=[ch5_st_pts(1) a];  a(end)=[];a(11)=[];
b=ch5_inv_pts((find(diff(ch5_inv_pts)>800)));
for i=1:length(a), if abs(a(i)-b(i))>512, bcode(a(i):b(i))=5; end, end
