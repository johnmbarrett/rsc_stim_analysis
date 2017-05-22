function multiProbeAnalysis1
%multiProbeAnalysis1 - designed around Xiaojian's 5-probe expts Jan 2017
%   First click on one image in the 5-by-5 imagesc versions of the
%   responses, to make it active. Then run this function to generate the
%   analyses.
%
% see also multiProbeAnalysis_reformatRawFig
%
% gs 2016/jan-feb

c = get(gco, 'CData');

probes = 5; channels = 32; % <<<==== expected layout
if size(c, 1) ~= probes * channels; 'problem', return; end

% probe placements, for legend:
p1 = 'R-S1';
p2 = 'L-M1';
p3 = 'L-S1';
p4 = 'R-thal';
p5 = 'R-M1';

v1 = mean(c(1:32,:));
v2 = mean(c(33:64,:));
v3 = mean(c(65:96,:)); 
v4 = mean(c(97:128,:)); 
v5 = mean(c(129:160,:));
V = [v4; v1; v5; v3; v2];

figure; 
colormap(jet3(256))
subplot(3,1,1)
imagesc(V);
m = max(max(V(:, 50:135)));
set(gca, 'CLim', [0 m])

subplot(3,1,2)
plot(v4, 'r-'); 
hold on, 
plot(v1, 'g-'); 
plot(v5, 'b-'); 
plot(v3, 'c-'); 
plot(v2, 'k-');
box off
tickDirOut
legend(p4, p1, p5, p3, p2)

h = findobj(get(gca, 'Children'), 'Type', 'line');
Y=[];for n=1:numel(h); y=get(h(n),'YData'); Y=[Y; mean(y(55:80))]; end

subplot(3,1,3)
plot(flipud(Y), 'bo-')
box off
tickDirOut
xlabel([p4 ' | ' p1 ' | ' p5 ' | ' p3 ' | ' p2])
