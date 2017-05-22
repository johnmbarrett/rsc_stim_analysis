function tickDirOut
% sets the 'tickDir' property of all axes in the current figure to 'out'

h = findobj(get(gcf, 'Children'), 'Type', 'axes');set(h, 'TickDir', 'out')