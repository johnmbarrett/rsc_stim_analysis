function fun = convPredictionFunMLE(kernelFun,lower,upper,isPlot)
% Functional version of Konrad's function for convolving the upstream 
% responses to the downstream responses using a gamma distribution,
% allowing an arbitrary kernel function to be used.
%
% kernelFun: a function handle for generating the convolution kernel, must
% take a list of parameters as its first arguments and a vector
% representing time as its second.  Alternatively, you may specify the
% string 'exp' for an exponential distribution with one parameter or
% 'gamma' for a function of the form x.^a.*e.^(-b*x) (which is not,
% strictly speaking, a gamma distribution).
%
% Returns:
% A function to be used for predicting downstream responses (e.g. in M2)
% from responses to optogenetic stimulation of an upstream area (e.g. RSC).
% The function takes the following arguments:
%
% params: a vector of parameters for the fit.  The first n parameters are
% for the kernel, the n+1th parameter is a scaling factor, the n+2th the
% minimum, and the n+3th the offset
% Bfull: 5x5x100 upstream data array; e.g. median RSC responses to RSC stim
% deviation: used to optimize the fit
% Afull: 5x5x100 downstream data array; e.g. median M2 responses to RSC stim
% 
% The function returns the deviation of the predicted response from the
% recorded response, the predicted response itself, and the kernel used to
% generate the prediction
%
% Usage: e.g.
% (1) run fitOptogeneticStimModels to generate the Afull and Bfull arrays
% (2) call this function from the command line:
% paras=[0.8726    0.0392    0.9325    1.8700    0.0840]; % AAV9 ortho
% paras=[1.0523    0.0421    0.8047    0.7867    0.0605]; % AAV1 ortho
% paras=fminsearch(convPredictionFun('exp',paras,[],Bfull,Afull) % or 'gamma' or any function handle
% 
% See also: 
% parametricAnalysis04 -- generates the figure with the 5 x 5 array 
% of subplots with blue traces, used for the fits here
% 
% 2017 may
    if ischar(kernelFun)
        switch kernelFun
            case 'exp'
                kernelFun = @(p,x) exp(-p(1)*x);
            case 'gamma'
                kernelFun = @(p,x) x.^(p(1)-1).*exp(-p(2)*x);
            otherwise
                error('Unknown kernel function %s\n',kernelFun);
        end
    end
    
    if nargin < 2 || isempty(lower)
        lower = -Inf;
    end
    
    if nargin < 3 || isempty(upper)
        upper = Inf;
    end
    
    if nargin < 4
        isPlot = false;
    elseif isPlot
        fig = figure;
    end
    
    assert(isa(kernelFun,'function_handle'),'First argument must be a function handle'); % TODO : validate order of params and x as well?
    
    function [negativeLogLikelihood,lambdas,kernel] = convPrediction(params,Bfull,Afull)
        if any(params < lower | params > upper)
            negativeLogLikelihood = Inf;
            lambdas = NaN;
            kernel = NaN;
            return
        end
        
        x = 1:100;

        kernel = kernelFun(params,x);
        kernel = kernel/sum(kernel);

        negativeLogLikelihood = 0;

        lambdas = zeros(size(Afull,1),size(Afull,3));

        % TODO : introduce dim argument so arrays can be arbitrary shape
        for ii = 1:25
            Bpsth = squeeze(median(sum(Bfull(:,:,ii,:),2),4)); %*1e3; % Bpsth is in units of total events, so divide by bin width to get it in terms of events per second
            lambda = max(0,conv2(Bpsth,kernel')*params(end-2)-params(end-1))+params(end);
            lambda = lambda(1:100);
            lambdas(:,ii) = lambda;
            spikeTerm = log(bsxfun(@times,lambda,Afull(:,:,ii,:))); % Afull remains in units of spikes because we are effectively using it as a logical index, except due to the way Xiaojian analyses the data there can be more than one spike per bin
            spikeTerm = spikeTerm/50; % mean over trials???? for ortho_aav9 max(Afull(:)) == 46 and there's no way one unit fired that many spikes in a single bin
            spikeTerm(isinf(spikeTerm)) = 0;
            negativeLogLikelihood = negativeLogLikelihood - mean(reshape(sum(spikeTerm,1),size(Afull,2)*size(Afull,4),1)) + trapz((1:100)'/1e3,lambda);
        end

        if isPlot % TODO
            if ~isgraphics(fig) % restore the figure if the user closes it
                fig = figure;
            end
            
            Bfull2 = rot90(reshape(squeeze(median(sum(Bfull,2),4))',5,5,100),2);
            Afull2 = rot90(reshape(squeeze(median(sum(Afull,2),4))',5,5,100),2);
            lambdas2 = rot90(reshape(lambdas',5,5,100),2);

            plotConvPrediction(fig,lambdas2,Bfull2,Afull2);
            drawnow;
        end

        negativeLogLikelihood = negativeLogLikelihood/25;

        disp(negativeLogLikelihood);
        disp(params);
    end
    
    fun = @convPrediction;
end