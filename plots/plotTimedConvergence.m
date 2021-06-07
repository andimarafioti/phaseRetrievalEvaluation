
function plotTimedConvergence(index, means, red, times, ylabelstr, ylimrange)
sr = 22050;
colors = [[0, 0.4470, 0.7410]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0.4940, 0.1840, 0.5560]; [0.4660, 0.6740, 0.1880]];

f = figure(index);
set(f, 'Position', [10 10 900 700])

%First
hold on
for i=1:size(means,3)
    plot(times(i)*(1:size(means(1, :, i), 2))/size(means(1, :, i), 2), means(1, :, i),'LineWidth',9, 'Color', colors(i, :))
end

xlabel('Time (secs)','FontSize',48)
ylabel(ylabelstr,'FontSize',48)
xlim([0, 50])

if contains(ylabelstr, "ODG")
    legend({'D = 32','D = 16', 'D = 8', 'D = 4', 'D = 2'},'Location','southeast','FontSize',48)
    set(gca, 'YTick', [-3, -2, -1, 0])
else
    set(gca, 'YTick', [0, 10, 20, 30, 40])
end
set(gca,'Fontsize',48);

ylim(ylimrange)
box on

exportgraphics(f, strcat("convergence_timed_", ylabelstr,".png"))

end