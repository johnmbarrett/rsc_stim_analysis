function ylimSetForAllAxes(in)
% ylimSetForAllAxes -- Set all axes in a figure to the same 'ylim' value
% 'in' -- input argument options:
%    empty --       default is to set all ylims to min/max of original axes
%    [min max] --   provide pair of values to use as new ylims, e.g. [0 10]
%    'original' --  restores original values (requiires a previous use of this
%                   function with another input option, to store original values in UserData)
%    'ydata' --     ylims set to the min and max values of all YData
%
% gs 201y 05 -- copied from climSetForAllAxes
% --------------------------
h = findobj(get(gcf, 'Children'), 'Type', 'axes');

for n = 1:numel(h)
    ylims_old(n, :) = get(h(n), 'ylim');
end

if nargin == 0 % default -- 
    % set ylims to overall min and max of all axes
    ylims_new = [min(ylims_old(:,1)) max(ylims_old(:,2))];
    disp(['ylim set to: [' num2str(ylims_new) '] -- overall min/max of all axes'])
    
elseif nargin == 1 && isnumeric(in)
    % set ylims to values specified as input
    ylims_new = in;
    disp(['ylim set to: [' num2str(ylims_new) '] -- user-specified'])
    
elseif nargin == 1 && ischar(in)
    if strcmp(in, 'original')
        % set ylims to original values (requires previous run in another mode)
        ylims_old = get(gcf, 'UserData');
        if ~isempty(ylims_old)
            for n = 1:numel(h)
                set(h(n), 'ylim', ylims_old(n,:));
            end
            disp(['ylim set to original values for each axes'])
            return
        else
            disp(['ylim already at original values for each axes'])
            return
        end
        
    elseif strcmp(in, 'cdata')
        % set ylims to overall min and max of all CData (image data)
        for n = 1:numel(h)
            cdata(:, :, n) = get(findobj(get(h(n), 'Children'), 'Type', 'image'), 'CData');
        end
        ylims_new = [min(min(min(cdata))) max(max(max(cdata)))];
        disp(['ylim set to: [' num2str(ylims_new) '] -- overall min/max of all CData'])        
    end
    
end

set(h(:), 'ylim', ylims_new)

if isempty(get(gcf, 'UserData')) % only on first run, to avoid over-write
    set(gcf, 'UserData', ylims_old)
end




