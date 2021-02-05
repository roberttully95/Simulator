classdef (Abstract) RasterSimulator < Simulator
    %RASTERSIMULATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        map
        nRows
        nCols
        
        obsLocs
        goalLocs
        
        goalIndex
    end
    
    properties (Dependent)
        xRes
        yRes
    end
    
    methods
        
        function init(this, file, sz)
            %INIT Initializes the raster simulator.
            
            % Init simulator.
            init@Simulator(this, file);
            
            % Rasterize the map
            this.nRows = sz(1);
            this.nCols = sz(2);
            this.rasterize();
            
            % Set goal index
            r = floor(this.Goal.y/this.yRes);
            c = floor(this.Goal.x/this.xRes);
            this.goalIndex = [r, c];
        end
            
        function plotMap(this, ax)
            %PLOTMAP Plots the map in which the simulation occurs.
            
            % Setup axis
            cla(ax)
            bounds = this.Border.bounds;
            ax.XLim = [bounds.xMin, bounds.xMax];
            ax.YLim = [bounds.yMin, bounds.yMax];
            ax.DataAspectRatio = [1, 1, 1];
            hold(ax , 'on');
                
            % Label Axes
            xlabel(ax, "x (meters)");
            ylabel(ax, "y (meters)");

            % Make Title
            title(ax, "Obstacle Map");

            % Plot Obstacles & Goal
            scatter(ax, this.obsLocs(:, 1), this.obsLocs(:, 2), 'k', '*');
            scatter(ax, this.goalLocs(:, 1), this.goalLocs(:, 2), 'r', '*');
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
            notObsList = list;
            notGoalList = list;
            
            % Iterate through polygons
            for p = 1:size(this.Obstacles, 2)
                i = this.Obstacles(p).containsPt(notObsList);
                notObsList(i, :) = [];
            end
            
            % Do goal
            pGoal = Polygon(polybuffer(this.Goal.pos, 'points', this.Goal.r));
            i = pGoal.containsPt(notGoalList);
            notGoalList(i, :) = [];
            
            % List of items in polygon is difference
            this.obsLocs = setdiff(list, notObsList, 'rows');
            this.goalLocs = setdiff(list, notGoalList, 'rows');
            
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

