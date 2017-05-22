function multiProbeAnalysis_reformatRawFig
%multiProbeAnalysis_reformatRawFig - designed around Xiaojian's 5-probe expts Jan 2017
%   With one of the raw figs active (selected), run this function to fix up
%   the axes etc

% For each fig, run this to set the name appropriately:
% set(gcf, 'NumberTitle', 'off', 'Name', 'L2_5')

climSetForAllAxes
h = findobj(get(gcf, 'Children'), 'Type', 'axes');
set(h, 'XLim', [0 160], 'YLim', [0.5 160.5])