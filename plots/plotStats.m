
function plotStats(index, means, tfrs, ylabelstr, ylimrange)
f = figure(index);
set(f, 'Position', [10 10 750 1000])
colors = [[0, 0.4470, 0.7410]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0.4940, 0.1840, 0.5560]; [0.4660, 0.6740, 0.1880]];

hold on
set(gca, 'XScale', 'log');

for i=1:size(means,3)
    semilogx(tfrs(:, i), means(1, :, i),'LineWidth',6, "Color", colors(i, :))
end

xlabel('\lambda','FontSize',32)
set(gca, 'XTick', [1e-2,1,1e2,1e4])
xlim([1e-4, 1e4])
legend({'red = 32', "red = 16", 'red = 8', "red=4", 'red = 2'},'Location','northeast','FontSize',24)
set(gca,'Fontsize',32);
ylabel(ylabelstr,'FontSize',32)
ylim(ylimrange)
box on
hold off

end