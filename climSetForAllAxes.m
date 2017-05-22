function climSetForAllAxes(in)
% climSetForAllAxes -- Set all axes in a figure to the same 'clim' value
% 'in' -- input argument options:
%    empty --       default is to set all clims to min/max of original axes
%    [min max] --   provide pair of values to use as new clims, e.g. [0 10]
%    'original' --  restores original values (requiires a previous use of this
%                   function with another input option, to store original values in UserData)
%    'cdata' --     clims set to the min and max values of all CData
%
% gs 2016 10
% --------------------------
h = findobj(get(gcf, 'Children'), 'Type', 'axes');

for n = 1:numel(h)
    clims_old(n, :) = get(h(n), 'CLim');
end

if nargin == 0 % default -- 
    % set CLims to overall min and max of all axes
    clims_new = [min(clims_old(:,1)) max(clims_old(:,2))];
    disp(['CLim set to: [' num2str(clims_new) '] -- overall min/max of all axes'])
    
elseif nargin == 1 && isnumeric(in)
    % set CLims to values specified as input
    clims_new = in;
    disp(['CLim set to: [' num2str(clims_new) '] -- user-specified'])
    
elseif nargin == 1 && ischar(in)
    if strcmp(in, 'original')
        % set CLims to original values (requires previous run in another mode)
        clims_old = get(gcf, 'UserData');
        if ~isempty(clims_old)
            for n = 1:numel(h)
                set(h(n), 'CLim', clims_old(n,:));
            end
            disp(['CLim set to original values for each axes'])
            return
        else
            disp(['CLim already at original values for each axes'])
            return
        end
        
    elseif strcmp(in, 'cdata')
        % set CLims to overall min and max of all CData (image data)
        for n = 1:numel(h)
            cdata(:, :, n) = get(findobj(get(h(n), 'Children'), 'Type', 'image'), 'CData');
        end
        clims_new = [min(min(min(cdata))) max(max(max(cdata)))];
        disp(['CLim set to: [' num2str(clims_new) '] -- overall min/max of all CData'])        
    end
    
end

set(h(:), 'CLim', clims_new)

if isempty(get(gcf, 'UserData')) % only on first run, to avoid over-write
    set(gcf, 'UserData', clims_old)
end




