function image = loadFPImage(file)
    %-------------------------------------------
    %   Beschreibung:
    %       loadFPImage liest FringeProcessor-Float-Dateien ein
    %       und importiert diese als MATLAB-Matrix.
    %   Parameter:
    %       file:	Name der einzulesenden Datei (string)
    %               Wird dieser leer gelassen öffnet die GUI
    %
    %   Beispiel:
    %       Image = loadFPImage('D:\Daten\Test.flt');
    %-------------------------------------------
    %
    %   edited by Martin Prinzler 2018-10-24
    %       - logical loading (fixed workaround)
    %   edited by Martin Prinzler 2016-11-08
    %       - added validation of filename
    %       - added import of filename
    %   Originial from BIAS
    
    if ~nargin
        [fileName,fileDir] = uigetfile('.fpimg','FPImage auswählen');
        file = [fileDir,fileName];
        clear fileName fileDir
    end
    
    % Datei für read-Access öffnen
    fid = fopen(file, 'r');
    
    if fid == -1
        throwAsCaller(MException('loadFPImage:fopen:file',...
            'loadFPImage couldn''t open file:\n%s',file));
    end
    
    
    % Header auswerten:
    % Aufbau des Headers:
    %   type         : IMG_TYPE                          (8 x char)
    %   headerLength : Länge des Headers                 (1 x uint16)
    %   dataOffset   : Offset der eigentlichen Daten     (1 x uint16)
    %   datatype     : Datentyp (byte, int, float, ...)  (1 x uint16)
    %   width        : Breite des Images                 (1 x uint32)
    %   height       : Höhe des Images                   (1 x uint32)
    %   depth        : Farbtiefe                         (1 x uint16)
    %   descripton   : Text                              ((dataOffset-headerLength) x char)
    magicword    = fread(fid, 8, '*char'); %#ok<NASGU>
    headerLength = fread(fid, 1, 'uint16');
    dataOffset   = fread(fid, 1, 'uint16');
    datatype     = fread(fid, 1, 'uint16');
    width        = fread(fid, 1, 'uint32');
    height       = fread(fid, 1, 'uint32');
    depth        = fread(fid, 1, 'uint16');
    descriptorLength = dataOffset - headerLength;
    descriptor   = fread(fid, descriptorLength, '*char'); %#ok<NASGU>

    %% Einlesen der Bildmatrix
    
    if datatype == 1088 && depth == 128     % complex<double>
        imageReal = fread(fid, [height, width], '*double', 8);
        fseek(fid, dataOffset + 8, 'bof');
        imageImag = fread(fid, [height, width], '*double', 8);
        image = imageReal + 1i*imageImag;
        
    elseif datatype == 64 && depth == 64    % complex<float>
        imageReal = fread(fid, [height, width], '*float', 4);
        fseek(fid, dataOffset + 4, 'bof');
        imageImag = fread(fid, [height, width], '*float', 4);
        image = imageReal + 1i*imageImag;
        
    elseif datatype == 1024 && depth == 64  % double
        image = fread(fid, [height, width], '*double');
        
    elseif datatype == 32 && depth == 32    % float
        image = fread(fid, [height, width], '*float');
        
    elseif datatype == 16 && depth == 32    % int
        image = fread(fid, [height, width], '*int32');
        
    elseif datatype == 8 && depth == 16     % short
        image = fread(fid, [height, width], '*uint16');
        
    elseif datatype == 1 && depth == 8      % byte
        image = fread(fid, [height, width], '*uint8');
        
    elseif datatype == 2 && depth == 1      % boolean (bit mask)
        %% Special bool handling
        %   make shure images are on an 8 Bit Grid
        roundedWidth = 8 * ceil(height/8);
        imageTemp = fread(fid, [roundedWidth, width], '*ubit1');
        image = imageTemp;
        %   flip order of bytes
        %   maybe the FringeProcessor is crazy?
        for k = 1:8
            image((9-k):8:roundedWidth,:) = imageTemp(k:8:roundedWidth,:);
        end
        image = logical(image(1:height,:));
        
    else
        error('Unable to read file');
    end
    
    
    image = image.';    % Transponieren
    % (weil MATLAB Zeilen und Spalten 'andersrum' indiziert als der Fringe Processor in Bildern)
    
    
    %Schließen der Datei
    status = fclose(fid); %#ok<NASGU>
    
end
