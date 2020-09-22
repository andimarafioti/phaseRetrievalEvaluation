
function plotThreeMethodComparison(index, means, tfrs, ylabelstr, titles, ylimrange)
sr = 22050;
colors = [[0, 0.4470, 0.7410]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0.4940, 0.1840, 0.5560]; [0.4660, 0.6740, 0.1880]];

f = figure(index);
set(f, 'Position', [10 10 1700 900])
[ha, pos] = tight_subplot(1, 3, [0.1 .1],[.15 .1],[.1 .02]);
for j=1:size(means,1)
    axes(ha(j));
    set(gca, 'XScale', 'log');
    set(gca,'Fontsize',32);
    set(gca, 'XTick', [1e-2,1,1e2,1e4])
    xlabel('\lambda','FontSize',32)
    ylim(ylimrange)
    box on
    title(titles(j, :),'FontSize',32)
    hold on
    for i=1:size(means,3)
        semilogx(tfrs(:, i), means(j, :, i),'LineWidth',6, 'Color', colors(i, :))
    end
    if j == 1
        ylabel(ylabelstr,'FontSize',32)
    end
    
    if j == 3 
        legend({'D = 32','D = 16', 'D = 8', 'D = 4', 'D = 2'},'Location','southeast','FontSize',24)
    end
end
    
hold off
end