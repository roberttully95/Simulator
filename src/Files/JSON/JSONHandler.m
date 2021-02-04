classdef JSONHandler
    %JSONHANDLER Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Static)
        
        function mapData = read(path)
            %READ Reads a .json file into a MapData object.
            
            % Read .json file into struct
            fid = fopen(path); 
            struct_ = jsondecode(char(fread(fid, inf)'));
            fclose(fid); 
            
            % Parse struct into MapData object.
            mapData = JSONHandler.structToMapData(struct_);
        end
        
        function write(mapData, path)
            %WRITE Writes a MapData object to a .json file.
            
            % Convert to json struct
            struct_ = JSONHandler.mapDataToStruct(mapData);
            
            % Write file
            jsonString = jsonencode(struct_);
            fid = fopen(path, 'wt');
            fprintf(fid, '%s', jsonString);
            fclose(fid);
        end
    end
    
    methods (Static, Access = private)
        
        function mapdata = structToMapData(struct_)
            %STRUCTTOMAPDATA Converts a .json struct object into a mapdata
            %struct containing the border, obstacle and goal information
            %along with simulation parameters.
            
            % Copy the map-level properties.
            mapdata.properties = struct_.properties;
            
            % Init obstacles
            mapdata.Obstacles = Polygon.empty(0, 1);
            mapdata.Border = Border.empty(0, 1);
            mapdata.Goal = Circle.empty(0, 1);
            
            % Determine the number of objects.
            objects = struct_.features;
            n = size(objects, 1);

            % Parse through objects
            for i = 1:n
                obj = objects{i};
                coords = obj.geometry.coordinates;
                switch obj.type
                    case "Obstacle"
                        mapdata.Obstacles(end + 1) = Polygon(squeeze(coords));
                    case "Border"
                        mapdata.Border = Border(squeeze(coords));
                    case "Goal"
                        prop = obj.properties;
                        mapdata.Goal = Circle(coords, prop.radius);
                    otherwise
                        error("Invalid map object provided.")
                end
                
            end
        end
        
        function struct_ = mapDataToStruct(mapData)
            %MAPDATATOSTRUCT Converts a MapData object to a .json format
            %struct
            
            % Create json file
            n = size(mapData.Obstacles, 2);
            struct_(1) = struct();
            struct_.type = "Map";
            struct_.features = cell(n + 2, 1);

            % Copy properties
            struct_.properties = mapData.properties;
            
            % Init items
            for i = 1:(n + 2)
                struct_.features{i} = struct();
                struct_.features{i}.type = "";
                struct_.features{i}.geometry = struct();
            end
            
            % Insert obstacles
            for i = 1:n
                obs = mapData.Obstacles(i);
                len = obs.length;
                struct_.features{i}.type = "Obstacle";
                struct_.features{i}.geometry.type = "Polygon";
                struct_.features{i}.geometry.coordinates = reshape(obs.verts, [1, len, 2]);
            end

            % Insert Border
            border = mapData.Border;
            len = border.length;
            struct_.features{n + 1}.type = "Border";
            struct_.features{n + 1}.geometry.type = "Polygon";
            struct_.features{n + 1}.geometry.coordinates = reshape(border.verts, [1, len, 2]);

            % Insert Goal
            goal = mapData.Goal;
            struct_.features{n + 2}.type = "Goal";
            struct_.features{n + 2}.geometry.type = "Point";
            struct_.features{n + 2}.geometry.coordinates = goal.pos;
            struct_.features{n + 2}.properties = struct();
            struct_.features{n + 2}.properties.radius = goal.r;     
        end
    end
end

