function data = parametricAnalysis02(ortho_or_anti, paramCombo)
% parametricAnalysis02
% 
% This version performs the analysis of the ortho-/antidromic expts (Fig 2, 4)
% 
% ortho_or_anti: either 'ortho' (default) or 'anti'
% paramCombo: integer from 1 to 25 corresponding to a particular pair 
%   of stimulus duration/intensity values in the 5 by 5 matrix; 
%   default is 23, corresponding to the 10-ms/100% combo
%
% see also: parametricAnalysis03
%
% gs 2016-08-05; 2017-05-01
% --------------------------------------
if nargin == 0;
    ortho_or_anti = 'ortho';
    paramCombo = 23;
end
% user settings:
% path1 = 'C:\_Manuscripts\Current\ACTIVE\1_2017 xiaojian in vivo RSC-M2\matlab etc\RSC-dmFC\';
path1 = 'C:\_Data\Xiaojian\RSC-dmFC\';
meanFlag = 0; % 0, or 1 to show avg in addition to all traces
semFlag = 0; % 0, or 1 to show +/- sem in addition to all traces
medianFlag = 1; % 0, or 1 to show median (if meanFlag=0)

figure;
x = -19.5:1:79.5;
timeOffset = min(x)-1;
rows = 2; cols = 5; 

% ---------------------- AAV1 data -----------------------------
names = getNames([ortho_or_anti '_aav1']);
traces_P1 = []; traces_P2 = [];
for n=1:numel(names)
    load([path1 names{n}], 'Tm_Par_P');
    traces_P1(:,:,n) = Tm_Par_P(:,:,1);
    traces_P2(:,:,n) = Tm_Par_P(:,:,2);
end

subplot(rows, cols, 1) % ortho, RSC end (probe 2)
y_P2 = squeeze(traces_P2(:,paramCombo,:)); % e.g. 100 by 6
hplot = plot(x, y_P2);
if meanFlag
    set(hplot, 'Color', 0.8*[1 1 1]); hold on;
    if semFlag
        errorbar(x, mean(y_P2'), std(y_P2')/sqrt(size(y_P2,2)))
    elseif ~semFlag
        plot(x, mean(y_P2'), 'r')
    end
elseif medianFlag
    set(hplot, 'Color', 0.8*[1 1 1]); hold on;
    plot(x, median(y_P2'), 'r')
end
set(gca, 'YLim', [0 max(max(y_P2))], 'XLim', [-20 80])
xlabel('Time (ms)')
ylabel('Events')
title(['AAV1 -- ' ortho_or_anti ' stim -- RSC probe'])

subplot(rows, cols, 2) % ortho, M2 end (probe 1)
y_P1 = squeeze(traces_P1(:,paramCombo,:)); % e.g. 100 by 6
hplot = plot(x, y_P1);
if meanFlag
    set(hplot, 'Color', 0.8*[1 1 1]); hold on;
    if semFlag
        errorbar(x, mean(y_P1'), std(y_P1')/sqrt(size(y_P1,2)))
    elseif ~semFlag
        plot(x, mean(y_P1'), 'b')
    end
elseif medianFlag
    set(hplot, 'Color', 0.8*[1 1 1]); hold on;
    plot(x, median(y_P1'), 'b')
end
set(gca, 'YLim', [0 max(max(y_P1))], 'XLim', [-20 80])
xlabel('Time (ms)')
ylabel('Events')
title('M2 probe')

subplot(rows, cols, 3) % P1 and P2 avg or median traces, normalized
if meanFlag
    plot(x, mean(y_P2')/max(mean(y_P2')), 'r') 
    hold on
    plot(x, mean(y_P1')/max(mean(y_P1')), 'b') 
elseif medianFlag
    plot(x, median(y_P2')/max(median(y_P2')), 'r') 
    hold on
    plot(x, median(y_P1')/max(median(y_P1')), 'b') 
end
set(gca, 'YLim', [0 1], 'XLim', [-20 80])
xlabel('Time (ms)')
ylabel('Events')
title('Both probes (normalized)')

subplot(rows, cols, 4) % compare RSC and M2 activity levels
% plot(max(y_P1), max(y_P2), 'ro')
% hold on
% plot(sum(y_P1), sum(y_P2), 'bo')
% daspect([1 1 1])
% maxlim = max([get(gca, 'XLim') get(gca, 'YLim')]);
% set(gca, 'XLim', [0 maxlim], 'YLim', [0 maxlim])
hplot = plot([sum(y_P2); sum(y_P1)]); % alternative plot
set(hplot, 'Color', 0.8*[1 1 1]); 
hold on;
hplot = plot([median(sum(y_P2)); median(sum(y_P1))]);
set(hplot, 'Color', 'b', 'LineWidth', 2, 'Marker', 'o')
set(gca, 'XTickLabel', [])
set(gca, 'Tag', 'Amplitudes')
title('Amplitudes')
xlabel('RSC    M2')
ylabel('Amplitudes (summed events)')
% [p,h]=signrank(sum(y_P2), sum(y_P1));
[p,h]=signtest(sum(y_P2), sum(y_P1));
disp(' '); 
disp('------Sign tests (2-sided, paired)------')
disp(['AAV1 (n = ' num2str(size(y_P1, 2)) '):'])
disp(['Amplitudes, P1 vs P2: p = ' num2str(p) '; h = ' num2str(h)])
disp(['Amplitude ratio: ' num2str(median(sum(y_P2))/median(sum(y_P1)))])

subplot(rows, cols, 5) % latencies
[~, inds_P1] = max(y_P1);
[~, inds_P2] = max(y_P2);
hplot = plot([inds_P2 + timeOffset; inds_P1 + timeOffset]);
set(hplot, 'Color', 0.8*[1 1 1]); 
hold on;
hplot = plot([median(inds_P2 + timeOffset); median(inds_P1 + timeOffset)]);
set(hplot, 'Color', 'b', 'LineWidth', 2, 'Marker', 'o')
set(gca, 'YLim', [0 max(get(gca, 'YLim'))])
set(gca, 'XTickLabel', [])
set(gca, 'Tag', 'Latencies')
title('Latencies')
xlabel('RSC    M2')
ylabel('Latencies (ms,post-stim)')
% [p,h]=signrank(inds_P1, inds_P2);
[p,h]=signtest(inds_P1, inds_P2);
disp(['Latencies, P1 vs P2: p = ' num2str(p) '; h = ' num2str(h)])
disp(['Latency difference (ms): ' num2str(median(inds_P2 + timeOffset) - median(inds_P1 + timeOffset))])

data.aav1.amplitudes = [median(sum(y_P2)); median(sum(y_P1))];
data.aav1.latencies = [median(inds_P2 + timeOffset); median(inds_P1 + timeOffset)];

% ---------------------- Same, for AAV9 data -----------------------------
names = getNames([ortho_or_anti '_aav9']);
traces_P1 = []; traces_P2 = [];
for n=1:numel(names)
    load([path1 names{n}], 'Tm_Par_P');
    traces_P1(:,:,n) = Tm_Par_P(:,:,1);
    traces_P2(:,:,n) = Tm_Par_P(:,:,2);
end

subplot(rows, cols, 6) % ortho, RSC end (probe 2)
y_P2 = squeeze(traces_P2(:,paramCombo,:)); % e.g. 100 by 6
hplot = plot(x, y_P2);
if meanFlag
    set(hplot, 'Color', 0.8*[1 1 1]); hold on;
    if semFlag
        errorbar(x, mean(y_P2'), std(y_P2')/sqrt(size(y_P2,2)))
    elseif ~semFlag
        plot(x, mean(y_P2'), 'r')
    end
elseif medianFlag
    set(hplot, 'Color', 0.8*[1 1 1]); hold on;
    plot(x, median(y_P2'), 'r')
end
set(gca, 'YLim', [0 max(max(y_P2))], 'XLim', [-20 80])
xlabel('Time (ms)')
ylabel('Events')
title(['AAV9 -- ' ortho_or_anti ' stim -- RSC probe'])

subplot(rows, cols, 7) % ortho, M2 end (probe 1)
y_P1 = squeeze(traces_P1(:,paramCombo,:)); % e.g. 100 by 6
hplot = plot(x, y_P1);
if meanFlag
    set(hplot, 'Color', 0.8*[1 1 1]); hold on;
    if semFlag
        errorbar(x, mean(y_P1'), std(y_P1')/sqrt(size(y_P1,2)))
    elseif ~semFlag
        plot(x, mean(y_P1'), 'b')
    end
elseif medianFlag
    set(hplot, 'Color', 0.8*[1 1 1]); hold on;
    plot(x, median(y_P1'), 'b')
end
set(gca, 'YLim', [0 max(max(y_P1))], 'XLim', [-20 80])
xlabel('Time (ms)')
ylabel('Events')
title('M2 probe')

subplot(rows, cols, 8) % P1 and P2 avg or median traces, normalized
if meanFlag
    plot(x, mean(y_P2')/max(mean(y_P2')), 'r') 
    hold on
    plot(x, mean(y_P1')/max(mean(y_P1')), 'b') 
elseif medianFlag
    plot(x, median(y_P2')/max(median(y_P2')), 'r') 
    hold on
    plot(x, median(y_P1')/max(median(y_P1')), 'b') 
end
set(gca, 'YLim', [0 1], 'XLim', [-20 80])
xlabel('Time (ms)')
ylabel('Events')
title('Both probes (normalized)')

subplot(rows, cols, 9) % compare RSC and M2 activity levels
% plot(max(y_P1), max(y_P2), 'ro')
% hold on
% plot(sum(y_P1), sum(y_P2), 'bo')
% daspect([1 1 1])
% maxlim = max([get(gca, 'XLim') get(gca, 'YLim')]);
% set(gca, 'XLim', [0 maxlim], 'YLim', [0 maxlim])
hplot = plot([sum(y_P2); sum(y_P1)]); % alternative plot
set(hplot, 'Color', 0.8*[1 1 1]); 
hold on;
hplot = plot([median(sum(y_P2)); median(sum(y_P1))]);
set(hplot, 'Color', 'b', 'LineWidth', 2, 'Marker', 'o')
set(gca, 'XTickLabel', [])
set(gca, 'Tag', 'Amplitudes')
title('Amplitudes')
xlabel('RSC    M2')
ylabel('Amplitudes (summed events)')
% [p,h]=signrank(sum(y_P2), sum(y_P1));
[p,h]=signtest(sum(y_P2), sum(y_P1));
disp(' '); disp(['AAV9 (n = ' num2str(size(y_P1, 2)) '):'])
disp(['Amplitudes, P1 vs P2: p = ' num2str(p) '; h = ' num2str(h)])
disp(['Amplitude ratio: ' num2str(median(sum(y_P2))/median(sum(y_P1)))])

subplot(rows, cols, 10) % latencies
[~, inds_P1] = max(y_P1);
[~, inds_P2] = max(y_P2);
hplot = plot([inds_P2 + timeOffset; inds_P1 + timeOffset]);
set(hplot, 'Color', 0.8*[1 1 1]); 
hold on;
hplot = plot([median(inds_P2 + timeOffset); median(inds_P1 + timeOffset)]);
set(hplot, 'Color', 'b', 'LineWidth', 2, 'Marker', 'o')
set(gca, 'YLim', [0 max(get(gca, 'YLim'))])
set(gca, 'XTickLabel', [])
set(gca, 'Tag', 'Latencies')
title('Latencies')
xlabel('RSC    M2')
ylabel('Latencies (ms,post-stim)')
% [p,h]=signrank(inds_P1, inds_P2);
[p,h]=signtest(inds_P1, inds_P2);
disp(['Latencies, P1 vs P2: p = ' num2str(p) '; h = ' num2str(h)])
disp(['Latency difference (ms): ' num2str(median(inds_P2 + timeOffset) - median(inds_P1 + timeOffset))])
disp('-----------------------------------------------')

h = findobj(get(gcf, 'Children'), 'Type', 'axes', 'Tag', 'Amplitudes');
set(h(:), 'XLim', [0 3], 'YLim', [0 max(max(cell2mat(get(h(:), 'YLim'))))])

h = findobj(get(gcf, 'Children'), 'Type', 'axes', 'Tag', 'Latencies');
set(h(:), 'XLim', [0 3], 'YLim', [0 max(max(cell2mat(get(h(:), 'YLim'))))])

boxesOff; tickDirOut;

data.aav9.amplitudes = [median(sum(y_P2)); median(sum(y_P1))];
data.aav9.latencies = [median(inds_P2 + timeOffset); median(inds_P1 + timeOffset)];

% -----------------------------------------------------------------------
function names = getNames(dataset)
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
