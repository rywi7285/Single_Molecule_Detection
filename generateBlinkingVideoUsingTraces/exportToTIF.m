function [ ] = exportToTIF(inputVid)
%Takes input greyscale and writes each frame to separate, individually
%numbered TIF file

    dimensions = size(inputVid);

    for nn = 1:dimensions(3)
        
        tempTIF = inputVid(:,:,nn);
        tempTIF = uint8(256*tempTIF);

        %Writes 3-digit number for image files
        tempVal = nn;
        fileNumber = string(mod(tempVal,10));
        tempVal = (tempVal - mod(tempVal,10))/10;
        fileNumber = strcat(string(mod(tempVal,10)), fileNumber);
        tempVal = (tempVal - mod(tempVal,10))/10;
        fileNumber = strcat(string(mod(tempVal,10)), fileNumber);

        fileName = strcat("IMAGE_", fileNumber,".tif");

        %Starts new tiff file to write frame to
        t = Tiff(fileName,'w');

        tagstruct.ImageLength = resolution;
        tagstruct.ImageWidth = resolution;
        tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
        tagstruct.BitsPerSample = 8;
        tagstruct.SamplesPerPixel = 1;
        tagstruct.RowsPerStrip = 16;
        tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
        tagstruct.Software = 'MATLAB';

        setTag(t,tagstruct)
        write(t, tempTIF);
        close(t);
    end

end

