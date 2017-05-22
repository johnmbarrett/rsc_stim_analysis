function C = generateStimulusArray(stim_dur,stim_int)
    % generate the stimulus array ('tensor'):
    % stolen from convPredicitionAdapt
    
    if nargin < 1
        stim_dur = [1 5 10 20 50];
    end
    
    if nargin < 2
        stim_int = [0.2 0.4 0.6 0.8 1.0];
    end
    
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
end