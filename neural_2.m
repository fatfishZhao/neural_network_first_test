classdef neural_2
    %nerual �������������Ԫ����
    %   Detailed explanation goes here
    
    properties
        W
    end
    
    methods
        function obj = neural_2(Weight)
            %neural_2 Construct an instance of this class
            %   Detailed explanation goes here
            obj.W = Weight;
        end
        
        function outputArg = goThrough(obj,X)
            %goThrough ����ض�X������Ԫ���
            %   Detailed explanation goes here
            outputArg = obj.W*X';
        end
        function outputArg = goThrough_th(obj,X)
            %goThrough_th ����ض�X������Ԫ��������Ҽ�������ֵ����
            %   Detailed explanation goes here
            outputArg = obj.W*X';
            outputArg(outputArg>0)=1;
            outputArg(outputArg<=0)=-1;
        end
    end
end

