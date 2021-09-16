function electrodes=get_loc(fname)
% this function is to determine electrode locations in talairach coordinates from x-ray
% call in form electrodes=get_loc('xray.jpeg');
% this function reads in an image from file 'fname'
% it should be a lateral skull x-ray.  it will determine y and z coordinates
% the top of the picture should be caudal
% kai j miller, july 2005 (ver 1.0)
% edited march 2006, kjm (ver 1.1)

%load image in  (should be an acceptable imagetype (see help imread))
%image must also be less than resolution of screen
rel_dir=which('get_loc');
rel_dir((length(rel_dir)-9):length(rel_dir))=[];
skull=imread(strcat(rel_dir,'\xray\',fname));
% skull=double((skull(:,:,1)))/2;
oskull=skull;
%which side of cortex?
temp=1;
while temp==1
    side=input(['input r if right hemisphere, l if left hemisphere: '],'s');
    if side=='r'
        temp=0;
    elseif side=='l'
        temp=0;
    else
        disp('you didn''t press r or l, try again')
    end
end

%medial or lateral electrodes?
temp=1;
while temp==1
    disp('Are the electrodes of interest lateral? (press l)')
    medlat=input(['or are they intrahemispheric-medial? (press i)'],'s');
    if medlat=='l'
        temp=0;
    elseif medlat=='i'
        temp=0;
    else
        disp('you didn''t press l or i, try again (is caps on?)')
    end
end



%generate figure
fid=figure;

%change figure size and position
set(fid,'Position',[50 50 800 600])

%need to change it from color to black and white later... (done march 2006
%by using all 3 layers)
imagesc(skull),axis equal, axis off


%variable moveon will be placemarker
moveon=1;

key='n';

%step 1: define glabella
while moveon==1
    title('Define position of Glabella using mouse.  Press "y" when satisfied.')
    km=waitforbuttonpress;
    temp=get(fid);
    temp2=get(gca);
    if km==0     %mouse
        m_pos=floor(temp2.CurrentPoint(1,1:2));
    elseif km==1 %key button
        key=temp.CurrentCharacter;
    end
    skulltemp=skull;
    skulltemp(m_pos(2)-3:m_pos(2)+3,m_pos(1)-3:m_pos(1)+3,1)=255; %7 pixel square centered about clicked point
    skulltemp(m_pos(2)-3:m_pos(2)+3,m_pos(1)-3:m_pos(1)+3,2)=0; %7 pixel square centered about clicked point
    skulltemp(m_pos(2)-3:m_pos(2)+3,m_pos(1)-3:m_pos(1)+3,3)=0; %7 pixel square centered about clicked point
    imagesc(skulltemp),axis equal, axis off
    if key=='y'
        moveon=2;
        glab_pt=m_pos;
    end
end

skull=skulltemp;
key='n';

%step 2: define Inion

while moveon==2
    title('Define position of Inion using mouse.  Press "y" when satisfied.')
    km=waitforbuttonpress;
    temp=get(fid);
    temp2=get(gca);
    if km==0     %mouse
        m_pos=floor(temp2.CurrentPoint(1,1:2));
    elseif km==1 %key button
        key=temp.CurrentCharacter;
    end
    skulltemp=skull;
    skulltemp(m_pos(2)-3:m_pos(2)+3,m_pos(1)-3:m_pos(1)+3,1)=255; %7 pixel square centered about clicked point
    skulltemp(m_pos(2)-3:m_pos(2)+3,m_pos(1)-3:m_pos(1)+3,2)=0; %7 pixel square centered about clicked point
    skulltemp(m_pos(2)-3:m_pos(2)+3,m_pos(1)-3:m_pos(1)+3,3)=0; %7 pixel square centered about clicked point
    imagesc(skulltemp),axis equal, axis off
    if key=='y'
        moveon=3;
        inion_pt=m_pos;
    end
end

skull=skulltemp;
key='n';

%step 3: draw line between Inion and Glabella (GI line) note that x->y and
%y->z  slope is (y-y')/(z-z')
%note, instead going to z/y b/c need all pts and more y than z
GI_slope=((glab_pt(2)-inion_pt(2))/(glab_pt(1)-inion_pt(1)));
GI_line_y=glab_pt(1):sign(inion_pt(1)-glab_pt(1)):inion_pt(1);
GI_line_z=glab_pt(2)+(GI_line_y-glab_pt(1))*GI_slope;
GI_line_y=floor(GI_line_y);
GI_line_z=floor(GI_line_z);

for i=1:length(GI_line_z) %ugly ugly way to do it, but vectorized is giving me probs and time is scarce
    skull(GI_line_z(i), GI_line_y(i),1)=255;
    skull(GI_line_z(i), GI_line_y(i),2)=0;
    skull(GI_line_z(i), GI_line_y(i),3)=0;
end
imagesc(skull),axis equal, axis off
moveon=4;

%step 4: find points which maximize orthogonal distance to inner table of
%the skull by clicking
m_pos=[];

while moveon==4
    title('click on upper inner table of skull many times.  it will find max orthogonal distance.  press y when happy or s to start over.')
    km=waitforbuttonpress;
    temp=get(fid);
    temp2=get(gca);
    if km==0     %mouse
        m_pos=[m_pos; floor(temp2.CurrentPoint(1,1:2))];
    elseif km==1 %key button
        key=temp.CurrentCharacter;
    end
    skulltemp=skull;
    if isempty(m_pos)~=1
        for i=1:length(m_pos(:,1))
            skulltemp(m_pos(i,2)-3:m_pos(i,2)+3,m_pos(i,1)-3:m_pos(i,1)+3,1)=255; %7 pixel square centered about clicked point
            skulltemp(m_pos(i,2)-3:m_pos(i,2)+3,m_pos(i,1)-3:m_pos(i,1)+3,2)=0; %7 pixel square centered about clicked point
            skulltemp(m_pos(i,2)-3:m_pos(i,2)+3,m_pos(i,1)-3:m_pos(i,1)+3,3)=0; %7 pixel square centered about clicked point
        end
    end
    imagesc(skulltemp),axis equal, axis off
    if key=='y'
        moveon=5;
    elseif key=='s'
        m_pos=[];
    end
end
%calculate max orthogonal distance

prin_angle=atan(...
    (GI_line_z(1)-GI_line_z(length(GI_line_z)))...
    /...
    (GI_line_y(1)-GI_line_y(length(GI_line_y)))...
    );

%prescription
%find angle
%find largest line using trig
%using angle and largest line length, calculate line segment
big_length=0;
for i=1:length(m_pos(:,1))
    vertpt=find(GI_line_y==m_pos(i,1));
    vertdist=abs(m_pos(i,2)-GI_line_z(vertpt));
    t_length=cos(prin_angle)*vertdist;
    if t_length>big_length
        big_length=t_length;
        big_index=i;
    end
end
big_slope=-GI_slope; %now calculating line using inverse mapping (actual slope would be -1/GI_slope) 
zmax=big_length;
big_line_z=m_pos(big_index,2):floor(big_length*cos(prin_angle)+m_pos(big_index,2));
big_line_y=m_pos(big_index,1)+(big_line_z-m_pos(i,2))*big_slope;
big_line_y=floor(big_line_y);
big_line_z=floor(big_line_z);
skulltemp=skull;
for i=1:length(big_line_z)
    skulltemp(big_line_z(i), big_line_y(i),1)=0;
    skulltemp(big_line_z(i), big_line_y(i),2)=0;
    skulltemp(big_line_z(i), big_line_y(i),3)=255;
end    
imagesc(skulltemp),axis equal, axis off

z0pty=big_line_y(floor(.79*length(big_line_y)));
z0ptz=big_line_z(floor(.79*length(big_line_y)));

z0_line_y=1:length(skull(1,:,1));
temp=find(z0_line_y==z0pty);
z0_line_z=z0_line_y*GI_slope;
z0_line_z=z0_line_z+(z0ptz-z0_line_z(temp));

z0_line_z=floor(z0_line_z);
z0_line_y=floor(z0_line_y);


for i=1:length(z0_line_z)
    skulltemp(z0_line_z(i), z0_line_y(i),1)=0;
    skulltemp(z0_line_z(i), z0_line_y(i),2)=0;
    skulltemp(z0_line_z(i), z0_line_y(i),3)=255;
end    
imagesc(skulltemp),axis equal, axis off

moveon=6;

key='n';
%step 6: define anterior extent of y axis
while moveon==6
    title('define y axis on anterior inner table.  Press "y" when satisfied.')
    km=waitforbuttonpress;
    temp=get(fid);
    temp2=get(gca);
    if km==0     %mouse
        y_pos=floor(temp2.CurrentPoint(1,1));
    elseif km==1 %key button
        key=temp.CurrentCharacter;
    end
    indextempa=find(z0_line_y==y_pos);
    m_posa=[z0_line_y(indextempa) z0_line_z(indextempa)];
    skulltemp2=skulltemp;
    skulltemp2(m_posa(2)-3:m_posa(2)+3,m_posa(1)-3:m_posa(1)+3,1)=255; %7 pixel square centered about clicked point
    skulltemp2(m_posa(2)-3:m_posa(2)+3,m_posa(1)-3:m_posa(1)+3,2)=0; %7 pixel square centered about clicked point
    skulltemp2(m_posa(2)-3:m_posa(2)+3,m_posa(1)-3:m_posa(1)+3,3)=0; %7 pixel square centered about clicked point
    imagesc(skulltemp2),axis equal, axis off
    if key=='y'
        skulltemp2(m_posa(2)-3:m_posa(2)+3,m_posa(1)-3:m_posa(1)+3,1)=0; %7 pixel square centered about clicked point
        skulltemp2(m_posa(2)-3:m_posa(2)+3,m_posa(1)-3:m_posa(1)+3,2)=0; %7 pixel square centered about clicked point
        skulltemp2(m_posa(2)-3:m_posa(2)+3,m_posa(1)-3:m_posa(1)+3,3)=255; %7 pixel square centered about clicked point
        imagesc(skulltemp2),axis equal, axis off
        moveon=7;
        y_axis_ant_pt=m_posa;
    end
end

key='n';
%step 7: define posterior extent of y axis
while moveon==7
    title('define y axis on posterior inner table.  Press "y" when satisfied.')
    km=waitforbuttonpress;
    temp=get(fid);
    temp2=get(gca);
    if km==0     %mouse
        y_pos=floor(temp2.CurrentPoint(1,1));
    elseif km==1 %key button
        key=temp.CurrentCharacter;
    end
    indextempb=find(z0_line_y==y_pos);
    m_posb=[z0_line_y(indextempb) z0_line_z(indextempb)];
    skulltemp2=skulltemp;
    skulltemp2(m_posb(2)-3:m_posb(2)+3,m_posb(1)-3:m_posb(1)+3,1)=255; %7 pixel square centered about clicked point
    skulltemp2(m_posb(2)-3:m_posb(2)+3,m_posb(1)-3:m_posb(1)+3,2)=0; %7 pixel square centered about clicked point
    skulltemp2(m_posb(2)-3:m_posb(2)+3,m_posb(1)-3:m_posb(1)+3,3)=0; %7 pixel square centered about clicked point
    imagesc(skulltemp2),axis equal, axis off
    if key=='y'
        moveon=8;
        y_axis_post_pt=m_posb;
    end
end

%step 8: find midpoint of y axis.  
z0_line_y=z0_line_y(indextempa:sign(indextempb-indextempa):indextempb);
z0_line_z=z0_line_z(indextempa:sign(indextempb-indextempa):indextempb);
cpt_y=z0_line_y(floor(.5*length(z0_line_y)));
cpt_z=z0_line_z(floor(.5*length(z0_line_z)));

big_line_y=big_line_y-(big_line_y(floor(mean(find(big_line_z==cpt_z))))-cpt_y);

y0_line_y=big_line_y;
y0_line_z=big_line_z;
clear big*
moveon=9;

%replot
skulltemp=oskull;
for i=1:length(y0_line_z)
    skulltemp(y0_line_z(i), y0_line_y(i),1)=0;
    skulltemp(y0_line_z(i), y0_line_y(i),2)=0;
    skulltemp(y0_line_z(i), y0_line_y(i),3)=255;
end  
for i=1:length(z0_line_z)
    skulltemp(z0_line_z(i), z0_line_y(i),1)=0;
    skulltemp(z0_line_z(i), z0_line_y(i),2)=0;
    skulltemp(z0_line_z(i), z0_line_y(i),3)=255;
end  
skulltemp(cpt_z-3:cpt_z+3,cpt_y-3:cpt_y+3,1)=0; %7 pixel square centered about origin
skulltemp(cpt_z-3:cpt_z+3,cpt_y-3:cpt_y+3,2)=0; %7 pixel square centered about origin
skulltemp(cpt_z-3:cpt_z+3,cpt_y-3:cpt_y+3,3)=255; %7 pixel square centered about origin
imagesc(skulltemp),axis equal, axis off
skull=skulltemp;

%step 9: collect electrode position points
key='n';
raw_elec=[];
elec_num=1;
while moveon==9
    title(['Define electrode ' num2str(elec_num) ' position.  Press "y" to keep point.  Press "d" if done.'])
    km=waitforbuttonpress;
    temp=get(fid);
    temp2=get(gca);
    if km==0     %mouse
        m_pos=floor(temp2.CurrentPoint(1,1:2));
    elseif km==1 %key button
        key=temp.CurrentCharacter;
    end
    skulltemp=skull;
    skulltemp(m_pos(2)-3:m_pos(2)+3,m_pos(1)-3:m_pos(1)+3,1)=255; %7 pixel square centered about clicked point
    skulltemp(m_pos(2)-3:m_pos(2)+3,m_pos(1)-3:m_pos(1)+3,2)=0; %7 pixel square centered about clicked point
    skulltemp(m_pos(2)-3:m_pos(2)+3,m_pos(1)-3:m_pos(1)+3,3)=0; %7 pixel square centered about clicked point
    imagesc(skulltemp),axis equal, axis off
    if key=='y'
        skulltemp(m_pos(2)-3:m_pos(2)+3,m_pos(1)-3:m_pos(1)+3,1)=0; %7 pixel square centered about clicked point
        skulltemp(m_pos(2)-3:m_pos(2)+3,m_pos(1)-3:m_pos(1)+3,2)=255; %7 pixel square centered about clicked point
        skulltemp(m_pos(2)-3:m_pos(2)+3,m_pos(1)-3:m_pos(1)+3,3)=0; %7 pixel square centered about clicked point
        imagesc(skulltemp),axis equal, axis off
        raw_elec=[raw_elec; m_pos];
        elec_num=elec_num+1;
        skull=skulltemp;
        key='n';
    elseif key=='d'
        moveon=10;
    end
end

%step 10: convert electrode positions to tailorac

%reference electrodes to center in standard x-y
raw_elec_y=raw_elec(:,1)-cpt_y;
raw_elec_z=raw_elec(:,2)-cpt_z;
%if xray has nose to left, y -> -y
if glab_pt(1)<inion_pt(1)
    raw_elec_y=-raw_elec_y;
else %b/c of inversely calculated chirality
    prin_angle=-prin_angle;
end

%put matrix y and z into talairac y and z
tail_elec_y=cos(prin_angle)*raw_elec_y-sin(prin_angle)*raw_elec_z;
tail_elec_z=sin(prin_angle)*raw_elec_y+cos(prin_angle)*raw_elec_z;

%b/c of image import property, z -> -z
tail_elec_z=-tail_elec_z;

%need to scale into tailorach using ymax and zmax
ymax=sqrt((z0_line_y(1)-z0_line_y(length(z0_line_y)))^2 +(z0_line_z(1)-z0_line_z(length(z0_line_y)))^2);
zmax=zmax*.79;

tail_y=tail_elec_y*173/ymax-11.5;
tail_z=tail_elec_z*75/zmax; %classic tailarach prescription

%get x-coordinates from brain template
if medlat=='l' %lateral?
    electrodes=get_loc_xlat(tail_y,tail_z,side);
elseif medlat=='i' %intrahemispheric?
    electrodes=get_loc_xih(tail_y,tail_z,side);
end

%assign tail_x vector
tail_x=electrodes(:,1);
electrodes=[tail_x tail_y tail_z];
disp('----------------------------------')
disp('index number and electrode locations in talairach coordinates')
disp('(electrode - x - y - z)')
disp(num2str([[1:length(electrodes(:,1))]' electrodes]))
%save data to file
if medlat=='l'
    save(strcat(cd,'\',fname(1:3),'_lat_loc'),'electrodes')
elseif medlat=='i'
    save(strcat(cd,'\',fname(1:3),'_ih_loc'),'electrodes')
end