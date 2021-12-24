function [mu] = generateBackgroundMu(res)
%generateBackgroundMu generates a random value for background gaussian mean
%Generates a random value normally distributed about the center of the
%picture frame.
mu = normrnd(0.5*res, 0.1*res);
end

