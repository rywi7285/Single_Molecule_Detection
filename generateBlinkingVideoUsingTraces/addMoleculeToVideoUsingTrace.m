function [outputVideo] = addMoleculeToVideoUsingTrace(inputVideo, coordinates, diffractionSpot, brightnessMean, trajectories, currentTraj)
%addMoleculeToVideo adds a fluorescent molecule to an input video file at given xy coordinates
%   The time trace of a given coordinate is isolated from a video. Then
%   based on the protein's location, the protein's brightness, and the
%   point-spread-function of the system, the values of a pixel's time trace
%   get a random value added to them.

%diffractionSpot = 1.2;
spotSizeCheckFactor = 10;
dimensions = size(inputVideo);
outputVideo = inputVideo;
trajectoryDimensions = size(trajectories);
tempTrace = ones(1,1,trajectoryDimensions(1));

for ii = 1:trajectoryDimensions(1)
    tempTrace(1,1,ii) = trajectories(ii, currentTraj);
end

meanVal = mean(tempTrace);
tempTrace = (brightnessMean/meanVal).*tempTrace;

for ii = -spotSizeCheckFactor*diffractionSpot:spotSizeCheckFactor*diffractionSpot
    xCoord = floor(coordinates(1) + ii);
    
    if and( xCoord >= 1, xCoord <= dimensions(1) ) %Out-of-bounds check
        
        for jj = -spotSizeCheckFactor*diffractionSpot:spotSizeCheckFactor*diffractionSpot
            yCoord = floor(coordinates(2) + jj);
            
            if and( yCoord >= 1, yCoord <= dimensions(2) ) %Out-of-bounds check
                
                timeTrace = outputVideo( floor(coordinates(1) + ii), floor(coordinates(2) + jj), : ); %Isolates pixel time trace
                
                psf = exp( -((coordinates(1)-xCoord)^2 + (coordinates(2)-yCoord)^2)/(diffractionSpot^2));
                
                moleculeTrace = psf.*tempTrace; %Generates molecule time trace
                
                outputVideo( floor(coordinates(1) + ii), floor(coordinates(2) + jj), : ) = timeTrace + moleculeTrace; %Put 'em together
                
            end
        end
    end
end

end
