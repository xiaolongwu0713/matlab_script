function pts = gen_inv_pts(subject)

    %% set parameters, load finger flexion
    samplefreq=1000;  %sampling frequency
    bsize=1000;  %window size for spectral calculation
    wt=hann(bsize);  %1-.5*cos window  -- use a hann window
    % wt=hamming(bsize);  %use a hamming window

    pack, disp(subject)
    load(['data/' subject '/' subject '_fingerflex'],'flex'), clear data
    dlength=size(flex,1);
    
    %% %identify movements%%%%
    disp('calculating movement event times'),
    disp('d1'), [ch1_st_pts, ch1_inv_pts]=find_inv(flex(:,1));
    disp('d2'), [ch2_st_pts, ch2_inv_pts]=find_inv(flex(:,2));
    disp('d3'), [ch3_st_pts, ch3_inv_pts]=find_inv(flex(:,3));
    disp('d4'), [ch4_st_pts, ch4_inv_pts]=find_inv(flex(:,4));
    disp('d5'), [ch5_st_pts, ch5_inv_pts]=find_inv(flex(:,5));

    %% clear cc's artifact runs
    if subject=='cc', ch2_st_pts(197)=[]; ch3_st_pts(175)=[]; ch2_inv_pts(197)=[]; ch3_inv_pts(175)=[]; end
    
    for k=1:5, 
        eval(['ch' num2str(k) '_inv_pts(find(ch' num2str(k) '_st_pts<1000))=[];'])
        eval(['ch' num2str(k) '_st_pts(find(ch' num2str(k) '_st_pts<1000))=[];'])
    end    
    
    %% %%%%%generate random picks for "rest" condition
    all_inv_pts=[ch1_inv_pts; ch2_inv_pts; ch3_inv_pts; ch4_inv_pts; ch5_inv_pts];
    dds=ones(1,dlength);
    all_inv_pts(find(all_inv_pts<(floor(bsize*.5)+10)))=[];
    for i=1:length(all_inv_pts), dds((all_inv_pts(i)-floor(bsize*.5)):(all_inv_pts(i)+(bsize*1.5)-1))=0; end
    dds(1:bsize*1.5)=0;
    dds((length(dds)-bsize*1.5+1):length(dds))=0;  dds=find(dds);
    ch_0pts=sort(dds(ceil(rand(1,length(all_inv_pts))*length(dds))));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%% order points and keep label
    %%%% pts=[movementstart movementinversion movementlabel]
    pts=[...
        [ch_0pts' ch_0pts' 0*ch_0pts'];...
        [ch1_st_pts' ch1_inv_pts 1+0*ch1_inv_pts];...
        [ch2_st_pts' ch2_inv_pts 2+0*ch2_inv_pts];...
        [ch3_st_pts' ch3_inv_pts 3+0*ch3_inv_pts];...
        [ch4_st_pts' ch4_inv_pts 4+0*ch4_inv_pts];...
        [ch5_st_pts' ch5_inv_pts 5+0*ch5_inv_pts]...
        ];


    [y,ind]=sort(pts(:,2));
    pts=pts(ind,:);
    %throw away movement at the end which won't have a full window for spectral
    %calc.
    pts(find((pts(:,2)+ceil(bsize/2))>dlength),:)=[]; 

    %in order to stop explosion (and memory collapse) from classification of the 
    %same movement of 5 different gestures, we will intercede if more than 100 gestures
    %are less than 40 ms apart.  We will decimate the first to extend, and quantify 
    % which came as pairs, spitting the result out as a figure.

    %     qf=find(diff(pts(:,2))<(.04*samplefreq));
    %     if length(qf)>140, 
    %         qp=(pts(qf,3).*pts(qf+1,3));
    %         figure, subplot(2,1,1),hist(qp,0:20), title(strcat([patient ' overlap pairs before reject (denoted by pairproduct)']))
    %         subplot(2,1,2), hist(pts(qf,3),0:.5:5), title(strcat(['rejected pairs total: ' num2str(length(qf))]))
    %     %     print(gcf,'-dbitmap', strcat(cd,'\cccp_pre\','reject_pts',patient)); 
    %     end

    clear d1 d2 d3 d4 d5 i dds i stimulus y ind clear qf qa qp
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    save(['data/' subject '/' subject '_dg_pts'],'pts')
    clear d* ch*    



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [st_pts, inv_pts, end_pts]=find_inv(tr);
x=1:80;%width of smoothing window
y=exp((-(x-40).^2)/160); %nice gaussian smoothing window
tra=conv(double(tr),y); %convolve gauss & behavioral trace
%clip edges - yes, i know you can use "same" within conv, but i didn't...
tra(1:floor(length(y)/2))=[];
tra((length(tra)+2-floor(length(y)/2)):length(tra))=[];

%find inversion points (maximum displacement)
a=find(and(tra>(mean(tra)+std(tra)),and((tra-[tra(2:length(tra)); 0])>0,(tra-[0; tra(1:(length(tra)-1))])>0)));
% a(find(a<100))=[];

dtra=diff(tra);
dtra=conv(dtra,y); %convolve gauss & behavioral trace
%clip edges
dtra(1:floor(length(y)/2))=[];
dtra((length(dtra)+1-floor(length(y)/2)):length(dtra))=[];

dtr_sm=find(abs(dtra)<100);  

%find beginning points of each finger movement
for i=1:length(a)
    c=a(i)-80-dtr_sm;
    c(c<0)=max(c);
    cfc=find(c==min(c));
    b(i)=dtr_sm(cfc(1));
end
clear c
%find ending points of each finger movement
for i=1:length(a)
    c=a(i)+80-dtr_sm;
    c(c<0)=max(c);
    d(i)=dtr_sm(find(c==min(c)));
end

% figure, plot(tra), hold on, plot(a,tra(a),'ro'), plot(b,tra(b),'go')

st_pts=b;
inv_pts=a;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%










