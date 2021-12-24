clc;
clear;
resolution = input( "Pixel resolution? (Typically 120) " );
%timeSteps = input( "Number of frames? " );
%Don't need user input frames when using imported traces

trajectoryFileName = input( "Trajectory file name? (Ex. 'sampleTrajectories.mat') " );

trajectoryFile = load(trajectoryFileName);
storedVars = fieldnames(trajectoryFile);
firstVarName = storedVars{1};
trajectoryData = trajectoryFile.(firstVarName);

trajectoryDimensions = size(trajectoryData);
timeSteps = trajectoryDimensions(1);

additionalRandomFactor = normrnd(1, 0.05); %Additional randomness to simulate measurement-to-measurement variations in background

%Values taken from No_Oxyrase_Laser_10_01. Can change to user input if needed.
backgroundMean = additionalRandomFactor*0.020;
backgroundStDev = additionalRandomFactor*0.0040;

%Need to change from flat background to gaussian background if possible
backgroundNoise = normrnd(backgroundMean, backgroundStDev, resolution, resolution, timeSteps); %Generates noisy background to throw proteins into
backgroundNoise = backgroundNoise + 2*abs(min(min(min(backgroundNoise))));

%Randomly generates parameters to use for background gaussian shape
backgroundMuX = generateBackgroundMu(resolution);
backgroundMuY = generateBackgroundMu(resolution);
backgroundSigmaX = generateBackgroundSigma(resolution);
backgroundSigmaY = generateBackgroundSigma(resolution);

numOfProteins = input( strcat("Number of proteins? (Max = ", string(trajectoryDimensions(2)), ") ") );
numOfProteins = max( min(numOfProteins, trajectoryDimensions(2)), 1 );

%Values taken from No_Oxyrase_Laser_10_01. Can change to user input if needed.

%proteinMean = 0.0035 >> 0.025;
%proteinStDev = 0.0059;
proteinMean = input( "Protein SNR? " );
proteinMean = proteinMean*backgroundMean;


proteinLocations = resolution.*rand(numOfProteins, 2) + 1; %Generates random number from 1 to (resolution + 1). Need to take floor to get integer distribution

moleculeSpotSize = input( "Molecule spot size in pixels? (Typically 1.2) " );

blinkyVideo = backgroundNoise;

for nn = 1:numOfProteins
   blinkyVideo = addMoleculeToVideoUsingTrace(blinkyVideo, proteinLocations(nn,:), moleculeSpotSize, proteinMean, trajectoryData, nn);
end

blinkyVideo = makeGaussian(blinkyVideo, [backgroundMuX backgroundMuY], [backgroundSigmaX backgroundSigmaY]);

C0 = ones(resolution, resolution, 3);

fig = figure;
fig.Visible = 'off';
finalVid(timeSteps) = struct('cdata',[],'colormap',[]);

scalingFactor =  1;

for tt = 1:timeSteps
    C0(:,:,1) = scalingFactor*blinkyVideo(:, :, tt); %red
    C0(:,:,2) = scalingFactor*blinkyVideo(:, :, tt); %green
    C0(:,:,3) = scalingFactor*blinkyVideo(:, :, tt); %blue
    
    s = surf(blinkyVideo(:, :, tt), C0);
    s.EdgeColor = 'none';
    view(2)
    drawnow
    finalVid(tt) = getframe;
end

fig.Visible = 'on';
movie(finalVid,100);

%Exports blinkyVideo as TIF images
%exportToTIF(blinkyVideo)
