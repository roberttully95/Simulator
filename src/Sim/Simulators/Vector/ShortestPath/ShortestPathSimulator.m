classdef ShortestPathSimulator < Simulator
    %SHORTESTPATHSIMULATOR
    
    properties
        test
    end
    
    methods
        
        function this = ShortestPathSimulator(file)
            %TESTSIMULATOR Construct an instance of this class
            %   Detailed explanation goes here

            % Initialize the vector generator.
            this.init(file)
            
            
            
            this.test = "test";
        end
        
    end
end

