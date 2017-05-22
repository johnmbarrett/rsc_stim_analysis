function parametricAnalysis01
% parametricAnalysis01
% 
% operates on 100x25 arrays of vectors from the parametric 5x5 data sets,
%     where each vector is the projection of a single histogram
%
% gs 2016-07-15
% --------------------------------------

% USER SETTINGS
dataset = 'ortho_aav9';
probeNum = 2; % 1 for probe 1, or 2 for probe 2
%
meanFlag = 0; % 0, or 1 to show avg in addition to all traces
semFlag = 0; % 0, or 1 to show +/- sem in addition to all traces
medianFlag = 1; % 0, or 1 to show median (if meanFlag=0)

% CHOOSE DATA SET
% path1 = 'C:\_Manuscripts\Current\ACTIVE\2016 xiaojian in vivo\matlab etc\RSC-dmFC\';
path1 = 'C:\_Data\Xiaojian\RSC-dmFC\';
switch dataset
    case 'ortho_aav1' 
        names = { 
%             '20151027-RSC-dmFC\AP0.6\response_stat_1'; % comment if probeNum = 2
%             '20151105-RSC-dmFC\AP0.6\response_stat_1'; % ditto
            '20151201-RSC-dmFC\ArBrs\response_stat_1';
            '20151204-RSC-dmFC\ArBrs_1\response_stat_1';
            '20151211-RSC-dmFC\ArBrs\response_stat_1';
            '20151217-RSC-dmFC\ArBrs\response_stat_1';
            '20151221-RSC-dmFC\ArBrs\response_stat_1';
            '20151223-RSC-dmFC\ArBrs\response_stat_1';
            };
    case 'anti_aav1' 
        names = {
            '20151204-RSC-dmFC\ArsBr_1\response_stat_1';
            '20151211-RSC-dmFC\ArsBr\response_stat_1';
            '20151217-RSC-dmFC\ArsBr\response_stat_1';
            '20151221-RSC-dmFC\ArsBr\response_stat_1';
            '20151223-RSC-dmFC\ArsBr\response_stat_1';
            };
    case 'ortho_aav9' 
        names = { 
            '20160427-RSC-dmFC_drug\ArBrs_1\response_stat_1';
            '20160517-RSC-dmFC_drug\ArBrs\response_stat_1';
            '20160524-RSC-dmFC\ArBrs\response_stat_1';
            '20160527-RSC-dmFC_drug\ArBrs\response_stat_1';
            '20160601-RSC-dmFC_control\ArBrs\response_stat_1';
            '20160608-RSC-dmFC_control\ArBrs\response_stat_1';
            };
    case 'anti_aav9' 
        names = {
            '20160427-RSC-dmFC_drug\ArsBr\response_stat_1';
            '20160517-RSC-dmFC_drug\ArsBr\response_stat_1';
            '20160524-RSC-dmFC\ArsBr\response_stat_1';
            '20160527-RSC-dmFC_drug\ArsBr\response_stat_1';
            '20160601-RSC-dmFC_control\ArsBr\response_stat_1';
            '20160608-RSC-dmFC_control\ArsBr\response_stat_1';
            };
    case 'ortho_aav9_muscimol'
        names = {
            '20160427-RSC-dmFC_drug\AdrBrs_1\response_stat_1';
            '20160517-RSC-dmFC_drug\AdrBrs\response_stat_1';
            '20160527-RSC-dmFC_drug\AdrBrs\response_stat_1';
            };
    case 'ortho_aav9_muscimol_pre'
        names = {
            '20160427-RSC-dmFC_drug\ArBrs_1\response_stat_1';
            '20160517-RSC-dmFC_drug\ArBrs\response_stat_1';
            '20160527-RSC-dmFC_drug\ArBrs\response_stat_1';
            };
    case 'ortho_aav9_saline'
        names = {
            '20160601-RSC-dmFC_control\AcrBrs\response_stat_1';
            '20160608-RSC-dmFC_control\AcrBrs\response_stat_1';
            };
    case 'ortho_aav9_saline_pre'
        names = {
            '20160601-RSC-dmFC_control\ArBrs\response_stat_1';
            '20160608-RSC-dmFC_control\ArBrs\response_stat_1';
            };
end

% LOAD DATA
for n=1:numel(names)
    load([path1 names{n}], 'Tm_Par_P');
    traces(:,:,n) = Tm_Par_P(:,:,probeNum);
end
x = -19.5:1:79.5;

% FIGURE - plots with all traces
figure('Name', [dataset '; probe ' num2str(probeNum)], 'NumberTitle','off')
rows = 5; cols = 5; plotN = 0;
for n = 1:rows*cols; plotN = plotN + 1; subplot(rows, cols, plotN); end
plotN = 0;
for n = 1:rows*cols
    plotN = plotN + 1; subplot(rows, cols, plotN)
    y = squeeze(traces(:,n,:)); % e.g. 100 by 6
    hplot = plot(x, y);
    if meanFlag 
        set(hplot, 'Color', 0.8*[1 1 1]); hold on;
        if semFlag
            errorbar(x, mean(y'), std(y')/sqrt(size(y,2)))
        elseif ~semFlag
            plot(x, mean(y'))
        end
    elseif medianFlag
        set(hplot, 'Color', 0.8*[1 1 1]); hold on;
        plot(x, median(y'))
    end
end
% re-scale all y-axes
h = findobj(get(gcf, 'Children'), 'Type', 'axes');
set(h(:), 'YLim', [0 max(max(max(traces)))], 'XLim', [-20 80])
boxesOff; tickDirOut;

% return




% OPTIONAL FIGURE -- simple matrix representation
figure('Name', [dataset '; probe ' num2str(probeNum)], 'NumberTitle','off')

subplot(1,2,1)
intensities_norm = [.2 .4 .6 .8 1];
durations_norm = [1 5 10 20 50]/50;
stimArray = intensities_norm' * durations_norm;
imagesc(stimArray)
axis image

subplot(1,2,2)
for n = 1:rows*cols
    y = squeeze(traces(:,n,:)); % e.g. 100 by 6
    if meanFlag 
        Y(n) = sum(mean(y'));
    elseif medianFlag
        Y(n) = sum(median(y'));
    end
end
Y = reshape(Y, 5, 5);
imagesc(Y');
axis image
boxesOff; tickDirOut;
colormap(jet3(256));

