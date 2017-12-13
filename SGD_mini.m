function [W,Elog] = SGD_mini(X,Y,alpha,Estop,P)
% 基于统计的梯度下降算法,如果想用随机梯度下降法，直接将P设置为1
% Inputs
    E = 10000;
    W = rand(1,size(X,2));%初始化随机权重
    neural_b = neural_2(W);
    Elog=[];
    while(E>Estop)
        if P==size(X,1) %Widrow
            checkNO = 1:P;
        else
            checkNO = randi([1 size(X,1)],1,P);%获得P个随机抽样点
        end
        tmpSigma = 0;%W改变的求和中间变量
        for checkIndex = checkNO
            y = neural_b.goThrough(X(checkIndex,:));
            thisError = Y(checkIndex)-y;%计算误差
            tmpSigma = tmpSigma + thisError * X(checkIndex,:);%tmpSigma每次叠加
        end
        neural_b.W = neural_b.W + 2 * alpha / P * tmpSigma;
        %测试所有样本误差
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