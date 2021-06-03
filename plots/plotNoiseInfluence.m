function plotNoiseInfluence(index, means, M, tfrs, ylabelstr, ylimrange, marker)
sr = 22050;
colors = [[0, 0.4470, 0.7410]; [0.9290, 0.6940, 0.1250]; [0.4660, 0.6740, 0.1880]];

f = figure(index);
set(f, 'Position', [0 0 900 900])
set(gca,'Fontsize', 32);

hold on
set(gca, 'XScale', 'log');

for i=1:size(means,2)
    semilogx(tfrs(:, i), means(:, i), strcat('-',marker),'MarkerSize',12, 'LineWidth',4, 'Color', colors(i, :))
end

ylim(ylimrange)
xlabel('\lambda','FontSize',64)
ylabel(ylabelstr,'FontSize',48)
xlim([1e-3, 2e4])
set(gca, 'XTick', [1e-3,1e-1,1e1,1e3])
set(gca, 'YTick', [-4, -3, -2, -1, 0])
legend({'D = 32','D = 8', 'D = 2'},'Location','northeast','FontSize',32)

% hold off
box on

exportgraphics(f, strcat("noise_influence_", ylabelstr, ".png"))
end