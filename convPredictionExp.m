function deviation=convPredictionExp(paras,Bfull,Afull)
% deviation=convPrediction(paras,Bfull,Afull)
% Konrad's function for convolving the upstream responses to the 
% downstream responses using a gamma distribution.
%
% Bfull: 5x5x100 upstream data array; e.g. median RSC responses to RSC stim
% Afull: 5x5x100 downstream data array; e.g. median M2 responses to RSC stim
% deviation: used to optimize the fit
% paras: e.g. [0.8965    0.0409    0.6115    1.4459    0.2]
%    paras(1): alpha (k), shape; larger-->gaussian, smaller-->exponential
%    paras(2): beta (1/theta), rate; 
%    paras(3): scale?
%    paras(4): y-offset?
%    paras(5): ?
%
% Usage: e.g.
% (1) run parametricAnalysis04
% (2) click on the fig with the 5x5 subplots of traces for the upstream
%     area of interest; e.g. RSC responses to RSC stim
% (3) run the code at the bottom of this function to generate the 'Bfull' array
% (4) do the same for the M2 responses to RSC stim to generate the 'AFull'
% (5) call this function from the command line:
% paras=[0.8726    0.0392    0.9325    1.8700    0.0840]; % AAV9 ortho
% paras=[1.0523    0.0421    0.8047    0.7867    0.0605]; % AAV1 ortho
% paras=fminsearch(@convPrediction2,paras,[],Bfull,Afull)
% 
% See also: 
% parametricAnalysis04 -- generates the figure with the 5 x 5 array 
% of subplots with blue traces, used for the fits here
% 
% 2017 may
%% Main loop ------------------------------------------------------------------
x=1:100;
beta=paras(1);
gamma=exp(-beta*x);
% gamma2=paras(5)*exp(-paras(6)*x);
% gamma=gamma+gamma2;

gamma=gamma/sum(gamma);
figure(77)
k=0;
deviation=0;
for i=1:5
    for j=1:5
        k=k+1;
        subplot(5,5,k)
        plot(squeeze(Bfull(i,j,:))/3); hold on
        plot(squeeze(Afull(i,j,:)),'r');
        preds=conv2(squeeze(Bfull(i,j,:)),gamma'*paras(2));
        preds=preds-paras(3);
        preds(find(preds<0))=0;
         preds=preds+paras(4);
         preds=preds(1:100);

%         preds=interp1(1:length(preds),preds,(1:length(preds))+30*paras(3))';
         preds(find(isnan(preds)))=0;
        deviation=deviation+(sum((squeeze(Afull(i,j,:))-preds).^2))/(sum(squeeze(Afull(i,j,:).^2)));
        plot(preds,'g');
    end
end
deviation=deviation/25;
[deviation paras]
 drawnow

%parasBest=fmin

return
%% -----------------------------------------------------------------
% Various helper functions:
%% GENERATE THE TRACE ARRAYS. See instructions above. 
% RSC traces: 
% Select the plot for the upstream area (e.g. RSC, for ortho case) 
% and run this at the command line:
h = findobj(get(gcf, 'Children'), 'Type', 'line', 'color', 'b');
B25 = []; for n=1:25; B25(n, :) = get(h(n), 'YData'); end
Bfull = reshape(B25, 5, 5, 100);

%% select the plot for the downstream area (e.g. M2, for ortho case) 
% and run this at the command line:
h = findobj(get(gcf, 'Children'), 'Type', 'line', 'color', 'b');
A25 = []; for n=1:25; A25(n, :) = get(h(n), 'YData'); end
Afull = reshape(A25, 5, 5, 100);

%% generate the stimulus array ('tensor'):
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

%% plot the resulting fitted gamma:
x = 1:100;
paras=[0.8726    0.0392    0.9325    1.8700    0.0840]; % <<<<--- INPUT
alpha=paras(1);
beta=paras(2);
gamma=x.^(alpha-1).*exp(-beta*x);
gamma=gamma/sum(gamma);
y = gamma'*paras(3);
figure 
plot(y)

% plot an exponential, for comparison
expnt = exp(-beta*x);
hold on
plot(expnt/sum(expnt), 'r-');
%% grabbing the original and fitted **RSC** probe traces from the figure:
% first select the correct figure with the 5 x 5 array of traces with fits
% Assuming original traces are red (otherwise change color):
h = findobj(get(gcf, 'Children'), 'Type', 'line', 'color', 'r'); % <<<=== COLOR!!!
X25=[]; Xfull=[]; for n=1:25; X25(n,:)=get(h(n),'YData'); end; Xfull=reshape(X25, 5, 5, 100);
dataB25=X25; 
dataBfull=Xfull;
% Assuming fitted traces are black (otherwise change color):
h = findobj(get(gcf, 'Children'), 'Type', 'line', 'color', 'k'); % <<<=== COLOR!!!
X25=[]; Xfull=[]; for n=1:25; X25(n,:)=get(h(n),'YData'); end; Xfull=reshape(X25, 5, 5, 100);
fitB25=X25; 
fitBfull=Xfull;
%% same, but for the **M2** probe traces and fits
% Assuming original traces are red (otherwise change color):
h = findobj(get(gcf, 'Children'), 'Type', 'line', 'color', 'r'); % <<<=== COLOR!!!
X25=[]; Xfull=[]; for n=1:25; X25(n,:)=get(h(n),'YData'); end; Xfull=reshape(X25, 5, 5, 100);
dataA25=X25; 
dataAfull=Xfull;
% Assuming fitted traces are black (otherwise change color):
h = findobj(get(gcf, 'Children'), 'Type', 'line', 'color', 'k'); % <<<=== COLOR!!!
X25=[]; Xfull=[]; for n=1:25; X25(n,:)=get(h(n),'YData'); end; Xfull=reshape(X25, 5, 5, 100);
fitA25=X25; 
fitAfull=Xfull;

