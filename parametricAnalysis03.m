function data = parametricAnalysis03
% parametricAnalysis03
%
% Gets the median amplitudes and latencies for all the datasets, across all
% parameter combinations in the 5 by 5 stimulus matrix, by repeatedly
% calling parametricAnalysis02.m
%
% In each plot, plots the values for each particular duration-intensity
% combination (gray lines), along with the overall median (blue lines)
%
% gs 2016-08-05
% --------------------------------------


for n=1:25
%     d = [d, parametricAnalysis02('anti', n)];

    d = parametricAnalysis02('ortho', n);
    data.ortho.aav1.amplitudes(:,n) = d.aav1.amplitudes;
    data.ortho.aav9.amplitudes(:,n) = d.aav9.amplitudes;
    data.ortho.aav1.latencies(:,n) = d.aav1.latencies;
    data.ortho.aav9.latencies(:,n) = d.aav9.latencies;
    
    d = parametricAnalysis02('anti', n);
    data.anti.aav1.amplitudes(:,n) = d.aav1.amplitudes;
    data.anti.aav9.amplitudes(:,n) = d.aav9.amplitudes;
    data.anti.aav1.latencies(:,n) = d.aav1.latencies;
    data.anti.aav9.latencies(:,n) = d.aav9.latencies;
    
    close all
end

figure;
plotrows = 2; plotcols = 5; plotnum = 0;

plotnum = plotnum + 1; subplot(plotrows, plotcols, plotnum)
hplot = plot(data.ortho.aav1.amplitudes);
set(hplot, 'Color', 0.8*[1 1 1]); 
hold on;
hplot = plot(median(data.ortho.aav1.amplitudes'));
set(hplot, 'Color', 'b', 'LineWidth', 2, 'Marker', 'o')
title('Ortho -- AAV1 -- Amplitudes')
set(gca, 'XTickLabel', [])
set(gca, 'Tag', 'Amplitudes')
xlabel('RSC    M2')
ylabel('Amplitudes (summed events)')
% [p,h]=signrank(data.ortho.aav1.amplitudes(1,:), data.ortho.aav1.amplitudes(2,:));
[p,h]=signtest(data.ortho.aav1.amplitudes(1,:), data.ortho.aav1.amplitudes(2,:));
disp(' '); 
disp('------Sign tests (2-sided, paired)------')
disp('Ortho, AAV1:')
disp(['Amplitudes, P1 vs P2: p = ' num2str(p) '; h = ' num2str(h)])


plotnum = plotnum + 1; subplot(plotrows, plotcols, plotnum)
hplot = plot(data.ortho.aav9.amplitudes);
set(hplot, 'Color', 0.8*[1 1 1]); 
hold on;
hplot = plot(median(data.ortho.aav9.amplitudes'));
set(hplot, 'Color', 'b', 'LineWidth', 2, 'Marker', 'o')
title('Ortho -- AAV9 -- Amplitudes')
set(gca, 'XTickLabel', [])
set(gca, 'Tag', 'Amplitudes')
xlabel('RSC    M2')
ylabel('Amplitudes (summed events)')
% [p,h]=signrank(data.ortho.aav9.amplitudes(1,:), data.ortho.aav9.amplitudes(2,:));
[p,h]=signtest(data.ortho.aav9.amplitudes(1,:), data.ortho.aav9.amplitudes(2,:));
disp(' '); 
disp('Ortho, AAV9:')
disp(['Amplitudes, P1 vs P2: p = ' num2str(p) '; h = ' num2str(h)])


plotnum = plotnum + 1; subplot(plotrows, plotcols, plotnum);
y1 = data.ortho.aav1.amplitudes(1,:); y2 = data.ortho.aav1.amplitudes(2,:);
ratios_aav1 = y2./y1;
hplot = errorbar(median(y2./y1),  mad(y2./y1, 1));
set(hplot, 'Marker', 'o')
hold on
y1 = data.ortho.aav9.amplitudes(1,:); y2 = data.ortho.aav9.amplitudes(2,:);
ratios_aav9 = y2./y1;
hplot = errorbar(2, median(y2./y1),  mad(y2./y1, 1));
set(hplot, 'Marker', 'o')
title('RSC/M2 (med +/- mad') % median +/- median absolute deviation
set(gca, 'XTickLabel', [])
set(gca, 'Tag', 'Activity ratio')
xlabel('AAV1    AAV9')
ylabel('RSC/M2 activity ratio')
set(gca, 'YLim', [0 max(get(gca, 'YLim'))])
[p,h] = ranksum(ratios_aav1, ratios_aav9);
disp(' '); 
disp('RSC/M2 activity ratio (rank sum, n=25 each)')
disp(['AAV1: median = ' num2str(median(ratios_aav1)) '; med. abs. dev. = ' num2str(mad(ratios_aav1,1))])
disp(['AAV9: median = ' num2str(median(ratios_aav9)) '; med. abs. dev. = ' num2str(mad(ratios_aav9,1))])
disp(['AAV1 vs AAV9: p = ' num2str(p) '; h = ' num2str(h)])


plotnum = plotnum + 1; subplot(plotrows, plotcols, plotnum)
hplot = plot(data.ortho.aav1.latencies);
set(hplot, 'Color', 0.8*[1 1 1]); 
hold on;
hplot = plot(median(data.ortho.aav1.latencies'));
set(hplot, 'Color', 'b', 'LineWidth', 2, 'Marker', 'o')
title('Ortho -- AAV1 -- Latencies')
set(gca, 'XTickLabel', [])
set(gca, 'Tag', 'Latencies')
xlabel('RSC    M2')
ylabel('Latencies (ms,post-stim)')
% [p,h]=signrank(data.ortho.aav1.latencies(1,:), data.ortho.aav1.latencies(2,:));
[p,h]=signtest(data.ortho.aav1.latencies(1,:), data.ortho.aav1.latencies(2,:));
disp(' '); 
disp('Ortho, AAV1:')
disp(['Latencies, P1 vs P2: p = ' num2str(p) '; h = ' num2str(h)])


plotnum = plotnum + 1; subplot(plotrows, plotcols, plotnum)
hplot = plot(data.ortho.aav9.latencies);
set(hplot, 'Color', 0.8*[1 1 1]); 
hold on;
hplot = plot(median(data.ortho.aav9.latencies'));
set(hplot, 'Color', 'b', 'LineWidth', 2, 'Marker', 'o')
title('Ortho -- AAV9 -- Latencies')
set(gca, 'XTickLabel', [])
set(gca, 'Tag', 'Latencies')
xlabel('RSC    M2')
ylabel('Latencies (ms,post-stim)')
% [p,h]=signrank(data.ortho.aav9.latencies(1,:), data.ortho.aav9.latencies(2,:));
[p,h]=signtest(data.ortho.aav9.latencies(1,:), data.ortho.aav9.latencies(2,:));
disp(' '); 
disp('Ortho, AAV9:')
disp(['Latencies, P1 vs P2: p = ' num2str(p) '; h = ' num2str(h)])


plotnum = plotnum + 1; subplot(plotrows, plotcols, plotnum)
hplot = plot(data.anti.aav1.amplitudes);
set(hplot, 'Color', 0.8*[1 1 1]); 
hold on;
hplot = plot(median(data.anti.aav1.amplitudes'));
set(hplot, 'Color', 'b', 'LineWidth', 2, 'Marker', 'o')
title('Anti -- AAV1 -- Amplitudes')
set(gca, 'XTickLabel', [])
set(gca, 'Tag', 'Amplitudes')
xlabel('RSC    M2')
ylabel('Amplitudes (summed events)')
% [p,h]=signrank(data.anti.aav1.amplitudes(1,:), data.anti.aav1.amplitudes(2,:));
[p,h]=signtest(data.anti.aav1.amplitudes(1,:), data.anti.aav1.amplitudes(2,:));
disp(' '); 
disp('Anti, AAV1:')
disp(['Amplitudes, P1 vs P2: p = ' num2str(p) '; h = ' num2str(h)])


plotnum = plotnum + 1; subplot(plotrows, plotcols, plotnum)
hplot = plot(data.anti.aav9.amplitudes);
set(hplot, 'Color', 0.8*[1 1 1]); 
hold on;
hplot = plot(median(data.anti.aav9.amplitudes'));
set(hplot, 'Color', 'b', 'LineWidth', 2, 'Marker', 'o')
title('Anti -- AAV9 -- Amplitudes')
set(gca, 'XTickLabel', [])
set(gca, 'Tag', 'Amplitudes')
xlabel('RSC    M2')
ylabel('Amplitudes (summed events)')
% [p,h]=signrank(data.anti.aav9.amplitudes(1,:), data.anti.aav9.amplitudes(2,:));
[p,h]=signtest(data.anti.aav9.amplitudes(1,:), data.anti.aav9.amplitudes(2,:));
disp(' '); 
disp('Anti, AAV9:')
disp(['Amplitudes, P1 vs P2: p = ' num2str(p) '; h = ' num2str(h)])


plotnum = plotnum + 1; subplot(plotrows, plotcols, plotnum);
y1 = data.anti.aav1.amplitudes(1,:); y2 = data.anti.aav1.amplitudes(2,:);
ratios_aav1 = y1./y2;
hplot = errorbar(1, median(ratios_aav1),  mad(ratios_aav1, 1));
set(hplot, 'Marker', 'o')
y1 = data.anti.aav9.amplitudes(1,:); y2 = data.anti.aav9.amplitudes(2,:);
ratios_aav9 = y1./y2;
hold on
hplot = errorbar(2, median(ratios_aav9),  mad(ratios_aav9, 1));
set(hplot, 'Marker', 'o')
title('RSC/M2 (med +/- mad') % median +/- median absolute deviation
set(gca, 'XTickLabel', [])
set(gca, 'Tag', 'Activity ratio')
xlabel('AAV1    AAV9')
ylabel('RSC/M2 activity ratio')
set(gca, 'YLim', [0 max(get(gca, 'YLim'))])
[p,h] = ranksum(ratios_aav1, ratios_aav9);
disp(' '); 
disp('Activity ratio (rank sum, n=25 each)')
disp(['AAV1: median = ' num2str(median(ratios_aav1)) '; med. abs. dev. = ' num2str(mad(ratios_aav1,1))])
disp(['AAV9: median = ' num2str(median(ratios_aav9)) '; med. abs. dev. = ' num2str(mad(ratios_aav9,1))])
disp(['AAV1 vs AAV9: p = ' num2str(p) '; h = ' num2str(h)])


plotnum = plotnum + 1; subplot(plotrows, plotcols, plotnum)
hplot = plot(data.anti.aav1.latencies);
set(hplot, 'Color', 0.8*[1 1 1]); 
hold on;
hplot = plot(median(data.anti.aav1.latencies'));
set(hplot, 'Color', 'b', 'LineWidth', 2, 'Marker', 'o')
title('Anti -- AAV1 -- Latencies')
set(gca, 'XTickLabel', [])
set(gca, 'Tag', 'Latencies')
xlabel('RSC    M2')
ylabel('Latencies (ms,post-stim)')
% [p,h]=signrank(data.anti.aav1.latencies(1,:), data.anti.aav1.latencies(2,:));
[p,h]=signtest(data.anti.aav1.latencies(1,:), data.anti.aav1.latencies(2,:));
disp(' '); 
disp('Anti, AAV1:')
disp(['Latencies, P1 vs P2: p = ' num2str(p) '; h = ' num2str(h)])


plotnum = plotnum + 1; subplot(plotrows, plotcols, plotnum)
hplot = plot(data.anti.aav9.latencies);
set(hplot, 'Color', 0.8*[1 1 1]); 
hold on;
hplot = plot(median(data.anti.aav9.latencies'));
set(hplot, 'Color', 'b', 'LineWidth', 2, 'Marker', 'o')
title('Anti -- AAV9 -- Latencies')
set(gca, 'XTickLabel', [])
set(gca, 'Tag', 'Latencies')
xlabel('RSC    M2')
ylabel('Latencies (ms,post-stim)')
% [p,h]=signrank(data.anti.aav9.latencies(1,:), data.anti.aav9.latencies(2,:));
[p,h]=signtest(data.anti.aav9.latencies(1,:), data.anti.aav9.latencies(2,:));
disp(' '); 
disp('Anti, AAV9:')
disp(['Latencies, P1 vs P2: p = ' num2str(p) '; h = ' num2str(h)])

% ---------------
disp(' '); disp(' '); disp('AAV1 vs AAV9 comparisons:'); 
% ortho, amplitudes
[p,h]=signtest(data.ortho.aav1.amplitudes(1,:), data.ortho.aav9.amplitudes(1,:));
disp(' '); 
disp('Ortho, P1:')
disp(['Amplitudes, AAV1 vs AAV9: p = ' num2str(p) '; h = ' num2str(h)])
disp([num2str(median(data.ortho.aav1.amplitudes(1,:))) ', ' ...
    num2str(median(data.ortho.aav9.amplitudes(1,:)))]);

[p,h]=signtest(data.ortho.aav1.amplitudes(2,:), data.ortho.aav9.amplitudes(2,:));
disp(' '); 
disp('Ortho, P2:')
disp(['Amplitudes, AAV1 vs AAV9: p = ' num2str(p) '; h = ' num2str(h)])
disp([num2str(median(data.ortho.aav1.amplitudes(2,:))) ', ' ...
    num2str(median(data.ortho.aav9.amplitudes(2,:)))]);

% ortho, latencies
[p,h]=signtest(data.ortho.aav1.latencies(1,:), data.ortho.aav9.latencies(1,:));
disp(' '); 
disp('Ortho, P1:')
disp(['Latencies, AAV1 vs AAV9: p = ' num2str(p) '; h = ' num2str(h)])
disp([num2str(median(data.ortho.aav1.latencies(1,:))) ', ' ...
    num2str(median(data.ortho.aav9.latencies(1,:)))]);

[p,h]=signtest(data.ortho.aav1.latencies(2,:), data.ortho.aav9.latencies(2,:));
disp(' '); 
disp('Ortho, P2:')
disp(['Latencies, AAV1 vs AAV9: p = ' num2str(p) '; h = ' num2str(h)])
disp([num2str(median(data.ortho.aav1.latencies(2,:))) ', ' ...
    num2str(median(data.ortho.aav9.latencies(2,:)))]);

% anti, amplitudes
[p,h]=signtest(data.anti.aav1.amplitudes(1,:), data.anti.aav9.amplitudes(1,:));
disp(' '); 
disp('Anti, P1:')
disp(['Amplitudes, AAV1 vs AAV9: p = ' num2str(p) '; h = ' num2str(h)])
disp([num2str(median(data.anti.aav1.amplitudes(1,:))) ', ' ...
    num2str(median(data.anti.aav9.amplitudes(1,:)))]);

[p,h]=signtest(data.anti.aav1.amplitudes(2,:), data.anti.aav9.amplitudes(2,:));
disp(' '); 
disp('Anti, P2:')
disp(['Amplitudes, AAV1 vs AAV9: p = ' num2str(p) '; h = ' num2str(h)])
disp([num2str(median(data.anti.aav1.amplitudes(2,:))) ', ' ...
    num2str(median(data.anti.aav9.amplitudes(2,:)))]);

% anti, latencies
[p,h]=signtest(data.anti.aav1.latencies(1,:), data.anti.aav9.latencies(1,:));
disp(' '); 
disp('Anti, P1:')
disp(['Latencies, AAV1 vs AAV9: p = ' num2str(p) '; h = ' num2str(h)])
disp([num2str(median(data.anti.aav1.latencies(1,:))) ', ' ...
    num2str(median(data.anti.aav9.latencies(1,:)))]);

[p,h]=signtest(data.anti.aav1.latencies(2,:), data.anti.aav9.latencies(2,:));
disp(' '); 
disp('Anti, P2:')
disp(['Latencies, AAV1 vs AAV9: p = ' num2str(p) '; h = ' num2str(h)])
disp([num2str(median(data.anti.aav1.latencies(2,:))) ', ' ...
    num2str(median(data.anti.aav9.latencies(2,:)))]);




% axes clean-ups
h = findobj(get(gcf, 'Children'), 'Type', 'axes', 'Tag', 'Amplitudes');
set(h(:), 'XLim', [0 3], 'YLim', [0 max(max(cell2mat(get(h(:), 'YLim'))))])

h = findobj(get(gcf, 'Children'), 'Type', 'axes', 'Tag', 'Latencies');
set(h(:), 'XLim', [0 3], 'YLim', [0 max(max(cell2mat(get(h(:), 'YLim'))))])

boxesOff; tickDirOut;
