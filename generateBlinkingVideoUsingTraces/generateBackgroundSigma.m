function [sigma] = generateBackgroundSigma(res)
%generateBackgroundSigma generates a random value for background gaussian
%standard deviation
%Generates a random value normally distributed about the typical gaussian width.
sigma = normrnd(0.65*res, 0.1*res);
end

