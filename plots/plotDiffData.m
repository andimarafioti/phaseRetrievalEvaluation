function plotDiffData(index, means, M, tfrs, ylabelstr, ylimrange, faceColor)
sr = 22050;

f = figure(index);
set(f, 'Position', [0 0 750 1000])

hold on
set(gca, 'XScale', 'log');

Y = [max(means)' min(means)'-max(means)'];
X = [tfrs tfrs];
h = area(X, Y, 'LineStyle',':', 'handleVisibility', 'off');
h(1).FaceAlpha = 0;
h(1).EdgeAlpha = 0;
h(2).FaceColor = faceColor;
h(2).FaceAlpha = 0.7;

line_styles = {'-'; '--'; ':'; '-.'};
for i=1:size(means,1)
    semilogx(tfrs(:), means(i, :), 'LineWidth',4, 'LineStyle', line_styles{i}, 'Color', 'k')
end

ylim(ylimrange)
xlabel('\lambda','FontSize',24)
ylabel(ylabelstr,'FontSize',24)
set(gca, 'XTick', [1e-2,1,1e2,1e4])
legend({'midi','speech', 'electronic'},'Location','southeast','FontSize',24)
set(gca,'Fontsize',24);

% hold off

box on
end