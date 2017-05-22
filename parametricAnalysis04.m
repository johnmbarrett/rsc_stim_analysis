function out = parametricAnalysis04
% parametricAnalysis04
%
% This is a revision of parametricAnalysis01.
% It generates the arrays for the parametric analysis, including
% those for Konrad to use.
% Operates on 100x25 arrays of vectors from the parametric 5x5 data sets,
%     where each vector is the projection of a single histogram
%
% terminology:
% 'anti' refers to stimulation in M2 (of RSC axons there)
% 'ortho' refers to stimulation in RSC (of RSC neurons there)
% 'probe 1' is the one in M2
% 'probe 2' is the one in RSC
%
% Notes: 
% - responses are summed only over the interval 0-50 ms post-stim
%
% gs 2016-07-15
% --------------------------------------

% USER SETTINGS
% dataset_list = {'ortho_aav1', 'ortho_aav9', 'anti_aav1', 'anti_aav9'};
% dataset_list = {'ortho_aav9', 'anti_aav9'};
dataset_list = {'ortho_aav9'};
% dataset_list = {'ortho_aav1'};

for N = 1:numel(dataset_list)
    dataset = char(dataset_list(N));
    if strfind(dataset, 'ortho'); 
        stimSite = 'RSC'; 
    else
        stimSite = 'M2';
    end 
    for P = 1:2
        probeNum = P; 
        probeNames = {'M2', 'RSC'};
        
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
        figName = ['Dataset: ' dataset '; stim in ' stimSite '; probe in ' char(probeNames(probeNum))];
        figure('Name', figName, 'NumberTitle','off')
        rows = 3; cols = 3; plotN = 0;
        for n = 1:rows*cols; plotN = plotN + 1; subplot(rows, cols, plotN); end
        plotN = 0;
        for n = 1:size(traces, 3)
            plotN = plotN + 1; subplot(rows, cols, plotN)
            imagesc(traces(:,:,n)')
        end
            
        % FIGURE - plots with all traces
        figName = ['Dataset: ' dataset '; stim in ' stimSite '; probe in ' char(probeNames(probeNum))];
        figure('Name', figName, 'NumberTitle','off')
        rows = 5; cols = 5; plotN = 0;
        for n = 1:rows*cols; plotN = plotN + 1; subplot(rows, cols, plotN); end
        plotN = 0;
        for n = 1:rows*cols
            plotN = plotN + 1; subplot(rows, cols, plotN)
            y = squeeze(traces(:,n,:)); % e.g. 100 by 6
            hplot = plot(x, y); % plots the collection of traces from each expt
            if meanFlag
                set(hplot, 'Color', 0.8*[1 1 1]); hold on;
                if semFlag
                    errorbar(x, mean(y'), std(y')/sqrt(size(y,2)))
                elseif ~semFlag
                    plot(x, mean(y'))
                end
            elseif medianFlag
                set(hplot, 'Color', 0.8*[1 1 1]); hold on;
                plot(x, median(y')); % plots the median on top of the individual traces
            end
        end
        % re-scale all y-axes
        h = findobj(get(gcf, 'Children'), 'Type', 'axes');
        set(h(:), 'YLim', [0 max(max(max(traces)))], 'XLim', [-20 80])
        boxesOff; tickDirOut;
        
        % FIGURE - analyses
        figure('Name', figName, 'NumberTitle','off')
        plotnum = 0; plotrows = 3; plotcols = 2;
        
        plotnum = plotnum + 1;
        subplot(plotrows, plotcols, plotnum)
        intensities_norm = [.2 .4 .6 .8 1];
        durations_norm = [1 5 10 20 50]/50;
        stimArray = intensities_norm' * durations_norm;
        imagesc(flipud(stimArray))
        axis image
        xlabel('Duration'); ylabel('Intensity'); title('Stimulus')
        
        plotnum = plotnum + 1;
        subplot(plotrows, plotcols, plotnum)
        % traces: 100 x 25 x n array; n is the # of animals (expts), e.g. 6
        % first, sum the 100 values to convert each vector to a single value
        traces_summed = sum(traces(21:71, :, :), 1); % NB - only 0-50 msec post-stim
%         size(traces)
        % now it's 1 x 25 x n; convert to 5 x 5 x n:
        arrays_all = reshape(traces_summed, 5, 5, size(traces_summed, 3));
        % flip the matrix:
        arrays_all = permute(arrays_all, [2 1 3]);
        % get the mean or median (as specified above)
        if meanFlag
            arrays_avgd = mean(arrays_all, 3);
        elseif medianFlag
            arrays_avgd = median(arrays_all, 3);
        end
        imagesc(flipud(arrays_avgd))
        % for n = 1:rows*cols
        %     y = squeeze(traces(:,n,:)); % e.g. 100 by 6
        %     if meanFlag
        %         Y(n) = sum(mean(y'));
        %     elseif medianFlag
        %         Y(n) = sum(median(y'));
        %     end
        % end
        % Y = reshape(Y, 5, 5);
        % imagesc(Y');
        axis image
        xlabel('Duration'); ylabel('Intensity');
        title(['Dataset: ' dataset '; Probe: ' num2str(probeNum)])
        
        colormap(jet3(256));
        boxesOff; tickDirOut;
        
        % Plot the responses (raw) as a function of stim intensity:
        plotnum = plotnum + 1;
        subplot(plotrows, plotcols, plotnum)
        x = [.2 .4 .6 .8 1];
        plot(x, arrays_avgd)
        set(gca, 'XLim', [0 1])
        xlabel('Intensity'); ylabel('Response (events)');
        
        % Plot the responses (norm'd) as a function of stim intensity:
        plotnum = plotnum + 1;
        subplot(plotrows, plotcols, plotnum)
        x = [.2 .4 .6 .8 1];
        ymax = max(arrays_avgd, [], 1);
        ymaxmatrix = repmat(ymax, 5, 1);
        normArray = arrays_avgd./ymaxmatrix;
        plot(x, normArray)
        set(gca, 'XLim', [0 1], 'YLim', [0 1])
        xlabel('Intensity'); ylabel('Response (norm.)');
        
        % Plot the responses (raw) as a function of stim duration:
        plotnum = plotnum + 1;
        subplot(plotrows, plotcols, plotnum)
        x = [1 5 10 20 50];
        plot(x, arrays_avgd')
        set(gca, 'XLim', [0 50])
        xlabel('Duration'); ylabel('Response (events)');
        
        % Plot the responses (norm'd) as a function of stim duration:
        plotnum = plotnum + 1;
        subplot(plotrows, plotcols, plotnum)
        x = [1 5 10 20 50];
        ymax = max(arrays_avgd, [], 2);
        ymaxmatrix = repmat(ymax, 1, 5);
        normArray = arrays_avgd./ymaxmatrix;
        plot(x, normArray')
        set(gca, 'XLim', [0 50], 'YLim', [0 1])
        xlabel('Duration'); ylabel('Response (norm.)');
    end
end

return
out = arrays_avgd;



