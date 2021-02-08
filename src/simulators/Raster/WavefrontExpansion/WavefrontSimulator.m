classdef WavefrontSimulator < RasterSimulator
    %WAVEFRONTSIMULATOR
    
    properties
        vectorField
        costMap
    end
    
    % PUBLIC METHODS
    methods (Access = public)
        
        function this = WavefrontSimulator(file, ax, sz)         
           
            % Initialize the raster 
            this.init(file, ax, sz);
            
            % Get the vector field
            [this.vectorField, this.costMap] = wavefrontExpansion(this.goalIndex, this.map);
        end
        
    end
    
    methods
        
        function plotVectorField(this, ax)
            
            % Create list of arrow
            arrowList = NaN(this.nRows * this.nCols, 4);
            
            % Iterate through cells.
            i = 1;
            for r = 1:this.nRows
                for c = 1:this.nCols
                    arrowList(i, :) = [(c - 0.5)*this.xRes, (r - 0.5)*this.yRes, this.xRes, this.vectorField(r, c)];
                    i = i + 1;
                end
            end
            
            % Plot arrows
            arrows(ax, arrowList(:, 1), arrowList(:, 2), arrowList(:, 3), 90 - arrowList(:, 4) * 180 / pi)
        end
        
    end
    
    methods (Static)
        
        function propogate(this)
            this.xLim;
            disp('propogating')
        end
        
        
        
    end
    
end

