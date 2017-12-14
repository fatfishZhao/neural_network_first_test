close all
%����ѵ����
load('lms_samp.mat')

%3.LMS�㷨
%��������ؾ���R
sumR = [0,0;0,0];
for i=1:size(samp,1)
    sumR = sumR + samp(i,1:2)'*samp(i,1:2);
end
R = sumR/size(samp,1);
%���㻥�������P
P = mean(samp(:,1:2).*repmat(samp(:,3),[1,2]));
%�������Ȩֵ����Wstar
Wstar = P*R^-1;
%��С�������Emin
neural_a = neural_2(Wstar);
errorSum = 0;
for i=1:size(samp,1)
    y = neural_a.goThrough(samp(i,1:2));
    errorSum = errorSum + (y-samp(i,3))^2;
end
Emin = errorSum/size(samp,1);

%4.����ƽ��㷨
alpha = 0.01;
Estop = Emin+0.001;
[W_SGD,Elog] = SGD_mini(samp(:,1:2),samp(:,3),alpha,Estop,1);
figure;plot(Elog);title(['alpha = ',num2str(alpha)]);
%5.�ı�alpha������ƽ��㷨
for alpha = [0.002,0.008,0.02,0.1,0.3]
    [~,Elog] = SGD_mini(samp(:,1:2),samp(:,3),alpha,Estop,1);
    figure;plot(Elog);title(['alpha = ',num2str(alpha)]);
end
%6.����ͳ�Ƶ��㷨
alpha = 0.02;P = 5;
[W_SGD_mini,Elog] = SGD_mini(samp(:,1:2),samp(:,3),alpha,Estop,P);
figure;plot(Elog);title(['alpha = ',num2str(alpha),',P=',num2str(P)]);
%7.�ı�P�Ļ���ͳ�Ƶķ���
alpha = 0.02;
for P = [2,50]
    [~,Elog] = SGD_mini(samp(:,1:2),samp(:,3),alpha,Estop,P);
    figure;plot(Elog);title(['alpha = ',num2str(alpha),',P=',num2str(P)]);
end
%8.����
load('lms_tstsamp.mat')
neural_SGD = neural_2(W_SGD);
Y_SGD = neural_SGD.goThrough_th(tstsamp(:,1:2));
neural_SGD_mini = neural_2(W_SGD_mini);
Y_SGD_mini = neural_SGD_mini.goThrough_th(tstsamp(:,1:2));
disp(['����ݶ��½�����ȷ����',num2str(1-size(find(tstsamp(:,3)'~=Y_SGD),2)/size(tstsamp,1))]);
disp(['ͳ���ݶ��½�������ȷ����',num2str(1-size(find(tstsamp(:,3)'~=Y_SGD_mini),2)/size(tstsamp,1))]);
%9.Widrow�ϸ�����㷨
for alpha = [0.02,0.05,0.1,0.35]
    [~,Elog] = SGD_mini(samp(:,1:2),samp(:,3),alpha,Estop,size(samp,1));
    figure;plot(Elog);title(['alpha = ',num2str(alpha),',P=',num2str(size(samp,1))]);
end

