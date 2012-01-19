function Model = AdaptiveHistogramTrain(X,options)
%function Model = AdaptiveHistogram(X,options);
%
%the goal is to build a histogram of the datapoints contained in X, but to
%set the bin boundaries such that, at least marginally along each feature,
%the bins will each contain the same number of points.  
%
%input a set of data X q*n where q is the number of features and n is 
% the number of samples.  
%
%outputs a set of thresholds on the input (X) e input.
%
%options:
%
%Ver = 1.0
X = double(X);
nDims = size(X,1);
nPts = size(X,2);
if(nDims > nPts)
    fprintf('error, more features than points, is that what you wanted?\n');
    Model = [];
    return;
end

defOpts.nBinsPerFeat = 10;
defOpts.nBinsMax = inf;
if(nargin < 2)
    options = [];
end
options = ResolveMissingOptions(options,defOpts);

binSpacing = nPts / (options.nBinsPerFeat);
binBoundaries = binSpacing:binSpacing:(nPts-1);
binCentroids = (binSpacing/2):(binSpacing):nPts;
Model.nFeatures = options.nBinsPerFeat ^ nDims;

for iDim = 1:nDims
    [s,si] = sort(X(iDim,:));
    Model.caBinCenters{iDim} = linInterpSample(s,binCentroids);
    Model.caBinBoundaries{iDim} = linInterpSample(s,binBoundaries);
end
    