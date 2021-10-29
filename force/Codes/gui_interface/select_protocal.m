function select_protocal(f)
global y1 y2 i m1;
load('./force/demo_data/force_data');
load('./force/demo_data/emg_data');
t=0:0.002:(15-0.002); %���tҪ��ȫ�ֵ�һ��
    if(f==1)
        y=0*(t>=0&t<=2)+(20/3*t-40/3).*(t>2&t<5)+20.*(t>=5&t<7.5)+0*(t>=7.5);
        plot(t,y,'r','linewidth',3)
        hold on
        u=16*(t~=16);
        plot(t,u,'r--','linewidth',1.5)
        hold on
        b=0:0.5:65;
        a=2*(b~=66);
        plot(a,b,'black--','linewidth',0.6)
        axis([0 15 0 60])
        set(gca,'xtick',[0,2,5,7.5,15])
        grid on
%         y1=0*(t>=0&t<=2)+(20/3*t-40/3).*(t>2&t<5)+20.*(t>=5&t<7.5)+0*(t>=7.5);
%         y1=0*(t>=0&t<=2)+(20/3*t-40/3).*(t>2&t<=11)+60.*(t>11&t<=13.5)+0*(t>13.5);
        %С��켣
        y1=force_data(:,i)*100;
        y2=16*(t>=0&t<=15);
        %emg����
        m1=emg_data(:,i);
    end
    if(f==2)
        y=0*(t>=0&t<=2)+(20/3*t-40/3).*(t>2&t<=11)+60.*(t>11&t<=13.5)+0*(t>13.5);
        plot(t,y,'r','linewidth',3)
        hold on
        u=50*(t~=16);
        plot(t,u,'r--','linewidth',1.5)
        hold on
        b=0:0.5:105;
        a=2*(b~=106);
        plot(a,b,'black--','linewidth',0.6)
        axis([0 15 0 100])
        set(gca,'xtick',[0,2,11,13.5,15])
        set(gca,'ytick',[0,50,60,100])
        grid on
%         y1=0*(t>=0&t<=2)+(20/3*t-40/3).*(t>2&t<=11)+60.*(t>11&t<=13.5)+0*(t>13.5);
        y1=force_data(:,i)*100;
        y2=50*(t>=0&t<=15);
        m1=emg_data(:,i);
    end
    
if (f==3)
    y=0*(t>=0&t<2)+(20*t-40).*(t>=2&t<=3)+20*(t>3&t<=5.5)+0*(t>5.5);
    plot(t,y,'r','linewidth',3)
    hold on
    u=16*(t~=16);
    plot(t,u,'r--','linewidth',1.5)
    hold on
    b=0:0.5:65;
    a=2*(b~=66);
    plot(a,b,'black--','linewidth',0.6)
    axis([0 15 0 60])
    set(gca,'xtick',[0,2,5,7.5,15])
    grid on
%     y1=0*(t>=0&t<2)+(20*t-40).*(t>=2&t<=3)+20*(t>3&t<=5.5)+0*(t>5.5);
    y1=force_data(:,i)*100;
    y2=16*(t>=0&t<=15);
    m1=emg_data(:,i);
end

if(f==4)
    y=0*(t>=0&t<2)+(20*t-40).*(t>=2&t<=5)+60*(t>5&t<=7.5)+0*(t>5.5);
    plot(t,y,'r','linewidth',3)
    hold on
    u=50*(t~=16);
    plot(t,u,'r--','linewidth',1.5)
    hold on
    b=0:0.5:105;
    a=2*(b~=106);
    plot(a,b,'black--','linewidth',0.6)
    axis([0 15 0 100])
    set(gca,'xtick',[0,2,11,13.5,15])
    set(gca,'ytick',[0,50,60,100])
    grid on
%     y1=0*(t>=0&t<2)+(20*t-40).*(t>=2&t<=5)+60*(t>5&t<=7.5)+0*(t>5.5);
    y1=force_data(:,i)*100;
    y2=50*(t>=0&t<=15);
    m1=emg_data(:,i);
end
    
        