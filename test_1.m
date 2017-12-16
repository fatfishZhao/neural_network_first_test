close all
%����ѵ����
load('lms_samp.mat')

%3.LMS�㷨
%��������ؾ���R
sumR = zeros(3);
X = [ones(size(samp,1),1),samp(:,1:2)];
Y = samp(:,3);
for i=1:size(X,1)
    sumR = sumR + X(i,:)'*X(i,:);
end
R = sumR/size(X,1);
%���㻥�������P
P = mean(X.*repmat(Y,[1,3]));
%�������Ȩֵ����Wstar
Wstar = P*R^-1;
%��С�������Emin
neural_a = neural_2(Wstar);
errorSum = 0;
for i=1:size(X,1)
    y = neural_a.goThrough(X(i,:));
    errorSum = errorSum + (y-Y(i,1))^2;
end
Emin = errorSum/size(X,1);

%4.����ƽ��㷨
alpha = 0.01;
Estop = Emin+0.001;
[W_SGD,Elog] = SGD_mini(X,Y,alpha,Estop,1);
figure;plot(Elog);title(['alpha = ',num2str(alpha)]);
%5.�ı�alpha������ƽ��㷨
for alpha = [0.002,0.008,0.02,0.1,0.3]
    [~,Elog] = SGD_mini(X,Y,alpha,Estop,1);
    figure;plot(Elog);title(['alpha = ',num2str(alpha)]);
end
%6.����ͳ�Ƶ��㷨
alpha = 0.02;P = 5;
[W_SGD_mini,Elog] = SGD_mini(X,Y,alpha,Estop,P);
figure;plot(Elog);title(['alpha = ',num2str(alpha),',P=',num2str(P)]);
%7.�ı�P�Ļ���ͳ�Ƶķ���
alpha = 0.02;
for P = [2,50]
    [~,Elog] = SGD_mini(X,Y,alpha,Estop,P);
    figure;plot(Elog);title(['alpha = ',num2str(alpha),',P=',num2str(P)]);
end
%8.����
load('lms_tstsamp.mat')
testX = [ones(size(tstsamp,1),1),tstsamp(:,1:2)];
testY = tstsamp(:,3);
neural_SGD = neural_2(W_SGD);
Y_SGD = neural_SGD.goThrough_th(testX);
neural_SGD_mini = neural_2(W_SGD_mini);
Y_SGD_mini = neural_SGD_mini.goThrough_th(testX);
disp(['����ݶ��½�����ȷ����',num2str(1-size(find(testY'~=Y_SGD),2)/size(testX,1))]);
disp(['ͳ���ݶ��½�������ȷ����',num2str(1-size(find(testY'~=Y_SGD_mini),2)/size(testX,1))]);
%9.Widrow�ϸ�����㷨
for alpha = [0.02,0.05,0.1,0.35]
    [~,Elog] = SGD_mini(X,Y,alpha,Estop,size(X,1));
    figure;plot(Elog);title(['alpha = ',num2str(alpha),',P=',num2str(size(X,1))]);
end

