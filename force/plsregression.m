
trainTestRatio=7/3;

%% generate data or load existing formated data.
%[trainset,testset]=plsdataPrepare(3,activeChannels,activeTrials,trainTestRatio);
totalData=load_data(9999,'move3TrainData');
trainset=totalData.trainset;
testset=totalData.testset;
% training
sol=pls(trainset,'train');
filename=strcat(root_path,'pls/plsmove4.mat');
save(filename,'sol');
% training performance
ch0=sol(1);
xishu=sol(2:end);
bar(abs(xishu))
sampleNum=size(trainset,1);
ch0=repmat(ch0,sampleNum,1);
y_trainPredict=ch0+trainset(:,1:end-1)*xishu;
y_trainTarget=trainset(:,end);
y1max=max(y_trainPredict);
y2max=max(y_trainTarget);
ymax=max([y1max;y2max])
figure();
plot(0:ymax(1),0:ymax(1),y_trainPredict(:,1),y_trainTarget(:,1),'*')
figure();
plot(y_trainTarget,'r--');hold on;plot(y_trainPredict,'b');


% testing
sol=load_data(999,'plsmove4');
y_testTarget=testset(:,end);
y_testPredict=pls(testset,'test',sol);
%subplot(2,1,1); plot(y_pred); subplot(2,1,2); plot(y_test);
figure();
plot(y_testTarget,'r','LineWidth',0.1);hold on;plot(y_testPredict,'b');

%% plsregress in Matlab
totalData=load_data(9999,'move4TrainData');
trainset=totalData.trainset;
testset=totalData.testset;
y_trainTarget=trainset(:,end);
mu=mean(trainset); sig=std(trainset); %求均值和标准差
rr=corrcoef(trainset);  %求相关系数矩阵
trainsetz=zscore(trainset); %数据标准化
a=trainsetz(:,1:end-1);b=trainsetz(:,end);  %提出标准化后的自变量和因变量数据
[XL,YL,XS,YS,BETA,PCTVAR,MSE,stats] =plsregress(a,b);
contr=cumsum(PCTVAR,2) %求累积贡献率
xw=a\XS;  %求自变量提出成分系数，每列对应一个成分，这里xw等于stats.W
yw=b\YS; %求因变量提出成分的系数
ncomp=input('According to PCTVAR matrix, how many component to be used?  ncomp=');
[XL2,YL2,XS2,YS2,BETA2,PCTVAR2,MSE2,stats2] =plsregress(a,b,ncomp);
n=size(a,2); m=size(b,2);%n是自变量的个数,m是因变量的个数
beta3(1,:)=mu(n+1:end)-mu(1:n)./sig(1:n)*BETA2([2:end],:).*sig(n+1:end); %原始数据回归方程的常数项
beta3([2:n+1],:)=(1./sig(1:n))'*sig(n+1:end).*BETA2([2:end],:); %计算原始变量x1,...,xn的系数，每一列是一个回归方程
%bar(BETA2','k')   %画直方图
y_trainPredict=repmat(beta3(1,:),[size(a,1),1])+trainset(:,[1:n])*beta3([2:end],:);  %求y1,..,ym的预测值
ymax=max([y_trainPredict;trainset(:,[n+1:end])]); %求预测值和观测值的最大值
%regression permance
figure;
plot(y_trainPredict(:,1),trainset(:,end),'*',[0:ymax(1)],[0:ymax(1)],'Color','k');
figure;
plot(y_trainTarget,'r','LineWidth',0.1);hold on;plot(y_trainPredict,'b');


% prediction
a1=testset(:,1:end-1);b1=testset(:,end);
n1=size(a1,2); m1=size(b1,2);
y_testPredict=repmat(beta3(1,:),[size(a1,1),1])+testset(:,[1:n1])*beta3([2:end],:); 
y_testTarget=testset(:,end);
figure();
plot(y_testTarget,'r','LineWidth',0.1);hold on;plot(y_testPredict,'b');


%% test the algorithm
load('Linnerud_training.txt');
trainset=Linnerud_training(:,1:4);
% training
sol=pls(trainset,'train');
% training performance
ch0=sol(1);
xishu=sol(2:end);
bar(abs(xishu))
sampleNum=size(trainset,1);
ch0=repmat(ch0,sampleNum,1);
y_trainPredict=ch0+trainset(:,1:end-1)*xishu;
y_trainTarget=trainset(:,end);
figure();
plot(y_trainTarget,'r--');hold on;plot(y_trainPredict,'b');


