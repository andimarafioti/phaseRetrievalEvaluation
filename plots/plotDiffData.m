function plotDiffData(index, means, marker, M, tfrs, titlestr, ylabelstr, ylimrange)
sr = 22050;
colors = [[0, 0.4470, 0.7410]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0.4940, 0.1840, 0.5560]];

figure(index);

hold on
set(gca, 'XScale', 'log');

for i=1:size(means,1)
    semilogx(tfrs(:), means(i, :), marker, 'MarkerSize',12 ,'LineWidth',4, 'Color', colors(i, :))
end

ylim(ylimrange)
xlabel('a*M/sr','FontSize',24)
ylabel(ylabelstr,'FontSize',24)
set(gca, 'XTick', [1e-2,1,1e2,1e4])
legend({'midi','speech', 'electronic', 'rock'},'Location','southeast','FontSize',24)
set(gca,'Fontsize',24);

hold off

sgtitle(titlestr,'FontSize',24);
box on
end