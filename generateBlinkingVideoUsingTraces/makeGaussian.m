function [outputVideo] = makeGaussian(inputVideo, mu, sigma)
%makeGaussian takes a video of background noise and makes it gaussian
%   This function takes in an input video of dimensions MxNxT and a mean
%   and standard deviation of dimension 2. Based on the x and y mean and
%   standard deviation, a gaussian shape is created and used to multiply
%   the background noise values to get a proper shape
outputVideo = inputVideo;
dimensions = size(outputVideo);

for ii = 1:dimensions(1)
   for jj = 1:dimensions(2)
       pixelTrace = outputVideo(ii,jj,:);
       gaussian = exp( -( (mu(1)-ii)^2/(2*sigma(1)^2) + (mu(2)-jj)^2/(2*sigma(2)^2) ) );
       outputVideo(ii,jj,:) = gaussian*pixelTrace;
   end
end

end

