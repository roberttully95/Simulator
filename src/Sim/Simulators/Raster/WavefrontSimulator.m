classdef WavefrontSimulator < RasterSimulator
    %WAVEFRONTSIMULATOR
    
    % PUBLIC METHODS
    methods (Access = public)
        
        function this = WavefrontSimulator(file, sz)         
            % Initialize the raster 
            this.init(file, sz);
        end
        
    end
    
    methods (Static)
        
        function propogate(this)
            this.xLim;
            disp('propogating')
        end
        
    end
    
end

