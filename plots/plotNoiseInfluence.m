function plotNoiseInfluence(index, means, M, tfrs, titlestr, ylabelstr, ylimrange, marker)
sr = 22050;
colors = [[0, 0.4470, 0.7410]; [0.9290, 0.6940, 0.1250]; [0.4660, 0.6740, 0.1880]];

f = figure(index);
set(f, 'Position', [0 0 750 1000])

hold on
set(gca, 'XScale', 'log');

for i=1:size(means,2)
    semilogx(tfrs(:, i), means(:, i), strcat('-',marker),'MarkerSize',12, 'LineWidth',4, 'Color', colors(i, :))
end

ylim(ylimrange)
xlabel('\lambda','FontSize',24)
ylabel(ylabelstr,'FontSize',24)
set(gca, 'XTick', [1e-2,1,1e2,1e4])
legend({'Red = 32','Red = 8', 'Red = 2'},'Location','southeast','FontSize',24)
set(gca,'Fontsize',24);

% hold off

sgtitle(titlestr,'FontSize',24);
box on
end