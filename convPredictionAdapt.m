function deviation=convPredictionAdapt(paras,Bfull,Afull)
% deviation=convPrediction(paras,Bfull,Afull)
% Konrad's second function, this one for convolving the photostimulus pulse itself to the 
% local responses.
%
% Bfull: 5x5x100 stimulus array -- 
% NOTE: potential source of confusion: you can generate this as the "C" array using the
% code at the bottom of this function; but note that within this function
% it C is then assigned to Bfull, and Bfull is assigned to Afull (for
% historical reasons ...)
% Afull: 5x5x100 upstream data array; e.g. median RSC responses to RSC stim
% deviation: used to optimize the fit
% paras: e.g. 1.0e+03 *[0.1517    1.3090    0.0000   -0.0035    0.0007]
%
% Usage: e.g.
% (1) run parametricAnalysis04
% (2) click on the fig with the 5x5 subplots of traces for the upstream
%     area of interest; e.g. RSC responses to RSC stim
% (3) run the code at the bottom of this function to generate the 'C' array
% in the workspace
% (4) do the same for the M2 responses to RSC stim to generate the 'BFull'
% in the workspace
% (5) call this function from the command line:
% paras=1.0e+03*[1.75    0.0   -0.0035    0.0007    0.025]; % AAV9 ortho
% paras=1.0e+03*[ 3000    0.0   -0.0035    0.00007    0.07]; % AAV1 ortho
% paras=fminsearch(@convPredictionAdapt,paras,[],C, Bfull)
% 
% See also: 
% parametricAnalysis04 -- generates the figure with the 5 x 5 array 
%   of subplots with blue traces, used for the fits here
% convPrediction2 -- similar to this, but for fitting the downstream
% responses
% 
% 2017 may
% ------------------------------------------------------------------
x=1:100;
figure(77)
k=0;
deviation=0;
for i=1:5
    for j=1:5
        k=k+1;
        subplot(5,5,k)
        plot(squeeze(Bfull(i,j,:))/max(Bfull(:))*max(Afull(:))); hold on
        plot(squeeze(Afull(i,j,:)),'r');
        preds=squeeze(Bfull(i,j,:));
        pastFilter=exp((0:-1:-60)/paras(1));
        pastFilter=pastFilter/sum(pastFilter);
        normalizer=conv(preds,pastFilter);
        normalizer=normalizer(1:length(preds));
        preds=preds./abs(normalizer+paras(2));
        preds=interp1(1:length(preds),preds,(1:length(preds))+paras(3))';
        preds(find(isnan(preds)))=0;
        preds=preds*paras(4);
        plot(preds,'m');
        deviation=deviation+sqrt(sum((squeeze(Afull(i,j,:))-preds).^2));
    end
end
[deviation paras]
% drawnow

%parasBest=fmin

return

% -----------------------------------------------------------------
% GENERATE the trace arrays: 
% select the plot for the upstream area (e.g. RSC, for ortho case) 
% and run this at the command line:
h = findobj(get(gcf, 'Children'), 'Type', 'line', 'color', [0.635 0.078 0.184]);
B25 = []; for n=1:25; B25(n, :) = get(h(n), 'YData'); end
Bfull = reshape(B25, 5, 5, 100);
% select the plot for the downstream area (e.g. M2, for ortho case) 
% and run this at the command line:
h = findobj(get(gcf, 'Children'), 'Type', 'line', 'color', 'b');
A25 = []; for n=1:25; A25(n, :) = get(h(n), 'YData'); end
Afull = reshape(A25, 5, 5, 100);

% generate the stimulus array ('tensor'):
% C = zeros(5,5,100);
stim_dur = [1 5 10 20 50];
stim_int = [0.2 0.4 0.6 0.8 1.0];
stim_dur=stim_dur(end:-1:1);
stim_int=stim_int(end:-1:1);

stim_start = 21; % confirm that this should be 21 <<<<<<===========
C = zeros(5,5,100);
for n=1:numel(stim_dur) % NB: may need to reshape/permute <<<<=====
    stim_end = stim_start + stim_dur(n)-1;
    for m=1:numel(stim_dur)
        stimpulse = zeros(100, 1);
        stimpulse(stim_start:stim_end) = 1.0;
        stimpulse = stimpulse * stim_int(m);
        C(n, m, :) = stimpulse;
    end
end

% plotting the stimulus array C along with the upstream responses Bfull
figure; k=0; for i=1:5; for j=1:5; k=k+1; subplot(5,5,k); plot(squeeze(Bfull(i,j,:))/3); hold on; plot(squeeze(C(i,j,:)),'r'); end; end

