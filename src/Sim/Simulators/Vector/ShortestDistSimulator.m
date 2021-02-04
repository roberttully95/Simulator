classdef ShortestDistSimulator < Simulator
    %SHORTESTDISTSIMULATOR
    
    properties
        test
    end
    
    methods
        
        function this = ShortestDistSimulator(varargin)
            %TESTSIMULATOR Construct an instance of this class
            %   Detailed explanation goes here
            if nargin ~= 2
                error("Invalid number of arguments")
            end
            this@Simulator(varargin{1}); 
            this.test = "test";
        end
        
    end
end

