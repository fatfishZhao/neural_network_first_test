function [W,Elog] = SGD_mini(X,Y,alpha,Estop,P)
% ����ͳ�Ƶ��ݶ��½��㷨,�����������ݶ��½�����ֱ�ӽ�P����Ϊ1
% Inputs
    E = 10000;
    W = rand(1,size(X,2));%��ʼ�����Ȩ��
    neural_b = neural_2(W);
    Elog=[];
    while(E>Estop)
        if P==size(X,1) %Widrow
            checkNO = 1:P;
        else
            checkNO = randi([1 size(X,1)],1,P);%���P�����������
        end
        tmpSigma = 0;%W�ı������м����
        for checkIndex = checkNO
            y = neural_b.goThrough(X(checkIndex,:));
            thisError = Y(checkIndex)-y;%�������
            tmpSigma = tmpSigma + thisError * X(checkIndex,:);%tmpSigmaÿ�ε���
        end
        neural_b.W = neural_b.W + 2 * alpha / P * tmpSigma;
        %���������������
        errorSum = 0;
        for i=1:size(X,1)
            y = neural_b.goThrough(X(i,:));
            errorSum = errorSum + (y-Y(i))^2;
        end
        E = errorSum/size(X,1);
        Elog = [Elog,E];
    end
    W = neural_b.W;
end