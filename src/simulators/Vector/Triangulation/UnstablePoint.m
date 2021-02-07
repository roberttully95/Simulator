classdef UnstablePoint < handle
    %UNSTABLEPOINT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pos
        indices
    end
    
    properties (Dependent)
        x
        y
        iRight
        iLeft
    end
    
    methods
        
        function this = UnstablePoint(pos, indices)
            %UNSTABLEPOINT Construct an instance of the UnstablePoint
            %object.
            
            this.pos = pos;
            this.indices = indices;
        end
        
        function [index, loc] = getLeftNode(this, verts)
            
            % Get vertices
            v = verts([this.i1, this.i2], :);

            % Get angles
            th = wrapTo2Pi(atan2(v(:, 2) - this.y, v(:, 2) - this.x));
            
            % Sort angles
            [~, I] = sort(th);
            
            % Get index and point
            index = I(2);
            loc = verts(index, 1:2);
        end
        
        function [index, loc] = getRightNode(this, verts)
            
            % Get vertices
            v = verts([this.i1, this.i2], :);

            % Get angles
            th = wrapTo2Pi(atan2(v(:, 2) - this.y, v(:, 2) - this.x));
            
            % Sort angles
            [~, I] = sort(th);
            
            % Get index and point
            index = I(1);
            loc = verts(index, 1:2);
        end
        
        function x = get.x(this)
            x = this.pos(1);
        end
        
        function y = get.y(this)
            y = this.pos(2);
        end
        
        function i1 = get.iRight(this)
            i1 = this.indices(1);
        end
        
        function i2 = get.iLeft(this)
            i2 = this.indices(2);
        end
    end
    
    methods (Static)
        
        function newVals = unique(vals)
            
            % Get size
            n = size(vals, 2);
                        
            % Define new vals
            newVals = UnstablePoint.empty(0, n);
            iNew = 1;
            
            % Iterate through items
            for i = 1:n
                
                % Get object
                point = vals(i);
                
                % Determine if object is already present in new values
                present = false;
                if ~isempty(newVals)
                    for j = 1:size(newVals, 2)
                        if UnstablePoint.isEqual(point, newVals(j))
                            present = true;
                            break;
                        end
                    end
                end
                
                % If not present, add
                if ~present
                    newVals(iNew) = point;
                    iNew = iNew + 1;
                end
            end
        end
        
        function val = isEqual(obj1, obj2)
            %ISEQUAL Determines if two provided unstable points are equal.
            
            val = false;
            if isequal(obj1.pos, obj2.pos) && isequal(obj1.indices, obj2.indices)
                val = true;
            end
        end
               
    end
    
end

