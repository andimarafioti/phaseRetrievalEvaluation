function plotDiffData(index, means, M, tfrs, titlestr, ylabelstr, ylimrange, faceColor)
sr = 22050;
colors = [[0, 0.4470, 0.7410]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0.4940, 0.1840, 0.5560]; [0.4660, 0.6740, 0.1880]];

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

for i=1:size(means,1)
    semilogx(tfrs(:), means(i, :), 'LineWidth',4, 'Color', colors(i, :))
end

ylim(ylimrange)
xlabel('\lambda','FontSize',24)
ylabel(ylabelstr,'FontSize',24)
set(gca, 'XTick', [1e-2,1,1e2,1e4])
legend({'midi','speech', 'electronic', 'rock'},'Location','southeast','FontSize',24)
set(gca,'Fontsize',24);

hold off

sgtitle(titlestr,'FontSize',24);
box on
end