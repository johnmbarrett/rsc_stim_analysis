function boxesOff
% sets the 'Box' property of all axes in the current figure to 'off'

h = findobj(get(gcf, 'Children'), 'Type', 'axes');set(h, 'Box', 'off')