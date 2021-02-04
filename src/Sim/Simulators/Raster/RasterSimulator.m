classdef (Abstract) RasterSimulator < Simulator
    %RASTERSIMULATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = protected)
        map
        nRows
        nCols
        obsLocs
    end
    
    properties (Dependent, Access = protected)
        xRes
        yRes
    end
    
    methods
        
        function init(this, file, sz)
            
            % Init simulator.
            init@Simulator(this, file);
            
            % Rasterize the map
            this.nRows = sz(1);
            this.nCols = sz(2);
            this.rasterize();
        end
            
        function plotMap(this, ax)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            % Setup axis
            cla(ax)
            bounds = this.Border.bounds;
            ax.XLim = [bounds.xMin, bounds.xMax];
            ax.YLim = [bounds.yMin, bounds.yMax];
            ax.DataAspectRatio = [1, 1, 1];
            hold(ax , 'on');
                        
            % Plot Obstacles
            scatter(ax, this.obsLocs(:, 1), this.obsLocs(:, 2), 'r', '*');
        end
    end
    
    methods (Access = protected)
        
        function rasterize(this)
            %RASTERIZE Takes the obstacles and generates a rasterized
            % occupancy map.

            % Get x and y
            x = ((1:this.nCols) - 0.5)*this.xRes;
            y = ((1:this.nRows) - 0.5)*this.yRes;

            % Create list of coordinates
            list = NaN(this.nRows * this.nCols, 2);
            for r = 1:this.nRows
                for c = 1:this.nCols
                    list(1 + (r - 1)*this.nCols + (c - 1), :) = [x(c), y(r)];
                end
            end
            remList = list;
            
            % Iterate through polygons
            for p = 1:size(this.Obstacles, 2)
                i = this.Obstacles(p).containsPt(remList);
                remList(i, :) = [];
            end
            
            % List of items in polygon is difference
            this.obsLocs = setdiff(list, remList, 'rows');
            
            % Create map
            this.map = zeros(this.nRows, this.nCols);
            for i = 1:size(this.obsLocs, 1)
                r = this.obsLocs(i, 2)/this.yRes + 0.5;
                c = this.obsLocs(i, 1)/this.xRes + 0.5;
                this.map(r, c) = 1;
            end
        end
    end
    
    % GETTERS
    methods
        
        function val = get.xRes(this)
            val = (this.Border.bounds.xMax - this.Border.bounds.xMin) / this.nCols;
        end
        
        function val = get.yRes(this)
            val = (this.Border.bounds.yMax - this.Border.bounds.yMin) / this.nRows;
        end
    end
end

