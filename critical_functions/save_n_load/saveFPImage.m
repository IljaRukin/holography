function saveFPImage(image, filepath) 
    %-------------------------------------------
    %   Beschreibung:
    %       saveFPImage erzeugt eine FringeProcessor-Bilddatei
    %       aus einer MATLAB-Matrix. Es wird ein Standard-Header ohne
    %       Descripton geschrieben.
    %
    %   Parameter:
    %       image:      Bildmatrix
    %       filepath:   Dateiname für Ausgabedatei in Hochkomma (z.B.: 'Testdatei.fp.img')
    %
    %   Beispiel:
    %       writeFPImage(image, 'Testdatei.fp.img');
    %-------------------------------------------
    
    % Bild transponieren (siehe loadFPImage)
    image = image.';
    
    
    % Aufbau des Headers:
    %   type         : IMG_TYPE                          (8 x char) 
    %   headerLength : Länge des Headers                 (1 x uint16)
    %   dataOffset   : Offset der eigentlichen Daten     (1 x uint16)
    %   datatype     : Datentyp (byte, int, float, ...)  (1 x uint16)
    %   width        : Breite des Images                 (1 x uint32)
    %   height       : Höhe des Images                   (1 x uint32)
    %   depth        : Farbtiefe                         (1 x uint16)
    %   descripton   : Text                              ((dataOffset-headerLength) x char)
    
    magicword = [73, 77, 65, 71, 69, 49, 49, 0]; % 'IMAGE11\0';
    headerLength = 24;
    width = size(image, 2); %-----
    height = size(image, 1); %-----
    decription = '';
    dataOffset = headerLength + size(decription, 2);
    
    % Bildtyp bestimmen
    datatypeString = char(class(image));
    if isreal(image)
        %if isequal(datatypeString, 'ubit1')
        %    datatype = 2;
        %    depth = 1; % TODO nicht so einfach
        if isequal(datatypeString, 'uint8')
            datatype = 1;
            depth = 8;
        elseif isequal(datatypeString, 'uint16')
            datatype = 8;
            depth = 16;
        elseif isequal(datatypeString, 'int32')
            datatype = 16;
            depth = 32;
        elseif isequal(datatypeString, 'single')
            datatype = 32;
            depth = 32;
        elseif isequal(datatypeString, 'double')
            datatype = 1024;
            depth = 64;
        else
            error('Unknown datatype');
        end
        
    else % complex
        imageTemp = zeros(2*height, width);  % Preallocate matrix %-----
        imageTemp(1:2:end, :) = real(image); %-----
        imageTemp(2:2:end, :) = imag(image); %-----
        image = imageTemp;

        if isequal(datatypeString, 'single')
            datatype = 64;
            depth = 64;
        elseif isequal(datatypeString, 'double')
            datatype = 1088;
            depth = 128;
        else
            error('Unknown complex datatype');
        end
    end

    
    % Datei für write-Access öffnen
    fid = fopen(filepath, 'w');
    
    % Header schreiben...
    fwrite(fid, magicword, 'char');
    fwrite(fid, headerLength, 'uint16');
    fwrite(fid, dataOffset, 'uint16');
    fwrite(fid, datatype, 'uint16');
    fwrite(fid, width, 'uint32');
    fwrite(fid, height, 'uint32');
    fwrite(fid, depth, 'uint16');
    fwrite(fid, decription, 'char');
    
    % Daten schreiben
    fwrite(fid, image, datatypeString);
    
        
    % das war's    
    status = fclose(fid);
    