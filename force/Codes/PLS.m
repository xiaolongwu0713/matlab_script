%% 求回归模型
clc,clear 
load Linnerud_training.txt
pz=Linnerud_training;
mu=mean(pz);sig=std(pz); % 求每一列（即每一个特征）的均值和标准差
rr=corrcoef(pz); % 求相关系数矩阵 
data=zscore(pz); % z=(x-mean(x))./std(x) 数据中心标准化
n=3; m=3; % n为自变量的个数，m为因变量的个数
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
    t(:,i)=e0*w(:,i); %计算成分ti的得分成分
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

%% 绘制回归系数图
bar(xishu)

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

plot(pz(:,4));hold on; plot(yhat(:,1));



        
        
        
        