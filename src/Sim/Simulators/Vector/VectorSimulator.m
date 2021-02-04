classdef VectorSimulator < Simulator
    %VECTORSIMULATOR
    
    properties
        Property1
    end
    
    methods (Access = protected)
        
        function this = VectorSimulator(varargin)
            %VECTORSIMULATOR
            this@Simulator(varargin{1}); 
        end
        
        function plotMap(this, ax)
            %PLOTMAP Plots the map in which the simulation occurs.
            
            % Setup axis
            cla(ax);
            bounds = this.Border.bounds;
            ax.XLim = [bounds.xMin, bounds.xMax];
            ax.YLim = [bounds.yMin, bounds.yMax];
            ax.DataAspectRatio = [1, 1, 1];
            hold(ax , 'on');
            
            % Plot Obstacles
            for i = 1:size(this.Obstacles, 2)
                this.Obstacles(i).plot(ax, 'k');
            end
            
            % Plot Goal
            this.Goal.plot(ax , 'r');       
        end
    end
end

