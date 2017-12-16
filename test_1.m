close all
%导入训练集
load('lms_samp.mat')

%3.LMS算法
%计算自相关矩阵R
sumR = zeros(3);
X = [ones(size(samp,1),1),samp(:,1:2)];
Y = samp(:,3);
for i=1:size(X,1)
    sumR = sumR + X(i,:)'*X(i,:);
end
R = sumR/size(X,1);
%计算互相关向量P
P = mean(X.*repmat(Y,[1,3]));
%计算最佳权值向量Wstar
Wstar = P*R^-1;
%最小均方误差Emin
neural_a = neural_2(Wstar);
errorSum = 0;
for i=1:size(X,1)
    y = neural_a.goThrough(X(i,:));
    errorSum = errorSum + (y-Y(i,1))^2;
end
Emin = errorSum/size(X,1);

%4.随机逼近算法
alpha = 0.01;
Estop = Emin+0.001;
[W_SGD,Elog] = SGD_mini(X,Y,alpha,Estop,1);
figure;plot(Elog);title(['alpha = ',num2str(alpha)]);
%5.改变alpha的随机逼近算法
for alpha = [0.002,0.008,0.02,0.1,0.3]
    [~,Elog] = SGD_mini(X,Y,alpha,Estop,1);
    figure;plot(Elog);title(['alpha = ',num2str(alpha)]);
end
%6.基于统计的算法
alpha = 0.02;P = 5;
[W_SGD_mini,Elog] = SGD_mini(X,Y,alpha,Estop,P);
figure;plot(Elog);title(['alpha = ',num2str(alpha),',P=',num2str(P)]);
%7.改变P的基于统计的方法
alpha = 0.02;
for P = [2,50]
    [~,Elog] = SGD_mini(X,Y,alpha,Estop,P);
    figure;plot(Elog);title(['alpha = ',num2str(alpha),',P=',num2str(P)]);
end
%8.检验
load('lms_tstsamp.mat')
testX = [ones(size(tstsamp,1),1),tstsamp(:,1:2)];
testY = tstsamp(:,3);
neural_SGD = neural_2(W_SGD);
Y_SGD = neural_SGD.goThrough_th(testX);
neural_SGD_mini = neural_2(W_SGD_mini);
Y_SGD_mini = neural_SGD_mini.goThrough_th(testX);
disp(['随机梯度下降法正确率是',num2str(1-size(find(testY'~=Y_SGD),2)/size(testX,1))]);
disp(['统计梯度下降法的正确率是',num2str(1-size(find(testY'~=Y_SGD_mini),2)/size(testX,1))]);
%9.Widrow严格递推算法
for alpha = [0.02,0.05,0.1,0.35]
    [~,Elog] = SGD_mini(X,Y,alpha,Estop,size(X,1));
    figure;plot(Elog);title(['alpha = ',num2str(alpha),',P=',num2str(size(X,1))]);
end

