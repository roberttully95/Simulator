classdef TriangulationSimulator < VectorSimulator
    %TRIANGULATIONSIMULATOR
    
    properties
        borderUnstablePoints
        triangles
    end
    
    methods
        
        function this = TriangulationSimulator(file)
            %TRIANGULATIONSIMULATOR Construct an instance of this class
            %   Detailed explanation goes here

            % Initialize the vector generator.
            this.init(file)
            
            % Get unstable points.
            this.borderUnstablePoints = getBorderUnstablePoints(this.verts, this.weights, this.edges);
            
            % Generate the trangulation from the border unstable points.
            this.triangles = triangulate(this.borderUnstablePoints, this.verts, this.shortestPath, this.Goal);
        end
        
        function plotMap(this, ax)
            
            % Call vector plotting function
            plotMap@VectorSimulator(this, ax);
            
            % Plot triangles
            for i = 1:size(this.triangles, 2)
                this.triangles(i).plot(gca, 'g');
                v = this.triangles(i).centroid;
                arrows(ax, v(1), v(2), 1, 90 - atan2(this.triangles(i).Dir(2), this.triangles(i).Dir(1)) * (180 / pi))
            end
        end
        
    end
end

