files = cellfun(@(s) strrep(s,'response_stat_1','PSTH_matrix'),chooseParametricDataset,'UniformOutput',false);

%%

Pdata = zeros(100,64,25,numel(files));

for hh = 1:numel(files)
    load(files{hh},'PSTH_matrix');
    
    tic;
    for ii = 1:25
        P = PSTH_matrix(ii).Pdata;
        u = unique(P(:));
        Pdata(:,:,ii,hh) = P/u(2);
    end
    toc;
end

u = unique(Pdata(:));

disp(mean(abs(u-round(u))));

Pdata = reshape(round(Pdata),100,32,2,25,numel(files));

psth = squeeze(median(sum(Pdata,2),5));

%%

Adata = squeeze(Pdata(:,:,1,:,:));
Bdata = squeeze(Pdata(:,:,2,:,:));

%%

llfun = convPredictionFunMLE('exp',zeros(1,4),[],false);
params = [0.0392    0.3325    1.8700    0.0840];
[params,nll] = fminsearch(llfun,params,[],Bdata,Adata);

%%

[~,lambdas,kernel] = llfun(params,Bdata,Adata);

Bfull = rot90(reshape(squeeze(median(sum(Bdata,2),4))',5,5,100),2);
Afull = rot90(reshape(squeeze(median(sum(Adata,2),4))',5,5,100),2);
lambdasFull = rot90(reshape(lambdas',5,5,100),2);

plotConvPrediction(gcf,lambdasFull,Bfull,Afull);

%%

lb = [              ...
    0               ... decay rate: setting this to zero turns the exponential into a constant
    1/numel(Adata)  ... scale: e^-x <= 1, so this is roughly in units of events per bin.  We expect to have recorded at least one spike in all of our experiments.
    0               ... threshold: 0 implies no threshold
    0               ... baseline: zero baseline
    ];

ub = [              ...
    745.1335        ... decay rate: within the limits of Matlab's numerical precision, this turns the exponential into a delta
    50*32*10        ... scale: e^-x <= 1, so this is roughly in units of events per bin.  Assuming 50 trials, this implies every channel recording 10 units firing at 1000Hz or 1 unit at 10000Hz, both of which are implausibly high
    50*32           ... threshold: again, assuming 50 trials, this would basically suppress all realistic firing rates
    50*32           ... baseline: constant firing
    ];

plb = [             ...
    0               ... decay rate: setting this to zero turns the exponential into a constant
    1/numel(Adata)  ... scale: e^-x <= 1, so this is roughly in units of events per bin.  We expect to have recorded at least one spike in all of our experiments.
    0               ... threshold: 0 implies no threshold
    0               ... baseline: zero baseline
    ];

pub = [             ...
    7               ... decay rate: exp(-7) ~= 0.001, so this basically turns it into a delta
    50*32/10        ... scale: e^-x <= 1, so this is roughly in units of events per bin.  Assuming 50 trials, this gives a plausible upper bound of 100Hz per channel
    50*32/100       ... threshold: again, assuming 50 trials, this suppresses anything less than 10 subtreshold events per second per channel
    50*32/10        ... baseline: constant firing
    ];

params = [0.0392    0.3325    1.8700    0.0840];
[paramsB,nllB] = bads(@(p) llfun(p,Bdata,Adata),params,lb,ub,plb,pub);

%%

[~,lambdasB,kernelB] = llfun(paramsB,Bdata,Adata);

BfullB = rot90(reshape(squeeze(median(sum(Bdata,2),4))',5,5,100),2);
AfullB = rot90(reshape(squeeze(median(sum(Adata,2),4))',5,5,100),2);
lambdasFullB = rot90(reshape(lambdasB',5,5,100),2);

plotConvPrediction(gcf,lambdasFullB,BfullB,AfullB);