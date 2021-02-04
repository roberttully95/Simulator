classdef FileHandler < handle
    %FILEHANDLER Instance of the file handler class.
    
    properties
        projDir
    end
    
    properties (Dependent, Access = private)
        inputDir
        outputDir
        imagesDir
        logsDir
    end
    
    methods
        
        function this = FileHandler(dir)
            %FILE Construct instance of file class.
            this.projDir = dir;
            
            % Create directories if they do not exist.
            this.createDirs();
        end
                
        function val = get.inputDir(this)
            val = strcat(this.projDir, '\data\input');
        end
        
        function val = get.outputDir(this)
            val = strcat(this.projDir, '\data\output');
        end
        
        function val = get.imagesDir(this)
            val = strcat(this.projDir, '\images');
        end
        
        function val = get.logsDir(this)
            val = strcat(this.projDir, '\logs');
        end
    end
    
    methods (Access = public)
        
        function val = read(this, name)
            path = strcat(this.inputDir, "\", name);
            [~,~,ext] = fileparts(path);
            switch ext
                case '.json'
                    val = JSONHandler.read(path);
                otherwise
                    error('File type not supported.')
            end
            
        end
        
        function write(this, val, name)
            path = strcat(this.outputDir, "\", name);
            [~,~,ext] = fileparts(path);
            switch ext
                case '.json'
                    JSONHandler.write(val, path);
                otherwise
                    error('File type not supported.')
            end
        end
        
    end
    
    methods (Access = private)
        
        function createDirs(this)
            % CREATEDIRS Creates the required directories.
            if ~isfolder(this.inputDir)
                mkdir(this.inputDir);
            end
            if ~isfolder(this.outputDir)
                mkdir(this.outputDir);
            end
            if ~isfolder(this.imagesDir)
                mkdir(this.imagesDir);
            end
            if ~isfolder(this.logsDir)
                mkdir(this.logsDir);
            end
        end
        
    end
    
end

