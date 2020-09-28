
function plotTimedConvergence(index, means, red, times, ylabelstr, ylimrange)
sr = 22050;
colors = [[0, 0.4470, 0.7410]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0.4940, 0.1840, 0.5560]; [0.4660, 0.6740, 0.1880]];

f = figure(index);
set(f, 'Position', [10 10 900 420])

%First
hold on
for i=1:size(means,3)
    plot((10:100/size(means, 2):100)*times(i)/100, means(1, :, i),'LineWidth',4, 'Color', colors(i, :))
end

xlabel('Time (secs)','FontSize',24)
ylabel(ylabelstr,'FontSize',24)
set(gca, 'XTick', [1, 1e1, 2e1])
legend({'red = 32','red = 16', 'red = 8', 'red = 4', 'red = 2'},'Location','southeast','FontSize',24)
set(gca,'Fontsize',24);

ylim(ylimrange)

end