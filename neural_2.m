classdef neural_2
    %nerual 有两个输入的神经元对象
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
            %goThrough 针对特定X产生神经元输出
            %   Detailed explanation goes here
            outputArg = obj.W*X';
        end
        function outputArg = goThrough_th(obj,X)
            %goThrough_th 针对特定X产生神经元输出，并且加上了阈值限制
            %   Detailed explanation goes here
            outputArg = obj.W*X';
            outputArg(outputArg>0)=1;
            outputArg(outputArg<=0)=-1;
        end
    end
end

