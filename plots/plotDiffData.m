function plotDiffData(index, means, M, tfrs, ylabelstr, titles, ylimrange, faceColor, saveas)
sr = 22050;

% f = figure(index);
% set(f, 'Position', [0 0 600 680])
ha = subplot(1, 3, index);

hold on
set(gca, 'XScale', 'log');

Y = [max(means)' min(means)'-max(means)'];
X = [tfrs tfrs];
% h = area(X, Y, 'LineStyle',':', 'handleVisibility', 'off');
% h(1).FaceAlpha = 0;
% h(1).EdgeAlpha = 0;
% h(2).FaceColor = faceColor;
% h(2).FaceAlpha = 0.7;

line_styles = {'-'; '--'; ':'; '-.'};

plot(NaN,NaN,line_styles{1},'Color', faceColor,'LineWidth',6);
plot(NaN,NaN,line_styles{2},'Color', faceColor,'LineWidth',6);
plot(NaN,NaN,line_styles{3},'Color', faceColor,'LineWidth',6);

for i=1:size(means,1)
    semilogx(tfrs(:), means(i, :), 'LineWidth',9, 'LineStyle', line_styles{i}, 'Color', faceColor)
end

xlim([1e-3, 2e4])

if contains(saveas, "SNR")
    set(gca, 'XTick', [1e-3, 1e-1,1e1,1e3])
    xlabel('\lambda','FontSize',48)
else
    set(gca, 'XTick', [])
end

if index ~= 1
    set(gca, 'YTick', [])
end

ylim(ylimrange)
ylabel(ylabelstr,'FontSize',48)
title(titles,'FontSize',48)

if index == 3
    leg = legend({'MIDI','Speech', 'Music'},'Location','northeast','FontSize',48);
    leg.ItemTokenSize = [80,160];
end

set(gca,'Fontsize',48);

% hold off

box on
% exportgraphics(f, strcat("data_dependencies_", saveas, ".png"))
end