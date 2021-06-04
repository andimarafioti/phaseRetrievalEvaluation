
function plotThreeMethodComparison(index, means, tfrs, ylabelstr, titles, ylimrange)
sr = 22050;
colors = [[0, 0.4470, 0.7410]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0.4940, 0.1840, 0.5560]; [0.4660, 0.6740, 0.1880]];

f = figure(index);
set(f, 'Position', [10 10 1200 450])
for j=1:size(means,1)
    ha = subplot(1, 3, j);
    set(gca, 'XScale', 'log');
    set(gca,'Fontsize',48);
    xlim([1e-3, 2e4])
    set(gca, 'XTick', [1e-3,1e-1,1e1,1e3])
    xlabel('\lambda','FontSize',64)
    ylim(ylimrange)
    %set(gca, 'YTick', [-4, -3, -2, -1, 0])
    box on
    title(titles(j, :),'FontSize',48)
    hold on
    for i=1:size(means,3)
        semilogx(tfrs(:, i), means(j, :, i),'LineWidth', 9, 'Color', colors(i, :))
    end
%     set(gca,'xtick',[])
%     set(gca,'xticklabel',[])

    if j == 1
        ylabel(ylabelstr,'FontSize',48)
    end

    if j == 2
        set(gca,'ytick',[])
        set(gca,'yticklabel',[])
    end
    
    if j == 3 
        legend({'D = 32','D = 16', 'D = 8', 'D = 4', 'D = 2'},'Location','northeast','FontSize',32)
        set(gca,'ytick',[])
        set(gca,'yticklabel',[])
    end
end

exportgraphics(f, strcat("gauss_lambda_", ylabelstr, ".png"))

hold off
end