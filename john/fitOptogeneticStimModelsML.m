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

llfun = convPredictionFunMLE('exp');
params = [0.0312804196921670,0.481035840104781,0.355275333982948,0.0167378556450644];
[params,nll] = fminsearch(llfun,params,[],Bdata,Adata);

%%

convPredictionExp(params,reshape(squeeze(psth(:,1,:))',5,5,100),reshape(squeeze(psth(:,2,:))',5,5,100));