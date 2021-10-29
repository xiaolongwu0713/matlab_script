% %% 初始化
RandIndex = randperm(30);
train_trial=RandIndex(1:27);
train_num=27;
test_num=3;
train_trial=RandIndex(1:train_num);
test_trial=RandIndex((end-3+1):end);
channel=[8 9 10 18 19 20 21 22 23 24 62 63 69 70 105 107 108 109 110];
trial=[1:20,31:40];
protocol=4;
%% 特征 5个频段的能量+SEEG原始信号
%train
seeg_train=data_resized(:,trial(train_trial),channel,protocol);
delta_train=power_of_delta_resized(:,trial(train_trial),channel,protocol);
theta_train=power_of_theta_resized(:,trial(train_trial),channel,protocol);
alpha_train=power_of_alpha_resized(:,trial(train_trial),channel,protocol);
beta_train=power_of_beta_resized(:,trial(train_trial),channel,protocol);
gamma_train=power_of_gamma_resized(:,trial(train_trial),channel,protocol);
force_train=force_resized(:,trial(train_trial),protocol);
%test
seeg_test=data_resized(:,trial(test_trial),channel,protocol);
delta_test=power_of_delta_resized(:,trial(test_trial),channel,protocol);
theta_test=power_of_theta_resized(:,trial(test_trial),channel,protocol);
alpha_test=power_of_alpha_resized(:,trial(test_trial),channel,protocol);
beta_test=power_of_beta_resized(:,trial(test_trial),channel,protocol);
gamma_test=power_of_gamma_resized(:,trial(test_trial),channel,protocol);
force_test=force_resized(:,trial(test_trial),protocol);
%% 排成一排
for j=1:length(channel);
    for i=1:train_num
%         force(((i-1)*30000+1):i*30000)=force_train(:,i);
        delta(((i-1)*30000+1):i*30000,j)=delta_train(:,i,j);
        theta(((i-1)*30000+1):i*30000,j)=theta_train(:,i,j);
        alpha(((i-1)*30000+1):i*30000,j)=alpha_train(:,i,j);
        beta(((i-1)*30000+1):i*30000,j)=beta_train(:,i,j);
        gamma(((i-1)*30000+1):i*30000,j)=gamma_train(:,i,j);
        seeg(((i-1)*30000+1):i*30000,j)=seeg_train(:,i,j);
    end
end
for i=1:train_num
    force(((i-1)*30000+1):i*30000)=force_train(:,i);
end
%% 加窗取特征
Fs=2000;
WinLength=0.1*Fs;
SlideLength=0.05*Fs;
N=length(force);
WinNum=N/WinLength*2-1;    
for j=1:length(channel)
    for i=1:WinNum
        if i==1
            x1(i,j)=median(seeg(((i-1)*WinLength+1):i*WinLength,j));
            x2(i,j)=median(delta(((i-1)*WinLength+1):i*WinLength,j));
            x3(i,j)=median(theta(((i-1)*WinLength+1):i*WinLength,j));
            x4(i,j)=median(alpha(((i-1)*WinLength+1):i*WinLength,j));
            x5(i,j)=median(beta(((i-1)*WinLength+1):i*WinLength,j));
            x6(i,j)=median(gamma(((i-1)*WinLength+1):i*WinLength,j));
        else
            x1(i,j)=median(seeg(((i-1)*SlideLength+1):(i-1)*SlideLength+WinLength,j));
            x2(i,j)=median(delta(((i-1)*SlideLength+1):(i-1)*SlideLength+WinLength,j));
            x3(i,j)=median(theta(((i-1)*SlideLength+1):(i-1)*SlideLength+WinLength,j));
            x4(i,j)=median(alpha(((i-1)*SlideLength+1):(i-1)*SlideLength+WinLength,j));
            x5(i,j)=median(beta(((i-1)*SlideLength+1):(i-1)*SlideLength+WinLength,j));
            x6(i,j)=median(gamma(((i-1)*SlideLength+1):(i-1)*SlideLength+WinLength,j));
        end
    end
end

for i=1:WinNum
    if i==1
         y1(i)=median(force(((i-1)*WinLength+1):i*WinLength));
    else
         y1(i)=median(force(((i-1)*SlideLength+1):(i-1)*SlideLength+WinLength));
    end
end

%% PLS算法
train_data=zeros(WinNum,(6*19+1));
train_data(:,1:19)=x1;
train_data(:,20:38)=x2;
train_data(:,39:57)=x3;
train_data(:,58:76)=x4;
train_data(:,77:95)=x5;
train_data(:,96:114)=x6;
train_data(:,115)=y1';

pz=train_data;

mu=mean(pz);sig=std(pz); % 求每一列（即每一个特征）的均值和标准差
rr=corrcoef(pz); % 求相关系数矩阵
data=zscore(pz); % z=(x-mean(x))./std(x) 数据中心标准化
n=6*19; m=1; % n为自变量的个数，m为因变量的个数
x0=pz(:,1:n); y0=pz(:,n+1:end); % 原始的自变量和因变量数据
e0=data(:,1:n); f0=data(:,n+1:end); % 标准化后的自变量和因变量数据
num=size(e0,1); %求样本点的个数
chg=eye(n); % w到w*变换矩阵的初始化
for i=1:n
%以下计算w, w*和t的特征分量
    matrix=e0'*(f0*f0')*e0;
    [vec,val]=eig(matrix); %求特征值和特征向量
    val=diag(val); %提出对角元素
    [val,ind]=sort(val,'descend');
    w(:,i)=vec(:,ind(1)); %提出最大特征值对应的特征向量
    w_star(:,i)=chg*w(:,i);
    t(:,i)=e0*w(:,i); %计算成分ti的得分
    alpha=e0'*t(:,i)/(t(:,i)'*t(:,i)); %计算alpha_i
    chg=chg*(eye(n)-w(:,i)*alpha'); % 计算w到w*的变换矩阵
    e=e0-t(:,i)*alpha'; % 计算残差矩阵
    e0=e;
%以下计算ss(i)的值
    beta=[t(:,1:i),ones(num,1)]\f0; % 求回归方程的系数
    beta(end,:)=[]; % 删除回归分析的常数项
    cancha=f0-t(:,1:i)*beta; % 求残差矩阵
    ss(i)=sum(sum(cancha.^2));
% 以下计算press(i)
    for j=1:num
        t1=t(:,1:i); f1=f0;
        she_t=t1(j,:); she_f=f1(j,:); % 把舍去的第j个样本点保存下来
        t1(j,:)=[]; f1(j,:)=[]; % 删除第j个观测值
        beta1=[t1,ones(num-1,1)]\f1; % 求回归分析的系数
        beta1(end,:)=[]; % 删除回归分析的常数项
        cancha=she_f-she_t*beta1; % 求残差向量
        press_i(j)=sum(cancha.^2);
    end
    press(i)=sum(press_i);
    if i>1
        Q_h2(i)=1-press(i)/ss(i-1);
    else
        Q_h2(1)=1;
    end
    if Q_h2(i)<0.0975
        fprintf('提出的成分个数 r=%d',i);
        r=i;
        break
    end
end
beta_z=[t(:,1:r),ones(num,1)]\f0; % 求Y关于t的回归系数
beta_z(end,:)=[]; %删除常数项
xishu=w_star(:,1:r)*beta_z; %求Y关于X的回归系数，且是针对标准数据的回归系数，每一列是一个回归方程
mu_x=mu(1:n); mu_y=mu(n+1:end);
sig_x=sig(1:n); sig_y=sig(n+1:end);
for i=1:m
    ch0(i)=mu_y(i)-mu_x./sig_x*sig_y(i)*xishu(:,i); % 计算原始数据的回归方程的常数项
end
for i=1:m
    xish(:,i)=xishu(:,i)./sig_x'*sig_y(i); %计算原始数据的回归方程的系数，每一列是一个回归方程
end
sol=[ch0;xish]; %显示回归方程的系数，每一列是一个方程，每一列的第一个数是常数项

save train_data_p4 x0 y0 num xishu ch0 xish yhat a

yhat=ch0+x0*xish; % 计算y的预测值

%% 绘制回归系数图
bar(abs(xishu))

%% 绘制预测图
% 观察各个自变量在解释yk(k=1,2,3)时的边际组用。
ch0=repmat(ch0,num,1);
yhat=ch0+x0*xish; % 计算y的预测值
y1max=max(yhat);
y2max=max(y0); % y0为因变量数据
ymax=max([y1max;y2max])
cancha=yhat-y0; % 计算残差
subplot(2,2,1)
plot(0:ymax(1),0:ymax(1),yhat(:,1),y0(:,1),'*')
subplot(2,2,2)
plot(0:ymax(2),0:ymax(2),yhat(:,2),y0(:,2),'o')
subplot(2,2,3)
plot(0:ymax(3),0:ymax(3),yhat(:,3),y0(:,3),'H')


%% test
% 先clear force delta theta alpha beta gamma seeg WinLength
for j=1:length(channel);
    for i=1:test_num
        force(((i-1)*30000+1):i*30000)=force_test(:,i);
        delta(((i-1)*30000+1):i*30000,j)=delta_test(:,i,j);
        theta(((i-1)*30000+1):i*30000,j)=theta_test(:,i,j);
        alpha(((i-1)*30000+1):i*30000,j)=alpha_test(:,i,j);
        beta(((i-1)*30000+1):i*30000,j)=beta_test(:,i,j);
        gamma(((i-1)*30000+1):i*30000,j)=gamma_test(:,i,j);
        seeg(((i-1)*30000+1):i*30000,j)=seeg_test(:,i,j);
    end
end
%% 加窗取特征
Fs=2000;
WinLength=0.1*Fs;
SlideLength=0.05*Fs;
N=length(force);
WinNum=N/WinLength*2-1;    
for j=1:length(channel)
    for i=1:WinNum
        if i==1
            x7(i,j)=mean(seeg(((i-1)*WinLength+1):i*WinLength,j));
            x8(i,j)=mean(delta(((i-1)*WinLength+1):i*WinLength,j));
            x9(i,j)=mean(theta(((i-1)*WinLength+1):i*WinLength,j));
            x10(i,j)=mean(alpha(((i-1)*WinLength+1):i*WinLength,j));
            x11(i,j)=mean(beta(((i-1)*WinLength+1):i*WinLength,j));
            x12(i,j)=mean(gamma(((i-1)*WinLength+1):i*WinLength,j));
        else
            x7(i,j)=mean(seeg(((i-1)*SlideLength+1):(i-1)*SlideLength+WinLength,j));
            x8(i,j)=mean(delta(((i-1)*SlideLength+1):(i-1)*SlideLength+WinLength,j));
            x9(i,j)=mean(theta(((i-1)*SlideLength+1):(i-1)*SlideLength+WinLength,j));
            x10(i,j)=mean(alpha(((i-1)*SlideLength+1):(i-1)*SlideLength+WinLength,j));
            x11(i,j)=mean(beta(((i-1)*SlideLength+1):(i-1)*SlideLength+WinLength,j));
            x12(i,j)=mean(gamma(((i-1)*SlideLength+1):(i-1)*SlideLength+WinLength,j));
        end
    end
end

for i=1:WinNum
    if i==1
         y2(i)=median(force(((i-1)*WinLength+1):i*WinLength));
    else
         y2(i)=median(force(((i-1)*SlideLength+1):(i-1)*SlideLength+WinLength));
    end
end

test_data=zeros(WinNum,(6*19+1));
test_data(:,1:19)=x7;
test_data(:,20:38)=x8;
test_data(:,39:57)=x9;
test_data(:,58:76)=x10;
test_data(:,77:95)=x11;
test_data(:,96:114)=x12;
test_data(:,115)=y2';

ch0=repmat(ch0,WinNum,1);
x_test=test_data(:,1:6*19);
y_test=test_data(:,end);
yhat_2=ch0+x_test*xish; % 计算y的预测值
save test_data_p4 x_test  y_test yhat_2 WinNum b_2

%% 计算R^2
% train
cancha_train=y0-a;
cancha_train_sum=sum(cancha_train.*cancha_train);
bias_train=y0-repmat(mean(y0),8099,1);
bias_train_sum=sum(bias_train.*bias_train);
RR=1-cancha_train_sum./bias_train_sum;

% test
cancha_test=y_test-b_2;
cancha_test_sum=sum(cancha_test.*cancha_test);
bias_test=y_test-repmat(mean(y_test),899,1);
bias_test_sum=sum(bias_test.*bias_test);
RR=1-cancha_test_sum./bias_test_sum;




