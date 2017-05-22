function boxesOn
% sets the 'Box' property of all axes in the current figure to 'on'

h = findobj(get(gcf, 'Children'), 'Type', 'axes');set(h, 'Box', 'on')