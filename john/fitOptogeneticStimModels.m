files = chooseParametricDataset;

%%

allTraces = cellfun(@(s) s.Tm_Par_P,cellfun(@(f) load(f,'Tm_Par_P'),files,'UniformOutput',false),'UniformOutput',false);
allTraces = cat(4,allTraces{:});

medianTraces = median(allTraces,4);

%%

nProbes = size(medianTraces,3);
nConditions = size(medianTraces,2);

rows = ceil(sqrt(nConditions));
cols = ceil(nConditions/rows);

for ii = 1:nProbes
    figure;
    
    for jj = 1:nConditions
        subplot(rows,cols,jj);
        plot(squeeze(allTraces(:,jj,ii,:)),'Color',[0.5 0.5 0.5]);
        hold on;
        plot(medianTraces(:,jj,ii),'Color','r','LineWidth',2);
    end
end

%% ARRANGE DATA
% GS's & KK's original version pulled these out of a figure with 5x5
% subplots plotted in column-major order, extracted using findobj (which
% returns most recent last), then reshaped.  Rotating through 180 degrees
% reverses this transformation.
Afull = rot90(reshape(medianTraces(:,:,1)',rows,cols,size(medianTraces,1)),2);
Bfull = rot90(reshape(medianTraces(:,:,2)',rows,cols,size(medianTraces,1)),2);

%% FIT GAMMA MODEL

initialParams = [0.8726    0.0392    0.9325    1.8700    0.0840];
predFunGamma = convPredictionFun('gamma');
[optimisedParamsGamma,deviationGamma] = fminsearch(predFunGamma,initialParams,[],Bfull,Afull);

%%

convPrediction2(optimisedParamsGamma,Bfull,Afull);
[~,predictionsGamma,kernelGamma] = predFunGamma(optimisedParamsGamma,Bfull,Afull);

plotConvPrediction(predictionsGamma,Bfull,Afull);

%% FIT EXPONENTIAL MODEL

initialParams = [0.0392    0.9325    1.8700    0.0840];
predFunExp = convPredictionFun('exp');

[optimisedParamsExp,deviationExp] = fminsearch(predFunExp,initialParams,[],Bfull,Afull);

%%
% optimisedParamsExp=[0.0315    0.6822    0.3582    0.03];

% convPredictionExp(optimisedParamsExp,Bfull,Afull);
[~,predictionsExp,kernelExp] = predFunExp(optimisedParamsExp,Bfull,Afull);
plotConvPrediction(predictionsExp,Bfull,Afull);

%% FIT EXPONENTIAL MODEL WITH ADAPTATION

optimisedParamsExpAdapt = [0.0511    6.7144    8.4181    0.044   0.1261 -2];
predFunExpAdapt = convPredictionFunAdapt('exp');
%%
[optimisedParamsExpAdapt,deviationExpAdapt] = fminsearch(predFunExpAdapt,optimisedParamsExpAdapt,[],Bfull,Afull);

%%
%optimisedParamsExpAdapt=[0.0511    6.7144    8.4181    0.044   0.1261 -2];

% convPredictionExp(optimisedParamsExp,Bfull,Afull);
[score,predictionsExpAdapt,kernelExpAdapt] = predFunExpAdapt(optimisedParamsExpAdapt,Bfull,Afull);

plotConvPrediction(gcf,predictionsExpAdapt,Bfull,Afull);

%% FIT EXPONENTIAL MODEL TO SUMMED DATA

initialParams = optimisedParamsExp;
predFunExpSum = convPredictionFun('exp',[],[],false,true);
[optimisedParamsExpSum,deviationExpSum] = fminsearch(predFunExpSum,initialParams,[],Bfull,Afull);

%%

convPredictionExp(optimisedParamsExpSum,Bfull,Afull);
[~,predictionsExpSum,kernelExpSum] = predFunExpSum(optimisedParamsExpSum,Bfull,Afull);

plotConvPrediction(predictionsExpSum,Bfull,Afull);

%% FIT DOUBLE EXPONENTIAL MODEL

initialParams = [0.8726    0.0392    0.9325    1.8700    0.0840];
predFunDExp = convPredictionFun(@(p,x) (1-exp(-p(1)*x)).*exp(-p(2)*x));

[optimisedParamsDExp,deviationDExp] = fminsearch(predFunDExp,initialParams,[],Bfull,Afull);

%%

[~,predictionsDExp,kernelDExp] = predFunDExp(optimisedParamsDExp,Bfull,Afull);

plotConvPrediction(predictionsDExp,Bfull,Afull);

%%

toSavePrefixes = {'optimisedParams','deviation','predictions','kernel'};
toSaveSuffixes = {'Gamma' 'Exp' 'DExp'};

toSave = cell(numel(toSavePrefixes),numel(toSaveSuffixes));

for ii = 1:numel(toSavePrefixes)
    for jj = 1:numel(toSaveSuffixes)
        toSave{ii,jj} = [toSavePrefixes{ii} toSaveSuffixes{jj}];
    end
end

saveFile = uiputfile('*.mat','Save fits','Z:\LACIE\DATA\Xiaojian\ephys\e-ephys\AnalyzedData\RSC-M2');

if exist(saveFile,'file')
    toSave = {'-append' toSave{:}};
end

save(saveFile,toSave{:});

%%

C = generateStimulusArray;

%% FIT ADAPTER MODEL TO STIMULUS

optimisedParamsAdapt = [ 0.0   0.02    -3.5    0.5];
[optimisedParamsAdapt,deviationAdapt] = fminsearch(@convPredictionAdaptFast,optimisedParamsAdapt,[],C,Bfull);

%optimisedParamsAdapt=
[~,predictionsAdapt,kernelAdapt] = convPredictionAdaptFast(optimisedParamsAdapt,C,Bfull);
%%
figure
for ii = 1:5
    for jj = 1:5
        subplot(5,5,(ii-1)*5+jj);
        hold on
        plot(1:100,10*squeeze(C(ii,jj,:)),1:100,squeeze(Bfull(ii,jj,:)),1:100,squeeze(predictionsAdapt(ii,jj,:)));
    end
end

%%
save(saveFile,'-append','optimisedParamsAdapt','deviationAdapt','predictionsAdapt','kernelAdapt');
%%

convPredictionAdapt(optimisedParamsAdapt,C,Bfull);

%% FIT ALPHA FUNCTION MODEL TO STIMULUS

% initialParams = [1e2   1e-3    3    1000    1.8700    0.0840];
% predFunAlpha = convPredictionFun(@(p,x) (x>=p(3)).*(1-exp(-p(1)*(x-p(3)))).*exp(-p(2)*(x-p(3))),0);
% 
% [optimisedParamsAlpha,deviationAlpha] = fminsearch(predFunAlpha,initialParams,[],C,Bfull);
% 
% [~,predictionsAlpha,kernelAlpha] = predFunAlpha(optimisedParamsAlpha,C,Bfull);
% 
% plotConvPrediction(predictionsAlpha,3*bsxfun(@times,bsxfun(@rdivide,C,max(C,[],3)),max(Bfull,[],3)),Bfull);